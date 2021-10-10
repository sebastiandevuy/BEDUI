//
//  BEComponent.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 10/10/21.
//

import Foundation

struct BEComponent: Decodable {
    
    /// What identifies the component. Ir may have the same type as others. Ex: Collection for X thing, Collection for Y thing
    let id: String
    
    /// Identifies the component to be instantiated in the cliend
    let type: String
    
    /// Determines the current state of the entity by hashing its content
    let hash: String
    
    let content: Data?
    
    private enum CodingKeys : String, CodingKey {
        case id, type, hash, content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.type = try container.decode(String.self, forKey: .type)
        self.hash = try container.decode(String.self, forKey: .hash)
        guard let contentDictionary = try container.decodeIfPresent([String: Any].self, forKey: .content) else {
            self.content = nil
            return
        }
        let data = try JSONSerialization.data(withJSONObject: contentDictionary, options: .prettyPrinted)
        content = data
    }
}
