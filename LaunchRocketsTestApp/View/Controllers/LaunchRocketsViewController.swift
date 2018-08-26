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
            viewModel.tableView = tableView
        }
    }
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Launch"
        setViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
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
    
}

// MARK: - Private Extension

private extension LaunchRocketsViewController {
    func setViewModel() {
        activityIndicator.startAnimating()
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
