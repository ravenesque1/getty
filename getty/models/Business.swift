//
//  Business.swift
//  getty
//
//  Created by Raven Weitzel on 5/4/19.
//  Copyright © 2019 Raven Weitzel. All rights reserved.
//

import Realm
import RealmSwift

@objcMembers class Business: Object, Decodable {

    dynamic var id: String = ""
    dynamic var alias: String = ""
    dynamic var name: String = ""
    dynamic var imageUrl: String = ""
    dynamic var isClaimed: Bool = false
    dynamic var isClosed: Bool = false
    dynamic var url: String = ""
    dynamic var phone: String = ""
    dynamic var displayPhone: String = ""
    dynamic var reviewCount: Int = 0
    let categories = List<Category>()
    dynamic var rating: Double = 0.0
    dynamic var location: Location? = nil
    dynamic var coordinates: Coordinates? = nil
    let photos = List<String>()
    dynamic var hours = List<Hours>()
    let transactions = List<String>()
    dynamic var messaging: Messaging? = nil

    private enum CodingKeys: String, CodingKey {
        case id
        case alias
        case name
        case imageUrl = "image_url"
        case isClaimed = "is_claimed"
        case isClosed = "is_closed"
        case url
        case phone
        case displayPhone = "display_phone"
        case reviewCount = "review_count"
        case categories
        case rating
        case location
        case coordinates
        case photos
        case hours
        case transactions
        case messaging
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        alias = try values.decode(String.self, forKey: .alias)
        name = try values.decode(String.self, forKey: .name)
        imageUrl = try values.decode(String.self, forKey: .imageUrl)
        isClaimed = try values.decode(Bool.self, forKey: .isClaimed)
        isClosed = try values.decode(Bool.self, forKey: .isClosed)
        url = try values.decode(String.self, forKey: .url)
        phone = try values.decode(String.self, forKey: .phone)
        displayPhone = try values.decode(String.self, forKey: .displayPhone)
        reviewCount = try values.decode(Int.self, forKey: .reviewCount)

        if let categoryList = try values.decodeIfPresent([Category].self, forKey: .categories) {
            categories.removeAll()
            categories.append(objectsIn: categoryList)
        }

        rating = try values.decode(Double.self, forKey: .rating)
        location = try values.decode(Location.self, forKey: .location)
        coordinates = try values.decode(Coordinates.self, forKey: .coordinates)

        if let photoList = try values.decodeIfPresent([String].self, forKey: .photos) {
            photos.removeAll()
            photos.append(objectsIn: photoList)
        }

        if let hoursList = try values.decodeIfPresent([Hours].self, forKey: .hours) {
            hours.removeAll()
            hours.append(objectsIn: hoursList)
        }

        if let transactionsList = try values.decodeIfPresent([String].self, forKey: .transactions) {
            transactions.removeAll()
            transactions.append(objectsIn: transactionsList)
        }

        messaging = try values.decode(Messaging.self, forKey: .messaging)
        
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
