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
        let anonymousId: String = UUID().uuidString
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let currentBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        let isUserOpenApp = UserDefaults.standard.bool(forKey: "appOpenFirts")
        
        if (!isUserOpenApp) {
            print("Application Open First \(isUserOpenApp)")
            HTTPClient.http.postMethod(event: "sdk_mobile_test_open_first_app",
                                       profile_info: [
                                        "device": [
                                            "device_id": UIDevice.current.identifierForVendor?.uuidString ?? ""
                                            //                                                    "source": "SeaBank",
                                            //                                                    "device_name": "ios"
                                        ],
                                        "customer_id": anonymousId,
                                        "source": "APP",
                                       ],properties: [
                                        "version": currentVersion ?? "",
                                        "build": currentBuild ?? "",
                                       ])
            UserDefaults.standard.set(true, forKey: "appOpenFirts")
            UserDefaults.standard.synchronize()
        }
        
        if previousBuild != nil {
            print("Application Installed")
            HTTPClient.http.postMethod(event: "sdk_mobile_test_installed_app",
                                       profile_info: [
                                        "device": [
                                            "device_id": UIDevice.current.identifierForVendor?.uuidString ?? ""
                                        ],
                                        "customer_id": anonymousId,
                                        "source": "APP",
                                       ],properties: [
                                        "version": currentVersion ?? "",
                                        "build": currentBuild ?? "",
                                       ])
        }
        
        if currentBuild != previousBuild {
            print("Application Updated")
            //            analytics?.track(name: "sdk_mobile_test_open_update_app",
            //                             properties: [
            //                "version": currentVersion ?? "",
            //                "build": currentBuild ?? "",
            //            ])
            
            HTTPClient.http.postMethod(event: "sdk_mobile_test_open_update_app",
                                       profile_info: [
                                        "device_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
                                        "customer_id": anonymousId,
                                       ],
                                       properties: [
                                        "version": currentVersion ?? "",
                                        "build": currentBuild ?? "",
                                       ])
        }
        
        // Application Opened
        print("Application Open")
        HTTPClient.http.postMethod(event: "sdk_mobile_test_open_app",
                                   profile_info: [
                                    "device": [
                                        "device_id": UIDevice.current.identifierForVendor?.uuidString ?? ""
                                    ],
                                    "customer_id": anonymousId,
                                    "source": "APP",
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
