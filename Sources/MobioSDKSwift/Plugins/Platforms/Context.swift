//
//  Context.swift
//  AppDemo
//
//  Created by LinhNobi on 24/08/2021.
//

import Foundation

public class Context {
    
    internal var staticContext = staticContextData()
    internal static var device = VendorSystem.current
    
    public required init(name: String) {}
    
    internal static func staticContextData() -> [String: Any] {
        var staticContext = [String: Any]()
        
        // Library name
        staticContext["library"] = [
            "name": "mobio-sdk-swift",
            "version": __mobio_version
        ]
        // App info
        let info = Bundle.main.infoDictionary
        let localizedInfo = Bundle.main.localizedInfoDictionary
        var app = [String: Any]()
        if let info = info {
            app.merge(info) { (_, new) in new }
        }
        
        if let localizedInfo = localizedInfo {
            app.merge(localizedInfo) { (_, new) in new }
        }
        if app.count != 0 {
            staticContext["app"] = [
                "name": app["CFBundleDisplayName"] ?? "",
                "version": app["CFBundleShortVersionString"] ?? "",
                "build": app["CFBundleVersion"] ?? "",
                "namespace": Bundle.main.bundleIdentifier ?? ""
            ]
        }
        
        insertStaticPlatformContextData(context: &staticContext)
        insertDynamicPlatformContextData(context: &staticContext)
        
        return staticContext
    }
    
    internal static func insertStaticPlatformContextData(context: inout [String: Any]) {
        // Device
        let device = Self.device
        
        context["device"] = [
            "manufacturer": device.manufacturer,
            "type": device.type,
            "model": device.model,
            "name": device.name,
            "id": device.identifierForVendor ?? ""
        ]
        
        // OS
        context["os"] = [
            "name": device.systemName,
            "version": device.systemVersion
        ]
        
        // Screen
        let screen = device.screenSize
        context["screen"] = [
            "width": screen.width,
            "height": screen.height
        ]
        
        // User-agent
        let userAgent = device.userAgent
        context["userAgent"] = userAgent
        
        // Locale
        if Locale.preferredLanguages.count > 0 {
            context["locale"] = Locale.preferredLanguages[0]
        }
        
        // TimeZone
        context["timezone"] = TimeZone.current.identifier
    }
    
    internal static func insertDynamicPlatformContextData(context: inout [String: Any]) {
        let device = Self.device
        
        // Network
        let status = device.connection
        
        var cellular = false
        var wifi = false
        var bluetooth = false
        
        switch status {
        case .online(.cellular):
            cellular = true
        case .online(.wifi):
            wifi = true
        case .online(.bluetooth):
            bluetooth = true
        default:
            break
        }
        
        // Network connectivity
        context["network"] = [
            "bluetooth": bluetooth,
            "cellular": cellular,
            "wifi": wifi
        ]
    }
}
