//
//  iOSLifecycleMonitor.swift
//  AppDemo
//
//  Created by LinhNobi on 27/08/2021.
//

import Foundation

import UIKit

class iOSLifecycleMonitor {
    
    private var application: UIApplication
    private var appNotifications: [NSNotification.Name] = [UIApplication.didEnterBackgroundNotification,
                                                   UIApplication.willEnterForegroundNotification,
                                                   UIApplication.didFinishLaunchingNotification,
                                                   UIApplication.didBecomeActiveNotification,
                                                   UIApplication.willResignActiveNotification,
                                                   UIApplication.didReceiveMemoryWarningNotification,
                                                   UIApplication.willTerminateNotification,
                                                   UIApplication.significantTimeChangeNotification,
                                                   UIApplication.backgroundRefreshStatusDidChangeNotification]

    init() {
        application = UIApplication.shared
        setupListeners()
    }
    
    
    
    func setupListeners() {
//        print("setupListeners")
        // Configure the current life cycle events
//        let notificationCenter = NotificationCenter.default
//        print("notificationCenter \(notificationCenter)")
//        debugPrint(appNotifications)
//        NotificationCenter.default.addObserver(self, selector: #selector(notificationResponse(notification:)), name: UIApplication.didFinishLaunchingNotification, object: application)
//        for notification in appNotifications {
//            print("notification \(notification)")
//            notificationCenter.addObserver(self, selector: #selector(notificationResponse(notification:)), name: .postNotifi, object: application)
//        }

    }
    
    @objc
    func notificationResponse(notification: NSNotification) {
        print("notificationResponse")
        switch (notification.name) {
        case UIApplication.didEnterBackgroundNotification:
            //            self.didEnterBackground(notification: notification)
            print("didEnterBackground")
        case UIApplication.willEnterForegroundNotification:
            self.applicationWillEnterForeground(notification: notification)
            print("applicationWillEnterForeground")
        case UIApplication.didFinishLaunchingNotification:
            //            self.didFinishLaunching(notification: notification)
            print("didFinishLaunching")
        case UIApplication.didBecomeActiveNotification:
            //            self.didBecomeActive(notification: notification)
            print("didBecomeActive")
        case UIApplication.willResignActiveNotification:
            //            self.willResignActive(notification: notification)
            print("willResignActive")
        case UIApplication.didReceiveMemoryWarningNotification:
            //            self.didReceiveMemoryWarning(notification: notification)
            print("didReceiveMemoryWarning")
        case UIApplication.significantTimeChangeNotification:
            //            self.significantTimeChange(notification: notification)
            print("significantTimeChange")
        case UIApplication.backgroundRefreshStatusDidChangeNotification:
            //            self.backgroundRefreshDidChange(notification: notification)
            print("backgroundRefreshDidChange")
        default:
            
            break
        }
    }
    
    func applicationWillEnterForeground(notification: NSNotification) {
        print("applicationWillEnterForeground")
//        analytics?.apply { (ext) in
//            if let validExt = ext as? iOSLifecycle {
//                validExt.applicationWillEnterForeground(application: application)
//            }
//        }
    }

}

extension Notification.Name {
      static let postNotifi = Notification.Name("postNotifi")
}
