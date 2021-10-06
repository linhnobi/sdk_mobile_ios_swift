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
        print("init")
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
    
    func postMethod(event: String, profile_info: Any, properties: Any) {

        guard let url = mobioURL(for: apiHost, path: apiSync) else {
            print("Error: cannot create URL")
            return
        }

        let context = Context(name: "Test")
        context.staticContext["traits"] = properties
        
        let anonymousId: String = UUID().uuidString
        let params = [
            "data": [
                "anonymousId": anonymousId,
                "context": context.staticContext,
                "profile_info": profile_info,
//                "profile_info": [
                    //                    "email": "linhtn@mobio.vn",
                    //                    "source": "APP"
//                    "device_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
                    //                    "device": [
                    //                            "device_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
                    //                            "device_name": "device_name",
                    //                            "source": "test"
                    //                        ],
                    //                    "source": "APP"
//                    "push_id": PushNotification.getDeviceToken()
//                ],
                "event_key": event,
                //                "integrations": [],
                //                "messageId": "D4878634-6C6A-4507-9E12-7CC199610FEF",
                //                "originalTimestamp": "2021-08-03T14:48:16.902+0700",
                "properties": [
                    "build": Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
                    "version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                ],
                //                "receivedAt": "2021-08-03T07:48:47.735Z",
                //                "sentAt": "2021-08-03T07:48:46.903Z",
                //                "timestamp": "2021-08-03T07:48:17.734Z",
                "type": "track",
                //                "userId": "userId",
                //                "writeKey": "B5earCuEZ7xsGNGhW4jO82ETCXCfUkNl"
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
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjdmYzBhMzNjLWJhZjUtMTFlNy1hN2MyLTAyNDJhYzE4MDAwMyIsInVzZXJuYW1lIjoiYWRtaW5AcGluZ2NvbXNob3AiLCJmdWxsbmFtZSI6Ik5nb2FuIFZUIiwicGhvbmVfbnVtYmVyIjoiKzg0OTg4NzY2NjY1IiwiZW1haWwiOiJsYW5sbkBtb2Jpby52biIsIm1lcmNoYW50X2lkIjoiMWI5OWJkY2YtZDU4Mi00ZjQ5LTk3MTUtMWI2MWRmZmYzOTI0IiwiaXNfYWRtaW4iOjEsImlzX21vYmlvIjoyLCJhdmF0YXIiOiJodHRwczovL2FwaS10ZXN0MS5tb2Jpby52bi9hZG0vc3RhdGljLzFiOTliZGNmLWQ1ODItNGY0OS05NzE1LTFiNjFkZmZmMzkyNC9hY2NvdW50cy9hdmF0YXJfN2ZjMGEzM2MtYmFmNS0xMWU3LWE3YzItMDI0MmFjMTgwMDAzMjAyMTA5MTYxMTM3NTQuanBnIiwiaWF0IjoxNjMyNzA4OTMwLjg2ODIwMzQsImlzX3N1Yl9icmFuZCI6ZmFsc2UsInVzZV9jYWxsY2VudGVyIjozLCJtZXJjaGFudF9uYW1lIjoiUGluZ2NvbVNob3AiLCJtZXJjaGFudF9hdmF0YXIiOiJodHRwczovL3QxLm1vYmlvLnZuL3N0YXRpYy8xYjk5YmRjZi1kNTgyLTRmNDktOTcxNS0xYjYxZGZmZjM5MjQvMWU0OGFiYzctNTI3Ny00ZjFjLWFmNTktMDdlOGVkNDAyZTQ3LmpwZyIsIm1lcmNoYW50X3R5cGUiOjEsInhwb2ludF9zdGF0dXMiOjMsInJvbGVfZ3JvdXAiOiJvd25lciIsIm1lcmNoYW50X2NvZGUiOiJQSU5HQ09NU0hPUCIsInR5cGUiOltdLCJleHAiOjE2MzI3OTUzMzAuOTMzMzIxNX0.2BOBwazQyDSLQ7gKt0l6QHgU-gbluANKvCQItk2vyy8"
        let merchantID = "1b99bdcf-d582-4f49-9715-1b61dfff3924"
//        configuration.timeoutIntervalForResource = 30
//        configuration.timeoutIntervalForRequest = 60
        configuration.allowsCellularAccess = true
        configuration.httpAdditionalHeaders = [
            "Content-Type": "application/json; charset=utf-8",
            "Authorization": "Bearer \(token)",
            "X-Merchant-Id": merchantID,
            "User-Agent": "analytics-ios \(MobioSDK.version())"
        ]
        let session = URLSession.init(configuration: configuration, delegate: nil, delegateQueue: nil)
        return session
    }
}
