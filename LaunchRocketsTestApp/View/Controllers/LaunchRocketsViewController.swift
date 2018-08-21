//
//  LaunchRocketsViewController.swift
//  LaunchRocketsTestApp
//
//  Created by Andrii Bilan on 8/20/18.
//  Copyright © 2018 Andrii Bilan. All rights reserved.
//

import UIKit
import SDWebImage

class LaunchRocketsViewController: UIViewController {
    
    // MARK: - Private Properties
    
   private var data = [LaunchItem]()
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

extension LaunchRocketsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRow
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCustomCell",
                                                 for: indexPath) as! CustomTableViewCell
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.launchDescription.text = cellVM.description
        cell.launchDescription.setContentOffset(CGPoint.zero, animated: false)
        cell.launchPlace.text = cellVM.location?.name
        cell.name.text = cellVM.name
        cell.activityIndicator.startAnimating()
        cell.rocketImage.sd_setImage(with: cellVM.photo,
                                     placeholderImage: nil,
                                     options: .scaleDownLargeImages) { (image, error, SDImageCasheDisk, nil) in
                                        cell.activityIndicator.stopAnimating()
                                        cell.activityIndicator.hidesWhenStopped = true
        }
        return cell
    }
    
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
           
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
                self.backgroundVIew.removeFromSuperview()
            }
        }
        viewModel.fetchData()
    }

}
