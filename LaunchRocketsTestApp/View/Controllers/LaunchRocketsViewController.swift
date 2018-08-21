//
//  LaunchRocketsViewController.swift
//  LaunchRocketsTestApp
//
//  Created by Andrii Bilan on 8/20/18.
//  Copyright © 2018 Andrii Bilan. All rights reserved.
//

import UIKit
import SDWebImage
import Bond
import ReactiveKit

class LaunchRocketsViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var data = MutableObservableArray([LaunchItem]())
    lazy private var viewModel: LaunchRocketsViewModel = {
        return LaunchRocketsViewModel()
    }()
    
    // MARK: - Private Outlet
    
    @IBOutlet weak var backgroundVIew: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: "CustomTableViewCell",
                            bundle: nil)
            tableView.register(nib,
                               forCellReuseIdentifier: "ReusableCustomCell")
        }
    }
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Launch"
        activityIndicator.startAnimating()
        setViewModel()
      
    }
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        let identifier = segue.identifier
        if identifier == "detailLaunchRocket" {
            let detailVC = segue.destination as? DetailLaunchRocketTableViewController
            detailVC?.launchInfo = sender as? LaunchItem
        }
    }
}

// MARK: - UITableViewDelegete and DataSource

extension LaunchRocketsViewController:  UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.getCellViewModel(at: indexPath)
        self.performSegue(withIdentifier: "detailLaunchRocket",
                          sender: model)
    }
    
     func tableView(_ tableView: UITableView,
                    heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 184.5
    }
}

// MARK: - Private Extension

private extension LaunchRocketsViewController {
    func setViewModel() {
        viewModel.reloadTableViewClosure = { [weak self] in
            guard let `self` = self else { return }
            self.data = MutableObservableArray(self.viewModel.launchItems)
            self.data.bind(to: self.tableView) { (item, indexPath, table) -> UITableViewCell in
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "ReusableCustomCell",
                                                         for: indexPath) as! CustomTableViewCell
                let model = item[indexPath.item]
                cell.launchDescription.text = model.description
                cell.launchDescription.setContentOffset(CGPoint.zero, animated: false)
                cell.launchPlace.text = model.location?.name
                cell.name.text = model.name
                cell.activityIndicator.startAnimating()
                cell.rocketImage.sd_setImage(with: model.photo,
                                             placeholderImage: nil,
                                             options: .scaleDownLargeImages) { (image, error, SDImageCasheDisk, nil) in
                                                cell.activityIndicator.stopAnimating()
                                                cell.activityIndicator.hidesWhenStopped = true
                }
                return cell
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.backgroundVIew.removeFromSuperview()
            }
        }
        viewModel.fetchData()
    }

}
