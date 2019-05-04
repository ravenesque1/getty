//
//  Location.swift
//  getty
//
//  Created by Raven Weitzel on 5/4/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import Realm
import RealmSwift

@objcMembers class Location: Object, Decodable {

    dynamic var address1: String = ""
    dynamic var address2: String = ""
    dynamic var address3: String = ""
    dynamic var city: String = ""
    dynamic var zipCode: String = ""
    dynamic var country: String = ""
    dynamic var state: String = ""
    let displayAddress = List<String>()
    dynamic var crossStreets: String = ""
    dynamic var created = Date.timestamp


    private enum CodingKeys: String, CodingKey {
        case address1
        case address2
        case address3
        case city
        case zipCode = "zip_code"
        case country
        case state
        case displayAddress = "display_address"
        case crossStreets = "cross_streets"
    }

    override class func primaryKey() -> String? {
        return "created"
    }

    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        address1 = try values.decode(String.self, forKey: .address1)
        address2 = try values.decode(String.self, forKey: .address2)
        address3 = try values.decode(String.self, forKey: .address3)
        city = try values.decode(String.self, forKey: .city)
        zipCode = try values.decode(String.self, forKey: .zipCode)
        country = try values.decode(String.self, forKey: .country)
        state = try values.decode(String.self, forKey: .state)

        if let displayAddressList = try values.decodeIfPresent([String].self, forKey: .displayAddress) {
            displayAddress.removeAll()
            displayAddress.append(objectsIn: displayAddressList)
        }

        crossStreets = try values.decode(String.self, forKey: .crossStreets)

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
