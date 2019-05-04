//
//  ReviewCell.swift
//  getty
//
//  Created by Raven Weitzel on 5/3/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {

    static let reuseIdentifier = "reviewCell"

    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var username: UILabel!

    @IBOutlet var quotes: [UILabel]!

    @IBOutlet var ratingImageViews: [UIImageView]!

    func configureInitialState() {
        reviewLabel.textColor = .loadingGray
        reviewLabel.backgroundColor = .loadingGray

        username.textColor = .loadingGray
        username.backgroundColor = .loadingGray

        for imageView in ratingImageViews {
            imageView.image = nil
            imageView.backgroundColor = .loadingGray
        }

        quotes.forEach { $0.textColor = .white }
    }
}
