//
//  Review.swift
//  getty
//
//  Created by Raven Weitzel on 5/4/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import Realm
import RealmSwift

struct ReviewResponse: Decodable {
    var reviews: [Review]
    var total: Int
    var possibleLanguages: [String]

    private enum CodingKeys: String, CodingKey {
        case reviews
        case total
        case possibleLanguages = "possible_languages"
    }
}

@objcMembers class Review: Object, Decodable {

    dynamic var id: String = ""
    dynamic var rating: Double = 0.0
    dynamic var user: User? = nil
    dynamic var text: String = ""
    dynamic var created: String = ""
    dynamic var url: String = ""

    private enum CodingKeys: String, CodingKey {
        case id
        case rating
        case name
        case user
        case text
        case created = "time_created"
        case url
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        rating = try values.decode(Double.self, forKey: .rating)
        user = try values.decode(User.self, forKey: .user)
        text = try values.decode(String.self, forKey: .text)
        created = try values.decode(String.self, forKey: .created)
        url = try values.decode(String.self, forKey: .url)

        super.init()
    }

    required init() {
        super.init()
    }

    //MARK: - Realm

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}
