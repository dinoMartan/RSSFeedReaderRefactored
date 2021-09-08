//
//  RSSItemViewModel.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 06/09/2021.
//

import Foundation

final class RSSItemViewModel {
    
    //MARK: - Public properties
    
    var feedImage: String?
    var items: Observable<[Item]?> = Observable([])
    
}
