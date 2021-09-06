//
//  AlertsContants.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 02/09/2021.
//

import Foundation

enum AlertButtonConstants: String {
    
    case ok = "OK"
    case cancel = "Cancel"
    case addFeed = "Add Feed"
    
}

enum AlertTitleConstants: String {
    
    case defaultTitle = "Error"
    case feedExitsts = "This feed exists!"
    case deleteFeedQuestion = "Are you sure that you want to delete this feed?"
    case feedAdded = "Feed successfully added!"
    
}

enum AlertMessageConstants: String {
    
    case defaultMessage = "Something went wrong."
    case feedAlreadyAdded = "This feed is already added to your feeds!"
    case actionCannotBeUndone = "This action cannot be undone!"
    
}
