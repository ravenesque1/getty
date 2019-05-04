//
//  MainViewController.swift
//  getty
//
//  Created by Raven Weitzel on 5/2/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import UIKit


class MainViewController: StatefulViewController {

    // MARK: Storyboard References

    //overall
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var toggles: [UIView]!
    @IBOutlet var toggleDetails: [UIView]!
    @IBOutlet var toggleBottomConstraints: [NSLayoutConstraint]!
    @IBOutlet var toggleImageViews: [UIImageView]!
    @IBOutlet var toggleLabels: [UILabel]!

    //display
    @IBOutlet weak var displayStackView: UIStackView!
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var displayTitleLabel: UILabel!
    @IBOutlet weak var displayLocationLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!

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

    lazy var mainViewModel = MainViewModel()

    private var state: State = .none {
        didSet {
            updateView()
        }
    }


    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureToggleAnimations()
        mainViewModel.viewDelegate = self
        updateView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        mainViewModel.loadGetty()
    }
}

// MARK: - Configuration
extension MainViewController {

    private func configureToggleAnimations() {

        for idx in 0...2 {

            let toggle = toggles[idx]
            let toggleImageView = toggleImageViews[idx]
            let detail = toggleDetails[idx]
            let constraint = toggleBottomConstraints[idx]

            toggle.addTapGestureRecognizer() {
                detail.isHidden = !detail.isHidden
                constraint.isActive = detail.isHidden
                toggleImageView.transform = toggleImageView.transform.rotated(by: .pi)
            }
        }
    }
}

// MARK: - State Changes
extension MainViewController {

    private func updateView() {
        updateDisplay(newState: state)
        updateOverview(newState: state)
        updateDetails(newState: state)
        updateCategories(newState: state)
    }

    private func updateDisplay(newState: State) {

        let displayLabels: [UILabel] = [displayTitleLabel, displayLocationLabel]

        switch newState {
        case .none:

            displayImageView.backgroundColor = UIColor.loadingGray.withAlphaComponent(0.5)

            for label in displayLabels {
                label.style(.hiddenLoading)
            }

            moreButton.imageView?.image =  UIImage(named: "expand")?.withRenderingMode(.alwaysTemplate)
            moreButton.imageView?.tintColor = .loadingGray

        default:
            break
        }
    }

    private func updateOverview(newState: State) {
        switch newState {
        case .none:

            overallReviewImageViews.forEach { imageView in
                imageView.image = nil
                imageView.backgroundColor = .loadingGray
            }

            quickHoursLabel.style(.hiddenLoading)

        default:
            break
        }
    }

    private func updateDetails(newState: State) {

        let aboutLabels: [UILabel] = [ addressLine1,
                                       addressLine2,
                                       phoneNumber,
                                       website ]

        switch newState {
        case .none:
            toggleImageViews.forEach { imageView in
                imageView.image =  UIImage(named: "expand")?.withRenderingMode(.alwaysTemplate)
                imageView.tintColor = .loadingGray
            }

            toggleLabels.forEach { $0.style(.loading) }

            aboutLabels.forEach { $0.style(.hiddenLoading) }
            hoursLabel.style(.hiddenLoading)

            website.gestureRecognizers = nil
        default:
            break
        }
    }

    private func updateCategories(newState: State) {
        switch newState {
        case .none:
            showNoCategories()
        default:
            break
        }
    }

    private func showNoHours() {
        var sampleHours: [(String, String)] = []

        for _ in 1...7 {
            sampleHours += [("8:00", "5:00")]
        }

        showHours(sampleHours)
    }

    private func showNoCategories() {
        let samples = ["Dining",
                       "Dating",
                       "Something"]

        showCategories(samples, style: .hiddenLoading)
    }

    private func showHours(_ hours: [(String, String)]) {
        let days = ["Monday\t\t",
                    "Tuesday\t\t",
                    "Wednesday\t",
                    "Thursday\t\t",
                    "Friday\t\t\t",
                    "Saturday\t\t",
                    "Sunday\t\t"]

        var hoursText = ""

        for (idx, day) in days.enumerated() {
            hoursText += "\(day): \t \(hours[idx].0)\t-\t\(hours[idx].1)\n"
        }

        hoursLabel.text = hoursText
    }

    private func showCategories(_ categories: [String], style: Style) {
        categoriesStackView.arrangedSubviews.forEach { categoriesStackView.removeArrangedSubview($0)}

        for category in categories {
            let label = UILabel()

            label.text = category
            label.layer.cornerRadius = 2.0
            label.textAlignment = .center

            switch style {
            case .hiddenLoading, .loading:
                label.layer.borderWidth = 0.0
            case .data:
                label.layer.borderWidth = 2.0
            }

            label.style(style)

            categoriesStackView.addArrangedSubview(label)
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

        self.state = state

        switch state {
        case .loading:
            showWaitOverlay()
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
            cell.update(with: state)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

