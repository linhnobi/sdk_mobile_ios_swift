//
//  File.swift
//  
//
//  Created by LinhNobi on 13/10/2021.
//

import UIKit
import Combine

public class Scroll: NSObject {
    static let shared = Scroll()
    public func trackScrollView(_ scrollView: UIScrollView) {
        scrollView.delegate = self
    }
}

extension Scroll: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let height = scrollView.contentSize.height
        let viewed = scrollView.contentOffset.y + scrollView.bounds.size.height
        let pagePercentScrolled = viewed / height * 100

        print("precent \(Int(pagePercentScrolled))")
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        //        let height = scrollView.contentSize.height
        //            let viewed = scrollView.contentOffset.y + scrollView.bounds.size.height
        //            let pagePercentScrolled = viewed / height * 100.0
        //        print("precent \(pagePercentScrolled)")
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    
}


public class Test: NSObject {
    static let shared = Test()
    private var appNotifications: [NSNotification.Name] = [UIApplication.didEnterBackgroundNotification,
                                                   UIApplication.willEnterForegroundNotification,
                                                   UIApplication.didFinishLaunchingNotification,
                                                   UIApplication.didBecomeActiveNotification,
                                                   UIApplication.willResignActiveNotification,
                                                   UIApplication.didReceiveMemoryWarningNotification,
                                                   UIApplication.willTerminateNotification,
                                                   UIApplication.significantTimeChangeNotification,
                                                   UIApplication.backgroundRefreshStatusDidChangeNotification]
    public func trackScrollView(_ application: UIApplication) {
//        let iOSlife = analytics?.appNotifications2()
        let notificationCenter = NotificationCenter.default
        for notification in appNotifications {
            notificationCenter.addObserver(self, selector: #selector(notificationResponse(notification:)), name: notification, object: application)
        }
    }
    
        @objc
        func notificationResponse(notification: NSNotification) {
            print("notificationResponse")
//            analytics?.notificationResponse(notification: notification)
        }
}

extension Test: UIApplicationDelegate {
    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        print("UIApplicationDelegate")
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        print("Application Opened")
    }
    
    func applicationDidEnterBackground(application: UIApplication) {

        
        print("Application Backgrounded")
    }
}
