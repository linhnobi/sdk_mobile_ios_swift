//
//  iOSLifecycleEvents.swift
//  AppDemo
//
//  Created by LinhNobi on 24/08/2021.
//

import Foundation
import UIKit
//: iOSLifecycle
class iOSLifecycleEvents {
    
    var analytics: MobioSDK?
    
    static var versionKey = "MobioVersionKey"
    static var buildKey = "MobioBuildKeyV2"
    
    init() {
        
    }
    func application() {
        
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
        HTTPClient.http.postMethod(event: "sdk_mobile_open_app",
                                   profile_info: [
                                    //                                    "device_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
                                    "device": [
                                        "device_id": UIDevice.current.identifierForVendor?.uuidString ?? ""
                                        //                                                    "source": "SeaBank",
                                        //                                                    "device_name": "ios"
                                        
                                    ],
                                    "source": "APP",
                                    //                    "push_id": ""
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

//extension UIViewController {
//@objc dynamic func _tracked_viewWillAppear(_ animated: Bool) {
//
//    print("ClassName@: "+String(describing: type(of: self)))
//    _tracked_viewWillAppear(animated)
//}



//static func swizzle() {
//    if self != UIViewController.self {
//        return
//    }
//    let _: () = {
//        let originalSelector =
//            #selector(UIViewController.viewWillAppear(_:))
//        let swizzledSelector =
//            #selector(UIViewController._tracked_viewWillAppear(_:))
//        let originalMethod =
//            class_getInstanceMethod(self, originalSelector)
//        let swizzledMethod =
//            class_getInstanceMethod(self, swizzledSelector)
//        method_exchangeImplementations(originalMethod!, swizzledMethod!);
//    }()
//}
//}



