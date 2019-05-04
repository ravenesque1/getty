//
//  HourUnit.swift
//  getty
//
//  Created by Raven Weitzel on 5/4/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import Realm
import RealmSwift

@objcMembers class HourUnit: Object, Decodable {

    dynamic var isOvernight: Bool = false
    dynamic var start: String = ""
    dynamic var end: String = ""
    dynamic var day: Int = 0

    private enum CodingKeys: String, CodingKey {
        case isOvernight = "is_overnight"
        case start
        case end
        case day
    }

    override class func primaryKey() -> String? {
        return "day"
    }

    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        isOvernight = try values.decode(Bool.self, forKey: .isOvernight)
        start = try values.decode(String.self, forKey: .start)
        end = try values.decode(String.self, forKey: .end)
        day = try values.decode(Int.self, forKey: .day)

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
