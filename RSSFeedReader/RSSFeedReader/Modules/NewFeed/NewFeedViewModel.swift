//
//  NewFeedViewModel.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 06/09/2021.
//

import Foundation

final class NewFeedViewModel {
    
    //MARK: - Public methods
    
    func feedAlreadyAdded(feedUrl: String) -> Bool {
        let myFeeds = CurrentUser.shared.getMyFeeds()
        if myFeeds.contains(feedUrl) {
            return true
        }
        else { return false }
    }
    
}
