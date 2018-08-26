//
//  LaunchRocketsViewModel.swift
//  LaunchRocketsTestApp
//
//  Created by Andrii Bilan on 8/20/18.
//  Copyright © 2018 Andrii Bilan. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit
class LaunchRocketsViewModel {
    
    // MARK: - Private Properties
    
    private let dataProvider = LaunchRocketsDataProvider()
    private var launchItems: [LaunchItem] = [LaunchItem]()
    
    // MARK: - Public Properties
    
    var tableView: UITableView?
    var reloadTableViewClosure: (()->())?
    
    // MARK: - Public Functions
    
    func fetchData() {
        dataProvider.fetchData { [weak self] (items, success, error) in
            guard let `self` = self else { return }
            
            if success {
                guard let items = items else { return }
                
                self.launchItems = items
                self.updateTableViewDataSource()
                self.reloadTableViewClosure?()
            }
        }
    }
    
    func updateTableViewDataSource() {
        let data = MutableObservableArray(launchItems)
        data.bind(to: self.tableView!) { [weak self] (item, indexPath, table) -> UITableViewCell in
            guard let `self` = self else { return UITableViewCell() }
            let cell = self.tableView?.dequeueReusableCell(withIdentifier: "ReusableCustomCell",
                                                           for: indexPath) as! CustomTableViewCell
            let model = item[indexPath.item]
            if let description = model.description {
                cell.launchDescription.text = "Description: " + description
            }
            cell.launchPlace.text = model.location?.name
            cell.name.text = model.name
            cell.activityIndicator.startAnimating()
            cell.rocketImage.sd_setImage(with: model.photo,
                                         placeholderImage: nil,
                                         options: .scaleDownLargeImages) { (image, error, SDImageCasheDisk, nil) in
                                            cell.activityIndicator.stopAnimating()
            }
            return cell
        }
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> LaunchItem {
        return launchItems[indexPath.row]
    }
}
