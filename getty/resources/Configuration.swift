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
    case dataDisplay

    var color: UIColor {
        switch self {
        case .loading, .hiddenLoading:
            return .loadingGray
        case .data:
            return .black
        case .dataDisplay:
            return .white
        }
    }
}

extension UIColor {

    static let loadingGray = UIColor(red:0.92, green:0.90, blue:0.90, alpha:1.0)
    static let reviewGold = UIColor(red:0.96, green:0.82, blue:0.46, alpha:1.0)
    static let currentlyOpenGreen = UIColor(red:0.13, green:0.48, blue:0.23, alpha:1.0)
    static let currentlyClosedRed = UIColor(red:0.73, green:0.11, blue:0.19, alpha:1.0)
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
        case .dataDisplay:
            backgroundColor = .clear
            break
        }
    }
}


