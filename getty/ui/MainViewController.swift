//
//  MainViewController.swift
//  getty
//
//  Created by Raven Weitzel on 5/2/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

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
    lazy var business = ModelManager.shared.realm.objects(Business.self).first

    var reviewsUpdated: NotificationToken?
    lazy var reviews: Results<Review>  = {
        let objects = ModelManager.shared.realm.objects(Review.self)

        reviewsUpdated = objects.observe { [weak self] _ in
            self?.reviewsTableView.reloadData()
        }
        return objects
    }()

    private var state: State = .none {
        didSet {
            updateView()
        }
    }

    private var isLoaded = false


    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureToggleAnimations()
        mainViewModel.viewDelegate = self
        isLoaded = true
        updateView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        mainViewModel.loadGetty()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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

        guard isLoaded else { return }

        updateDisplay(newState: state)
        updateOverview(newState: state)
        updateDetails(newState: state)
        updateCategories(newState: state)
    }

    private func updateDisplay(newState: State) {

        let displayLabels: [UILabel] = [displayTitleLabel, displayLocationLabel]

        moreButton.setImage(UIImage(named: "expand")?.withRenderingMode(.alwaysTemplate), for: .normal)

        switch newState {
        case .none:

            displayImageView.backgroundColor = UIColor.loadingGray.withAlphaComponent(0.5)

            for label in displayLabels {
                label.style(.hiddenLoading)
            }

            moreButton.imageView?.tintColor = .loadingGray

        case .success:
            displayImageView.setImage(urlString: business?.imageUrl)
            displayTitleLabel.text = business?.name

            var location = ""

            if let city = business?.location?.city {
                location += "\(city)"
            }

            if let state = business?.location?.state {
                location += ", \(state)"
            }

            displayLocationLabel.text = location

            for label in displayLabels {
                label.style(.dataDisplay)
            }

            moreButton.imageView?.tintColor = .white
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

        case .success:

            guard let rating = business?.rating else {
                return
            }

            overallReviewImageViews.setRating(rating)

            guard let isOpen = business?.hours.first?.isOpenNow else { return }

            var quickHoursText = "currently "
            quickHoursText += isOpen ? "open" : "closed"
            let quickHoursColor: UIColor = isOpen ? .currentlyOpenGreen : .currentlyClosedRed

            quickHoursLabel.text = quickHoursText
            quickHoursLabel.textColor = quickHoursColor
            quickHoursLabel.backgroundColor = .white

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
        case .success:
            toggleImageViews.forEach { imageView in
                imageView.image =  UIImage(named: "expand")?.withRenderingMode(.alwaysTemplate)
                imageView.tintColor = .black
            }

            toggleLabels.forEach { $0.style(.data) }
            aboutLabels.forEach { $0.style(.data) }

            guard let business = business else { return }

            addressLine1.text = business.location?.address1

            var line2 = ""

            if let city = business.location?.city {
                line2 += "\(city)"
            }

            if let state = business.location?.state {
                line2 += ", \(state)"
            }

            addressLine2.text = line2

            phoneNumber.text = business.displayPhone

            website.text = "Visit website"
            website.textColor = .blue

            website.addTapGestureRecognizer() {
                if let url = URL(string: business.url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }

            showBusinessHours()
            hoursLabel.style(.data)
        default:
            break
        }
    }

    private func updateCategories(newState: State) {
        switch newState {
        case .none:
            showNoCategories()
        case .success:
            guard let categories = business?.categories else { return }

            showCategories(categories.map { $0.title}, style: .data)
        default:
            break
        }
    }

    private func showBusinessHours() {
        guard let hours = business?.hours.first?.open else { return }

        let daysOpen = Array(hours.map { $0.day })

        var hoursText: [String] = []
        var hoursDict: [Int: HourUnit] = [:]

        for hour in hours {
            hoursDict[hour.day] = hour
        }

        for idx in 0...6 {
            var value: String

            if !daysOpen.contains(idx) {
                value = "closed"
            } else {
                guard let start = hoursDict[idx]?.start.fromMilitaryToStandard(),
                    let end = hoursDict[idx]?.end.fromMilitaryToStandard() else { return }
                value = "\(start)\t -\t\(end)"
            }
            hoursText.append(value)
        }

        showHours(hoursText)
    }

    private func showNoHours() {
        var sampleHours: [String] = []

        for _ in 1...7 {
            sampleHours += [("8:00 \t-\t 5:00")]
        }

        showHours(sampleHours)
    }

    private func showNoCategories() {
        let samples = ["Dining",
                       "Dating",
                       "Something"]

        showCategories(samples, style: .hiddenLoading)
    }

    private func showHours(_ hours: [String]) {
        let days = ["Monday\t\t",
                    "Tuesday\t\t",
                    "Wednesday\t",
                    "Thursday\t\t",
                    "Friday\t\t\t",
                    "Saturday\t\t",
                    "Sunday\t\t"]

        var hoursText = ""

        for (idx, day) in days.enumerated() {
            hoursText += "\(day): \t \(hours[idx])\n"
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
            default:
                break
            }

            label.style(style)

            categoriesStackView.addArrangedSubview(label)
        }
    }

    private func showGettyFetchError() {
        let alert = UIAlertController(title: "Error",
                                      message: "There was a problem loading Getty",
                                      preferredStyle: .alert)

        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let retry = UIAlertAction(title: "Retry", style: .default) { _ in self.mainViewModel.loadGetty() }

        alert.addAction(cancel)
        alert.addAction(retry)
        alert.preferredAction = retry

        self.present(alert, animated: true, completion: nil)
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
        case .error:
            showGettyFetchError()
            fallthrough
        default:
            hideOverlay()
        }
    }
}

// MARK: - TableView
extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.reuseIdentifier, for: indexPath)

        if let cell = cell as? ReviewCell {
            let reviewState: State = reviews.count > 0 ? .success : .none
            var review: Review?

            if reviews.count > 0 {
                review = reviews[indexPath.row]
            }

            cell.update(with: reviewState, review: review)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count == 0 ? 1 : reviews.count
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        if let url = URL(string: reviews[indexPath.row].url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
