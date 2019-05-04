//
//  GettyService.swift
//  getty
//
//  Created by Raven Weitzel on 5/3/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import UIKit
import Alamofire

enum State {
    case none
    case loading
    case success
    case error
}

class GettyService {

    var sessionManager: SessionManager
    static let shared = GettyService()

    init() {
        sessionManager = Alamofire.SessionManager.default
        sessionManager.adapter = GettyTokenAdapter()
    }

    func getBusiness(id: String, completion: @escaping (Business?, Error?) -> ()) {
        let url = "https://api.yelp.com/v3/businesses/\(id)"

        fetch(url: url) { data, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }

            do {
                let business = try JSONDecoder().decode(Business.self, from: data)
                completion(business, nil)
            } catch let decodingError {
                completion(nil, decodingError)
            }
        }
    }

    func getReviews(id: String, completion: @escaping ([Review]?, Error?) -> ()) {
        let url = "https://api.yelp.com/v3/businesses/\(id)/reviews"

        fetch(url: url) { data, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }

            do {
                let response = try JSONDecoder().decode(ReviewResponse.self, from: data)
                completion(response.reviews, nil)
            } catch let decodingError {
                completion(nil, decodingError)
            }
        }
    }

    func fetch(url: String, completion: @escaping (Data?, Error?) -> ()) {

        sessionManager.request(url).responseData { response in
            switch response.result {
            case .success:
                completion(response.result.value, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

final class GettyTokenAdapter: RequestAdapter {
    private let token: String

    init() {
        self.token = Constants.yelpAPIKey
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        urlRequest.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")

        return urlRequest
    }
}

