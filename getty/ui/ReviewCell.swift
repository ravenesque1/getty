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

    func update(with state: State) {

        let labels: [UILabel] = [reviewLabel, username]



        quotes.forEach { $0.textColor = .white }

        switch state {
        case .none:

            for label in labels {
                label.style(.hiddenLoading)
            }

            for imageView in ratingImageViews {
                imageView.image = nil
                imageView.backgroundColor = .loadingGray
            }

            quotes.forEach { $0.textColor = .white }

        case .success:

            for label in labels {
                label.style(.data)
            }

            quotes.forEach { $0.textColor = .black }

        default:
            break
        }
    }
}
