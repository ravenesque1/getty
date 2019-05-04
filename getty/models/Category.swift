//
//  Category.swift
//  getty
//
//  Created by Raven Weitzel on 5/4/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import Realm
import RealmSwift

@objcMembers class Category: Object, Decodable {

    dynamic var title: String = ""
    dynamic var alias: String = ""


    private enum CodingKeys: String, CodingKey {
        case alias
        case title
    }

    override class func primaryKey() -> String? {
        return "alias"
    }

    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        alias = try values.decode(String.self, forKey: .alias)
        title = try values.decode(String.self, forKey: .title)

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
