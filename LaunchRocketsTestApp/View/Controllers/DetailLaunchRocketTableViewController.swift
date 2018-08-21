//
//  DetailLaunchRocketTableViewController.swift
//  LaunchRocketsTestApp
//
//  Created by Andrii Bilan on 8/21/18.
//  Copyright © 2018 Andrii Bilan. All rights reserved.
//

import UIKit

class DetailLaunchRocketTableViewController: UITableViewController {
   
    // MARK: - Public Properties
    
    var launchInfo: LaunchItem?
    
    // MARK: - Private Outlets
    
    @IBOutlet weak private var rocketImage: UIImageView!
    @IBOutlet weak private var rocketName: UILabel!
    @IBOutlet weak private var launchTime: UILabel!
    @IBOutlet weak private var launchLocation: UILabel!
    @IBOutlet weak private var agencyName: UILabel!
    @IBOutlet weak private var agencyAbbrev: UILabel!
    @IBOutlet weak private var agencyContryCode: UILabel!
    @IBOutlet weak private var missionDescription: UITextView!
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private extension

private extension DetailLaunchRocketTableViewController {
    
    func setupView() {
        self.title = "Detail"
        rocketImage.sd_setImage(with: launchInfo?.photo,
                                placeholderImage: nil,
                                options: .fromCacheOnly,
                                completed: nil)
        guard let launchInfo = launchInfo else { return }
        rocketName.text = launchInfo.name
        launchTime.text = "Launch Time: " + (launchInfo.start ?? "")
        agencyName.text = "Agency Name: " + (launchInfo.agency?.name ?? "")
        agencyAbbrev.text = "Agency abbreviation: " + (launchInfo.agency?.abbreviation ?? "")
        agencyContryCode.text = "Country Code: " + (launchInfo.agency?.countryCode ?? "")
        if let locationName = launchInfo.location?.name {
            launchLocation.text = "Location: " + locationName
        }
        missionDescription.text = "Description: " + (launchInfo.description ?? "")
        missionDescription.scrollRangeToVisible(NSMakeRange(0, 0))
    }
}
