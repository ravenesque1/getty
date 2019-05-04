//
//  MainViewModel.swift
//  getty
//
//  Created by Raven Weitzel on 5/3/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

enum State {
    case none
    case loading
    case success
    case error
}

protocol MainViewDelegate {
    func didUpdateState(_ state: State)
}

class MainViewModel {


    var viewDelegate: MainViewDelegate?

    var state: State = .none {
        didSet {
            viewDelegate?.didUpdateState(state)
        }
    }

    func loadGetty() {
        state = .loading
    }

    func fetchGetty() {

    }

    func fetchGettyReviews() {

    }
}

