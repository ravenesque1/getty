//
//  Messaging.swift
//  getty
//
//  Created by Raven Weitzel on 5/4/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import Realm
import RealmSwift

@objcMembers class Messaging: Object, Decodable {

    dynamic var url: String = ""
    dynamic var useCaseText: String = ""

    private enum CodingKeys: String, CodingKey {
        case url
        case useCaseText = "use_case_text"
    }

    override class func primaryKey() -> String? {
        return "url"
    }

    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        url = try values.decode(String.self, forKey: .url)
        useCaseText = try values.decode(String.self, forKey: .useCaseText)

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
