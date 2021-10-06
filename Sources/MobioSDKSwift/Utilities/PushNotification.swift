//
//  PushNotification.swift
//  AppDemo
//
//  Created by LinhNobi on 29/09/2021.
//

import Foundation

struct PushNotification {
    
    static func setDeviceToken(deviceToken: String) {
        UserDefaults.standard.setValue(deviceToken, forKey: "PushNotificationDeviceToken")
        UserDefaults.standard.synchronize()
    }
    
    static func getDeviceToken() -> String {
        guard let deviceToken = UserDefaults.standard.string(forKey: "PushNotificationDeviceToken") else { return "" }
        return deviceToken
    }
}


