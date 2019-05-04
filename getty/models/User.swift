//
//  User.swift
//  getty
//
//  Created by Raven Weitzel on 5/4/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import Realm
import RealmSwift

@objcMembers class User: Object, Decodable {

    dynamic var id: String = ""
    dynamic var profileUrl: String = ""
    dynamic var imageUrl: String = ""
    dynamic var name: String = ""


    private enum CodingKeys: String, CodingKey {
        case id
        case profileUrl = "profile_url"
        case name
        case imageUrl = "image_url"
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        profileUrl = try values.decode(String.self, forKey: .profileUrl)
        name = try values.decode(String.self, forKey: .name)
        imageUrl = try values.decode(String.self, forKey: .imageUrl)

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

