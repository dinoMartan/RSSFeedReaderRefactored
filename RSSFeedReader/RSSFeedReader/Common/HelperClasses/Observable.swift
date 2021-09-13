//
//  Observables.swift
//  RSSFeedReader
//
//  Created by Dino Martan on 07/09/2021.
//

import Foundation

class Observable<T> {
    
    //MARK: - Public properties
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    //MARK: - Private properties
    
    private var listener: ((T) -> Void)?
    
    //MARK: - Initializers
    
    init(_ value: T) {
        self.value = value
    }
    
    //MARK: - Public methods
    
    func bind (_ closure: @escaping ((T) -> Void)) {
        closure(value)
        listener = closure
    }
    
}
