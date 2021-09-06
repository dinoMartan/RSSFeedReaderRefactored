//
//  Channel.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 02/09/2021.
//

import Foundation

struct Channel: Codable {
    
    var title: String?
    var description: String?
    var image: Image?
    var items: [Item]?
    
    enum CodingKeys: String, CodingKey {
        
        case title, description, image
        case items = "item"
        
    }
    
}
