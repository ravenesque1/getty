//
//  Configuration.swift
//  getty
//
//  Created by Raven Weitzel on 5/3/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import UIKit

enum Style {
    case loading
    case hiddenLoading
    case data

    var color: UIColor {
        switch self {
        case .loading, .hiddenLoading:
            return .loadingGray
        case .data:
            return .black
        }
    }
}

extension UIColor {

    static let loadingGray = UIColor(red:0.92, green:0.90, blue:0.90, alpha:1.0)
}

extension UILabel {
    func styleLoading() {
        style(.loading)
    }

    func styleHiddenLoading() {
        style(.hiddenLoading)
    }

    func style(_ style: Style) {
        textColor = style.color

        switch style {
        case .hiddenLoading:
            backgroundColor = .loadingGray
        case .data, .loading:
            backgroundColor = .white
            break
        }
    }
}


