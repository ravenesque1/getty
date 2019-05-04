//
//  Date+Extension.swift
//  getty
//
//  Created by Raven Weitzel on 5/4/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import UIKit

extension Date {
    static var timestamp: String {
        return String((Date().timeIntervalSince1970 * 1000.0).rounded())
    }
}
