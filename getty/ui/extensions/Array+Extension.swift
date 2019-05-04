//
//  Array+Extension.swift
//  getty
//
//  Created by Raven Weitzel on 5/4/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import UIKit

extension Array where Iterator.Element == UIImageView {

    func setRating(_ newRating: Double) {
        var rating = newRating

        forEach { imageView in

            var image = UIImage(named: "full")

            if rating <= 0 {
                image = UIImage(named: "empty")
            }

            if rating == 0.5 {
                image = UIImage(named: "half")
            }

            image = image?.withRenderingMode(.alwaysTemplate)

            rating -= 1
            imageView.backgroundColor = .clear
            imageView.image = image
            imageView.tintColor = .reviewGold

        }
    }
}

