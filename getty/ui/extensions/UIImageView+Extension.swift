//
//  UIImageView+Extension.swift
//  getty
//
//  Created by Raven Weitzel on 5/4/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {
    func setImage(urlString: String?, placeholder: UIImage? = nil) {
        if let url = URL(string: urlString ?? "") {
            self.af_setImage(withURL: url, placeholderImage: placeholder, imageTransition: UIImageView.ImageTransition.crossDissolve(0.25), runImageTransitionIfCached: false, completion: nil)
        } else {
            self.image = placeholder
        }
    }
}
