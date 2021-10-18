//
//  iOSLifecycleEvents.swift
//
//  Created by LinhNobi on 24/08/2021.
//

import Foundation
import UIKit

class iOSLifecycleEvents: NSObject , UIApplicationDelegate {
    
    static let shared = iOSLifecycleEvents()
    var analytics: MobioSDK?
    static var versionKey = "MobioVersionKey"
    static var buildKey = "MobioBuildKeyV2"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        let previousVersion = UserDefaults.standard.string(forKey: Self.versionKey)
        let previousBuild = UserDefaults.standard.string(forKey: Self.buildKey)
        
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let currentBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let isUserOpenApp = UserDefaults.standard.bool(forKey: "appOpenFirts")
        
        if (!isUserOpenApp) {
            print("Application Open First \(isUserOpenApp)")
            //            events.track(name: "application_open_first", properties: [
            //                "version": currentVersion ?? "",
            //                "build": currentBuild ?? "",
            //                "time open": "" //Date()
            //            ])
            UserDefaults.standard.set(true, forKey: "appOpenFirts")
            UserDefaults.standard.synchronize()
        }
        
        if previousBuild != nil {
            print("Application Installed")
            //            events.track(name: "application_installed_ig6", properties: [
            //                "version": currentVersion ?? "",
            //                 "build": currentBuild ?? ""
            //            ])
            
        }
        
        if currentBuild != previousBuild {
            print("Application Updated")
            //            analytics?.track(name: <#T##String#>, properties: <#T##Any#>)
            HTTPClient.http.postMethod(event: "sdk_mobile_update_app",
                                       profile_info: [
                                        "device_id": UIDevice.current.identifierForVendor?.uuidString ?? ""
                                        //                    "push_id": ""
                                       ],
                                       properties: [
                                        "version": currentVersion ?? "",
                                        "build": currentBuild ?? "",
                                       ])
        }
        
        // Application Opened
        print("Application Open")
        let anonymousId: String = UUID().uuidString
        HTTPClient.http.postMethod(event: "sdk_mobile_open_app",
                                   profile_info: [
                                    //                                    "device_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
                                    "device": [
                                        "device_id": UIDevice.current.identifierForVendor?.uuidString ?? ""
                                        //                                                    "source": "SeaBank",
                                        //                                                    "device_name": "ios"
                                        
                                    ],
                                    "customer_id": anonymousId,
                                    "source": "APP",
                                    "push_id": [
                                        "push_id": "6949fda98338a02427e28d00bbd5203c7c0b754311ed23878577bd212cfeac0c",
                                        "app_id": "IOS",
                                        "is_logged": true,
                                        "last_access": Date().iso8601(),
                                        "os_type": 1,
                                        "lang": "VI"
                                    ]
                                   ],properties: [
                                    "version": currentVersion ?? "",
                                    "build": currentBuild ?? "",
                                   ])
        
        UserDefaults.standard.setValue(currentVersion, forKey: Self.versionKey)
        UserDefaults.standard.setValue(currentBuild, forKey: Self.buildKey)
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("vào applicationWillEnterForeground")
        // Application Opened - from background
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Application Backgrounded
        print("vào applicationDidEnterBackground")
    }
    
}
