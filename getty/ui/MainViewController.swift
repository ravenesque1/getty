//
//  MainViewController.swift
//  getty
//
//  Created by Raven Weitzel on 5/2/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {


    @IBOutlet var toggles: [UIView]!
    @IBOutlet var toggleDetails: [UIView]!
    @IBOutlet var toggleBottomConstraints: [NSLayoutConstraint]!
    @IBOutlet weak var detailsStackView: UIStackView!

    @IBOutlet weak var hoursLabel: UILabel!

    @IBOutlet weak var reviewsTableView: UITableView!
    private var reviewCellIdentifier = "reviewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        configureToggleAnimations()
        configureHours()
    }

    private func configureHours() {

        let days = ["Monday", "Tuesday", "Wednesday",
                    "Thursday", "Friday", "Saturday",
                    "Sunday"]
        var hours = ""

        for day in days {
            hours += "\(day)\t\t: \t 8:00\t-\t5:00\n"
        }

        hoursLabel.text = hours
    }

    private func configureToggleAnimations() {

        for idx in 0...2 {

            let toggle = toggles[idx]
            let detail = toggleDetails[idx]
            let constraint = toggleBottomConstraints[idx]

            toggle.addTapGestureRecognizer() {
                detail.isHidden = !detail.isHidden
                constraint.isActive = detail.isHidden
            }
        }
    }
}

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell

        if let dequeued = tableView.dequeueReusableCell(withIdentifier: reviewCellIdentifier) {
            cell = dequeued
        } else {
            cell = UITableViewCell()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}

