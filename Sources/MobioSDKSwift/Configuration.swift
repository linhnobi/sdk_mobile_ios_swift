//
//  Configuration.swift
//  AppDemo
//
//  Created by LinhNobi on 30/09/2021.
//

import Foundation

public class Configuration {
    internal struct Values {
        var merchantID: String
        var token: String = ""
    }
    
    internal var values: Values
    
    public init(merchantID: String) {
        self.values = Values(merchantID: merchantID)
    }
}

public extension Configuration {
    @discardableResult
    func token(_ value: String) -> Configuration {
        values.token = value
        return self
    }
}
