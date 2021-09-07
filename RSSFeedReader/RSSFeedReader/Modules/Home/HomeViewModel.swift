//
//  HomeViewModel.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 06/09/2021.
//

import Foundation

final class HomeViewModel {
    
    //MARK: - Public properties
    
    var feeds: Observable<[MyRSSFeed]> = Observable([])
    
    //MARK: - Public methods
    
    func fetchMyRssFeeds(success: @escaping (() -> Void)) {
        let myFeeds = CurrentUser.shared.getMyFeeds()
        APIHandler.shared.getMultipleRSSFeeds(feedUrls: myFeeds) { [unowned self] rssFeeds in
            feeds.value = rssFeeds
            success()
        }
    }
    
    func addNewFeed(feedUrl: String, success: @escaping (() -> Void), failure: @escaping ((Error) -> Void)) {
        CurrentUser.shared.addNewFeed(url: feedUrl)
        APIHandler.shared.getOneRSSFeed(url: feedUrl) { [unowned self] rssFeed in
            guard let feed = rssFeed else { return }
            feeds.value.append(feed)
            success()
        } failure: { error in
            failure(error)
        }
    }
    
    func removeFeed(at indexPath: IndexPath) -> Bool {
        let feedIndex = indexPath.row
        let myRSSFeed = feeds.value[feedIndex]
        let feedUrl = myRSSFeed.url
        if CurrentUser.shared.removeMyFeed(url: feedUrl) {
            feeds.value.remove(at: feedIndex)
            return true
        }
        else {
            return false
        }
    }
    
}
