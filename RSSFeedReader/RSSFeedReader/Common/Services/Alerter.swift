//
//  Alerter.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 05/09/2021.
//

import UIKit

struct Alerter {
    
    //MARK: - Private properties

    private let alertController: UIAlertController
    
    //MARK: - Initializers

    init(title: AlertTitleConstants, message: AlertMessageConstants?, preferredStyle: UIAlertController.Style) {
        alertController = UIAlertController(title: title.rawValue, message: message?.rawValue, preferredStyle: preferredStyle)
    }
    
    init(title: AlertTitleConstants, error: Error, preferredStyle: UIAlertController.Style) {
        alertController = UIAlertController(title: title.rawValue, message: error.localizedDescription, preferredStyle: preferredStyle)
    }
    
    //MARK: - Public methods
    
    func addAction(title: AlertButtonConstants, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) {
        let action = UIAlertAction(title: title.rawValue, style: style, handler: handler)
        alertController.addAction(action)
    }
    
    func showAlert(on viewController: UIViewController, completion: (() -> Void)?) {
        viewController.present(alertController, animated: true, completion: completion)
    }
    
}
