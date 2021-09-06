//
//  Item.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 02/09/2021.
//

import Foundation

struct Item: Codable {
    
    var title: String?
    var description: String?
    var link: String?
    var image: Image?
    
}
