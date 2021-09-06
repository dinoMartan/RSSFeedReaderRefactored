//
//  APIHandler.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 01/09/2021.
//

import Foundation
import Alamofire
import XMLParsing

class APIHandler: NSObject {

    //MARK: - Public properties
    
    static let shared = APIHandler()

    //MARK: - Private properties

    private let alamofire = AF
    
    //MARK: - Public methods
    
    func getOneRSSFeed(url: String, success: @escaping ((MyRSSFeed?) -> Void), failure: @escaping ((Error) -> Void)) {
        alamofire.request(url)
            .validate()
            .response { response in
                switch response.result {
                case .failure(let error):
                    failure(error)
                case .success(let data):
                    if let data = data,
                       let rss = try? XMLDecoder().decode(RSS.self, from: data) {
                        let myFeed = MyRSSFeed(url: url, feed: rss)
                        success(myFeed)
                    }
                }
            }
    }
    
    /// Fetching [RSS] for the given array of URLs
    func getMultipleRSSFeeds(feedUrls: [String], success: @escaping (([MyRSSFeed]) -> Void)) {
        var myRssFeeds: [MyRSSFeed] = []
        let group = DispatchGroup()
        
        for url in feedUrls {
            if !url.contains("https") { continue }
            group.enter()
            alamofire.request(url)
                .validate()
                .response { response in
                    switch response.result {
                    case .failure(_):
                        group.leave()
                    case .success(let data):
                        if let data = data,
                           let rss = try? XMLDecoder().decode(RSS.self, from: data) {
                            let myFeed = MyRSSFeed(url: url, feed: rss)
                            myRssFeeds.append(myFeed)
                        }
                        group.leave()
                    }
                }
        }
        
        group.notify(queue: .main) {
            success(myRssFeeds)
        }
    }
    
    // API docs: https://developer.feedly.com/v3/search/

    func searchFeeds(query: String, success: @escaping ((SearchResult) -> Void), failure: @escaping ((Error) -> Void)) {
        let parameters: [String:Any] = [
            "query": query,
            "count": 30,
            "locale": Language.en.rawValue
        ]
        alamofire.request(APIConstants.searchFeedsEndpoint.rawValue, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: SearchResult.self) { response in
                switch response.result {
                case .failure(let error):
                    failure(error)
                case .success(let searchResult):
                    success(searchResult)
                }
            }
    }
    
}
