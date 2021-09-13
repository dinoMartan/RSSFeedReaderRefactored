//
//  RSSSearchViewModel.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 06/09/2021.
//

import Foundation

final class RSSSearchViewModel {
    
    //MARK: - Public properties
    
    var searchResult: Observable<SearchResult?> = Observable(nil)
    
    //MARK: - Public methods
    
    func fetchData(query: String, success: @escaping (() -> Void), failure: @escaping ((Error) -> Void)) {
        APIHandler.shared.searchFeeds(query: query) { [unowned self] searchRes in
            searchResult.value = searchRes
            success()
        } failure: { error in
            failure(error)
        }
    }
    
    func addNewFeed(feedUrl: String, addFeed: @escaping ((String) -> Void), feedExists: @escaping (() -> Void)) {
        let url = feedUrl
            .replacingOccurrences(of: "feed/", with: "")
            .replacingOccurrences(of: "http", with: "https")
        
        if feedAlreadyAdded(feedUrl: url) {
            feedExists()
        }
        else {
            addFeed(url)
        }
    }
    
    //MARK: - Private methods
    
    private func feedAlreadyAdded(feedUrl: String) -> Bool {
        let myFeeds = CurrentUser.shared.getMyFeeds()
        if myFeeds.contains(feedUrl) {
            return true
        }
        else { return false }
    }
    
}
