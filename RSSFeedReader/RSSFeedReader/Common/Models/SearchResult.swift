//
//  SearchResult.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 03/09/2021.
//

import Foundation

// MARK: - SearchResult

struct SearchResult: Codable {
    
    let scheme, queryType: String?
    let results: [Result]?
    
}

// MARK: - Result

struct Result: Codable {
    
    let coverage, averageReadTime, coverageScore: Double?
    let estimatedEngagement: Int?
    let tagCounts: [String: Int]?
    let totalTagCount: Int?
    let feedID: String?
    let lastUpdated, score: Double?
    let language: Language?
    let id: String?
    let resultDescription: String?
    let contentType: ContentType?
    let title: String?
    let website: String?
    let partial: Bool?
    let topics: [String]?
    let updated: Int?
    let velocity: Double?
    let subscribers: Int?
    let deliciousTags: [String]?
    let websiteTitle: String?
    let iconURL, visualURL, coverURL: String?
    let coverColor, twitterScreenName: String?
    let twitterFollowers: Int?
    let state: String?

    enum CodingKeys: String, CodingKey {
        
        case coverage, averageReadTime, coverageScore, estimatedEngagement, tagCounts, totalTagCount
        case feedID = "feedId"
        case lastUpdated, score, language, id
        case resultDescription = "description"
        case contentType, title, website, partial, topics, updated, velocity, subscribers, deliciousTags, websiteTitle
        case iconURL = "iconUrl"
        case visualURL = "visualUrl"
        case coverURL = "coverUrl"
        case coverColor, twitterScreenName, twitterFollowers, state
        
    }
    
}

enum ContentType: String, Codable {
    
    case article = "article"
    case longform = "longform"
    case video = "video"
    case audio = "audio"
    
}

enum Language: String, Codable {
    
    case en = "en"
    case id = "id"
    
}
