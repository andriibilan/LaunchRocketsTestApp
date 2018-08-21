//
//  CustomTableViewCell.swift
//  LaunchRocketsTestApp
//
//  Created by Andrii Bilan on 8/20/18.
//  Copyright © 2018 Andrii Bilan. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var rocketImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var launchPlace: UILabel!
    @IBOutlet weak var launchDescription: UITextView! 
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
}
