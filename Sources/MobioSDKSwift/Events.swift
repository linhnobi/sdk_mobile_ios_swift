//
//  Events.swift
//  AppDemo
//
//  Created by LinhNobi on 26/08/2021.
//

import Foundation
import UIKit

//public class Events {
////    private var httpClient: HTTPClient?
//    public func track(name: String, properties: Any) {
//
////        do {
////            if let properties = properties {
////                let jsonProperties = try JSON(with: properties)
////                print("if \(jsonProperties)")
////            } else {
////                print("else \(name)")
////            print("properties \(properties)")
////            }
////            let m = APIRequest()
////            m.post(event : name, properties: properties)
//        let httpClient = HTTPClient()
//        httpClient.postMethod(event : name, properties: properties)
//        // Access Shared Defaults Object
////        let userDefaults = UserDefaults.standard
////
////        // Create and Write Array of Strings
////        let array = ["One", "Two", "Three"]
////        userDefaults.set(array, forKey: "myKey")
////        let strings = userDefaults.object(forKey: "myKey")
//        // Access Shared Defaults Object
////        let userDefaults = UserDefaults.standard
//
//        // Read/Get Array of Strings
////        var strings: [Any] = userDefaults.object(forKey: "myKey") as? [Any] ?? []
//
//        // Append String to Array of Strings
////        let a = [
////            "name": name,
////            "properties": properties
////        ]
////        strings.append(a)
//
//        // Write/Set Array of Strings
////        userDefaults.set(strings, forKey: "myKey")
////        print("lenght \(strings.count)")
//
////        let t = DispatchSource.makeTimerSource()
//
////        t.schedule(deadline: .now())
////        t.setEventHandler(handler: { [weak self] in
////        print("test 123\(t)")
//            // called every so often by the interval we defined above
////        })
////
////        for item in strings {
////            print("data \(item)")
////        }
//
//
//
//
////        } catch {
////            print("Error")
////        }
//
////        var frontier = PriorityQueue(ascending: true, startingValues: [name])
////        for item in frontier {  // pq is a PriorityQueue<String>
////            print("hehe \(item)")
////        }
//    }
//}
//

extension MobioSDK {
    
    public func track(name: String, properties: Any) {
        do {
            HTTPClient.http.postMethod(event: name,
                profile_info: [
                    "device_id": UIDevice.current.identifierForVendor?.uuidString ?? ""
//                    "push_id": ""
                ],
                properties: properties)
//            let event = TrackEvent(event: name, properties: properties)

        } catch {
            print("Error Track \(error)")
        }
    }
    
    public func identify(name: String, properties: [String: Any]) {
        var profileInfo = [String: Any]()
        profileInfo = properties
        profileInfo.merge(["device_id": UIDevice.current.identifierForVendor?.uuidString ?? ""]) { (_, new) in new }
        do {
            HTTPClient.http.postMethod(event: name,
                profile_info: profileInfo,
                properties: properties)
        } catch {
            print("Error Identify \(error)")
        }
    }
    
    public func screen<P: Codable>(screenTitle: String, category: String? = nil, properties: P?) {
        do {

        } catch {
            print("Error Screen \(error)")
        }
    }
    
}
