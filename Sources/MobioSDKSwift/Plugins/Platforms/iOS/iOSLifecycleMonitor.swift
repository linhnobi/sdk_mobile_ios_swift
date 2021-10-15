//
//  iOSLifecycleMonitor.swift
//
//  Created by LinhNobi on 27/08/2021.
//

import Foundation
import UIKit

class iOSLifecycleMonitor {

    static let shared = iOSLifecycleMonitor()
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
    
    required init() {
        application = UIApplication.shared
    }
    
    func setupListeners(_ application: UIApplication) {
        // Configure the current life cycle events
        self.application = application
        let notificationCenter = NotificationCenter.default
        for notification in appNotifications {
            notificationCenter.addObserver(self, selector: #selector(notificationResponse(notification:)), name: notification, object: application)
        }
    }
    
    @objc
    func notificationResponse(notification: NSNotification) {

        switch (notification.name) {
        case UIApplication.didEnterBackgroundNotification:
            self.didEnterBackground(notification: notification)
        case UIApplication.willEnterForegroundNotification:
            self.applicationWillEnterForeground(notification: notification)
        case UIApplication.didFinishLaunchingNotification:
            self.didFinishLaunching(notification: notification)
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
    
    func didEnterBackground(notification: NSNotification) {
        iOSLifecycleEvents.shared.applicationDidEnterBackground(self.application)
    }
    
    func applicationWillEnterForeground(notification: NSNotification) {
        iOSLifecycleEvents.shared.applicationWillEnterForeground(self.application)
    }
    
    func didFinishLaunching(notification: NSNotification) {
        let options = notification.userInfo as? [UIApplication.LaunchOptionsKey: Any] ?? nil
        iOSLifecycleEvents.shared.application(self.application, didFinishLaunchingWithOptions: options)
    }
    
}

