//
//  MainViewController.swift
//  getty
//
//  Created by Raven Weitzel on 5/2/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {

    // MARK: Storyboard References

    //overall
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var toggles: [UIView]!
    @IBOutlet var toggleDetails: [UIView]!
    @IBOutlet var toggleBottomConstraints: [NSLayoutConstraint]!

    //display
    @IBOutlet weak var displayStackView: UIStackView!
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var displayTitleLabel: UILabel!
    @IBOutlet weak var displayLocationLabel: UILabel!

    //overview
    @IBOutlet var overallReviewImageViews: [UIImageView]!
    @IBOutlet weak var quickHoursLabel: UILabel!

    //details
    @IBOutlet weak var detailsStackView: UIStackView!

    @IBOutlet weak var addressLine1: UILabel!
    @IBOutlet weak var addressLine2: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var website: UILabel!

    @IBOutlet weak var hoursLabel: UILabel!

    @IBOutlet weak var reviewsTableView: UITableView!

    //categories
    @IBOutlet weak var categoriesStackView: UIStackView!

    // MARK: Properties

    private var mainViewModel = MainViewModel()


    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

       configureInitialState()
    }
}

// MARK: - Configuration
extension MainViewController {

    private func configureInitialState() {
        displayImageView.backgroundColor = UIColor.loadingGray.withAlphaComponent(0.5)

        displayTitleLabel.textColor = .loadingGray
        displayTitleLabel.backgroundColor = .loadingGray

        displayLocationLabel.textColor = .loadingGray
        displayLocationLabel.backgroundColor = .loadingGray

        overallReviewImageViews.forEach { imageView in
            imageView.image = nil
            imageView.backgroundColor = .loadingGray
        }

        quickHoursLabel.textColor = .loadingGray
        quickHoursLabel.backgroundColor = .loadingGray

        addressLine1.textColor = .loadingGray
        addressLine1.backgroundColor = .loadingGray
        addressLine2.textColor = .loadingGray
        addressLine2.backgroundColor = .loadingGray
        phoneNumber.textColor = .loadingGray
        phoneNumber.backgroundColor = .loadingGray

        website.textColor = .loadingGray
        website.backgroundColor = .loadingGray
        website.gestureRecognizers = nil

        hoursLabel.backgroundColor = .loadingGray
        hoursLabel.textColor = .loadingGray

        configureSampleCategories()

        configureToggleAnimations()
    }

    private func configureHours() {

        let days = ["Monday\t\t",
                    "Tuesday\t\t",
                    "Wednesday\t",
                    "Thursday\t\t",
                    "Friday\t\t\t",
                    "Saturday\t\t",
                    "Sunday\t\t"]
        var hours = ""

        for day in days {
            hours += "\(day): \t 8:00\t-\t5:00\n"
        }

        hoursLabel.text = hours
    }

    private func configureSampleCategories() {
        let samples = ["Dining",
                          "Dating",
                          "Something"]

        configureCategories(samples)

        for subview in categoriesStackView.arrangedSubviews {
            if let label = subview as? UILabel {
                label.textColor = .loadingGray
                label.backgroundColor = .loadingGray
                label.layer.borderWidth = 0.0
            }
        }
    }

    private func configureCategories(_ categories: [String]) {
        categoriesStackView.arrangedSubviews.forEach { categoriesStackView.removeArrangedSubview($0)}



        for category in categories {
            let label = UILabel()
            label.text = category
            label.layer.borderWidth = 2.0
            label.layer.cornerRadius = 2.0
            label.textAlignment = .center

            categoriesStackView.addArrangedSubview(label)
        }
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

// MARK: - Actions
extension MainViewController {
    @IBAction func moreAction(_ sender: Any) {

        if let origin = displayStackView.superview {
            let start = origin.convert(displayStackView.frame.origin, to: scrollView)
            scrollView.scrollRectToVisible(CGRect(x:0, y:start.y,width: 1,height: scrollView.frame.height), animated: true)

        }
    }
}

// MARK: - Data Updating
extension MainViewController: MainViewDelegate {
    func didUpdateState(_ state: State) {
        switch state {
        default:
            break
        }
    }
}

// MARK: - TableView
extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.reuseIdentifier, for: indexPath)

        if let cell = cell as? ReviewCell {
            cell.configureInitialState()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}

