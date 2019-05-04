//
//  MainViewModel.swift
//  getty
//
//  Created by Raven Weitzel on 5/3/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

protocol MainViewDelegate {
    func didUpdateState(_ state: State)
}

class MainViewModel {

    private var gettyId = "zRlDhJgcwXEphTUhMaCfyw"

    var viewDelegate: MainViewDelegate?

    var state: State = .none {
        didSet {
            viewDelegate?.didUpdateState(state)
        }
    }

    func loadGetty() {
        state = .loading

        fetchGetty()
    }

    private func fetchGetty() {
        GettyService.shared.getBusiness(id: gettyId) { business, error in
            guard let business = business, error == nil else {
                self.state = .error
                return
            }

            let realm = ModelManager.shared.realm

            try? realm.write {
                realm.add(business, update: true)
            }

            self.state = .success
        }

        silentFetchGettyReviews()
    }

    private func silentFetchGettyReviews() {
        GettyService.shared.getReviews(id: gettyId) { reviews, error in
            guard let reviews = reviews, error == nil else {
                return
            }

            let realm = ModelManager.shared.realm

            try? realm.write {
                realm.add(reviews, update: true)
            }
        }
    }
}

