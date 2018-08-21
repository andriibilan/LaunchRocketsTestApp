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
    var launchItems: [LaunchItem] = [LaunchItem]()
    
    // MARK: - Public Properties
    
    var numberOfRow: Int {
        return launchItems.count
    }
    
    var reloadTableViewClosure: (()->())?
    
    // MARK: - Public Functions
    
    func fetchData() {
        dataProvider.fetchData { [weak self] (items, success, error) in
            guard let `self` = self else { return }

            if success {
                guard let items = items else { return }
                
                self.launchItems = items
                
                self.reloadTableViewClosure?()
            }
        }
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> LaunchItem {
        return launchItems[indexPath.row]
    }
}
