//
//  File.swift
//  
//
//  Created by LinhNobi on 02/10/2021.
//

import Foundation

// MARK: - Event Types

public protocol RawEvent: Codable {
    var type: String? { get set }
    var profile_info: Any {get set}
    var anonymousId: String? { get set }
    var event_key: String? { get set }
//    var userId: String? { get set }
    var timestamp: String? { get set }
    
    var context: JSON? { get set }
//    var integrations: JSON? { get set }
//    var metrics: [JSON]? { get set }
}

public struct TrackEvent {
    public var type: String? = "track"
    
    
    public var event: String
    public var properties: Any
    
    public init(event: String, properties: Any) {
        self.event = event
        self.properties = properties
        
        debugPrint("event \(event)")
        debugPrint("properties \(properties)")
        
    }
    

}




