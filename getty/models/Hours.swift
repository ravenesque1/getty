//
//  Hours.swift
//  getty
//
//  Created by Raven Weitzel on 5/4/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import Realm
import RealmSwift

@objcMembers class Hours: Object, Decodable {
    let open = List<HourUnit>()
    dynamic var hoursType: String = ""
    dynamic var isOpenNow: Bool = false
    dynamic var created = Date.timestamp

    override class func primaryKey() -> String? {
        return "created"
    }

    private enum CodingKeys: String, CodingKey {
        case open
        case hoursType = "hours_type"
        case isOpenNow = "is_open_now"
    }

    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        if let openList = try values.decodeIfPresent([HourUnit].self, forKey: .open) {
            open.removeAll()
            open.append(objectsIn: openList)
        }

        hoursType = try values.decode(String.self, forKey: .hoursType)
        isOpenNow = try values.decode(Bool.self, forKey: .isOpenNow)

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
