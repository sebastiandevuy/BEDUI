//
//  BEComponent.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 10/10/21.
//

import Foundation
import UIKit

struct BEComponent: Decodable {
    
    /// What identifies the component. Ir may have the same type as others. Ex: Collection for X thing, Collection for Y thing
    let id: String
    
    /// Identifies the component to be instantiated in the cliend
    let type: String
    
    /// Payload with relevant view data. To be decoded when needed to the appropriate entity.
    let content: Data?

    // Events to bind
    let eventConfiguration: AlchemistLiteEventConfiguration?
    
    private enum CodingKeys : String, CodingKey {
        case id, type, hash, content, eventConfiguration
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.type = try container.decode(String.self, forKey: .type)
        self.eventConfiguration = try container.decodeIfPresent(AlchemistLiteEventConfiguration.self, forKey: .eventConfiguration)
        guard let contentDictionary = try container.decodeIfPresent([String: Any].self, forKey: .content) else {
            self.content = nil
            return
        }
        let data = try JSONSerialization.data(withJSONObject: contentDictionary, options: .prettyPrinted)
        content = data
    }
}

struct AlchemistLiteEventConfiguration: Decodable {
    let events: [AlchemistLiteEvent]?
    let origins: [String]?
}

struct AlchemistLiteEvent: Decodable {
    //Evaluate Origin
    let eventType: String
    let targetId: Int
    let eventBody: [String: Any]

    private enum CodingKeys : String, CodingKey {
        case eventType, targetId, eventBody
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.eventType = try container.decode(String.self, forKey: .eventType)
        self.targetId = try container.decode(Int.self, forKey: .targetId)
        guard let eventBodyDictionary = try container.decodeIfPresent([String: Any].self, forKey: .eventBody) else {
            self.eventBody = [String:Any]()
            return
        }
        self.eventBody = eventBodyDictionary
    }
}
