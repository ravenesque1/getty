//
//  String+Extension.swift
//  getty
//
//  Created by Raven Weitzel on 5/4/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import UIKit

extension String {
    func fromMilitaryToStandard() -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"

        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date!)
    }
}
