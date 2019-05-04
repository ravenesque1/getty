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

    @IBOutlet var ratingImageViews: [UIImageView]!

    func update(with state: State, review: Review?) {

        let labels: [UILabel] = [reviewLabel, username]

        switch state {
        case .none:

            for label in labels {
                label.style(.hiddenLoading)
            }

            for imageView in ratingImageViews {
                imageView.image = nil
                imageView.backgroundColor = .loadingGray
            }

        case .success:

            guard let review = review else { return }

            for label in labels {
                label.style(.data)
            }

            let reviewText = review.text
            let prompt  = " (see more)"

            let attributedString = NSMutableAttributedString(string: reviewText)

            let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
            let boldString = NSMutableAttributedString(string: prompt, attributes: attrs)
            
            attributedString.append(boldString)

            reviewLabel.attributedText = attributedString
            username.text = review.user?.name

            ratingImageViews.setRating(review.rating)

        default:
            break
        }
    }
}
