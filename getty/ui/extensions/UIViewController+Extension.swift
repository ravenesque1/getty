//
//  UIViewController+Extension.swift
//  getty
//
//  Created by Raven Weitzel on 5/3/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import UIKit

class StatefulViewController: UIViewController {
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        activityIndicatorView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }

    func showWaitOverlay() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }

    func hideOverlay() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
}
