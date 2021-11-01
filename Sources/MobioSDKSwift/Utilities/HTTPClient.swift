//
//  HTTPClient.swift
//  AppDemo
//
//  Created by LinhNobi on 27/09/2021.
//

import Foundation
import UIKit

public class HTTPClient {
    static let http = HTTPClient()
    private static let defaultAPIHost = "api-test1.mobio.vn/"
    private static let defaultSync = "dynamic-event/api/v1.0/sync"
    
    private var session: URLSession
    private var apiHost: String
    private var apiSync: String

    init(apiHost: String? = nil, apiSync: String? = nil) {

        if let apiHost = apiHost {
            self.apiHost = apiHost
        } else {
            self.apiHost = Self.defaultAPIHost
        }

        if let apiSync = apiSync {
            self.apiSync = apiSync
        } else {
            self.apiSync = Self.defaultSync
        }
        
        self.session = Self.configuredSession()
        
    }
    
    func mobioURL(for host: String, path: String) -> URL? {
        let s = "https://\(host)\(path)"
        let result = URL(string: s)
        return result
    }
    
    func postMethod(event: String, profile_info: [String: Any], properties: Any) {
        
        guard let url = mobioURL(for: apiHost, path: apiSync) else {
            print("Error: cannot create URL")
            return
        }
        
        let context = Context(name: "Test")
        
        var traits = [String: Any]()
        traits = properties as! [String : Any]
        traits.merge(["action_time": Date().iso8601()]) { (_, new) in new }
        context.staticContext["traits"] = traits
        
        var profile = [String: Any]()
        profile = profile_info
        
        let pushId = [
            "push_id": PushNotification.getDeviceToken(),
            "app_id": "IOS",
            "is_logged": true,
            "last_access": Date().iso8601(),
            "os_type": 1,
            "lang": "VI"
        ] as [String : Any]
        
        profile.merge(["push_id": pushId]) { (_, new) in new }
        profile.merge(["source": "APP"]) { (_, new) in new }
        
        let anonymousId: String = UUID().uuidString
        let params = [
            "data": [
                "anonymousId": anonymousId,
                "context": context.staticContext,
                "profile_info": profile,
                "event_key": event,
                "properties": [
                    "build": Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
                    "version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                ],
                "type": "track",
                "event_data": traits
            ]
        ]

        // Create model
        //            struct UploadData: Codable {
        //                let name: String
        //                let job: String
        ////                let age: String
        //            }
        
        // Add data to the model
        //            let uploadDataModel = UploadData(name: "Jack", job: "leader")
        
        // Convert model to JSON data
        //            guard let jsonData = try? JSONEncoder().encode(params) else {
        //                print("Error: Trying to convert model to JSON data")
        //                return
        //            }
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: [])
            
            // Create the url request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = data
            session.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error: error calling POST")
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Error: Did not receive data")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("httpResponse status \(httpResponse.statusCode)")
                    switch (httpResponse.statusCode) {
                    case 1..<300:
                        print("Success")
                    case 300..<400:
                        print("Server responded with unexpected HTTP code \(httpResponse.statusCode).")
                    case 429:
                        print("Server limited client with response code \(httpResponse.statusCode).")
                    case 400..<500:
                        print("Server rejected payload with HTTP code \(httpResponse.statusCode).")
                    default: // All 500 codes
                        print("Server rejected payload with HTTP code \(httpResponse.statusCode).")
                    }
                }
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON object")
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Couldn't print JSON in String")
                        return
                    }
                    
                    print(prettyPrintedJson)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }.resume()
        }catch{
        }
    }
}

extension HTTPClient {
    internal static func getDefaultAPIHost() -> String {
        return Self.defaultAPIHost
    }
    
    internal static func getDefaultSync() -> String {
        return Self.defaultSync
    }
    
    internal static func configuredSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        
        let token = UserDefaults.standard.string(forKey: "m_token")
        let merchantID = UserDefaults.standard.string(forKey: "m_merchant_id")
        
        configuration.allowsCellularAccess = true
        configuration.httpAdditionalHeaders = [
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Basic \(token!)",
            "X-Merchant-Id": merchantID!,
            "User-Agent": "analytics-ios \(MobioSDK.version())"
        ]
        let session = URLSession.init(configuration: configuration, delegate: nil, delegateQueue: nil)
        return session
    }
}
