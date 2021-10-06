//
//  VendorSystem.swift
//  AppDemo
//
//  Created by LinhNobi on 23/08/2021.
//

import Foundation

internal struct ScreenSize {
    let width: Double
    let height: Double
}

internal enum ConnectionType {
    case cellular // Di Động
    case wifi
    case bluetooth
}

internal enum ConnectionStatus {
    case offline
    case online(ConnectionType)
    case unknown
}

internal class VendorSystem {
    var manufacturer: String {
        return "unknown"
    }
    
    var type: String {
        return "unknown"
    }
    
    var model: String {
        return "unknown"
    }
    
    var name: String {
        return "unknown"
    }
    
    var identifierForVendor: String? {
        return nil
    }
    
    var systemName: String {
        return "unknown"
    }
    
    var systemVersion: String {
        return ""
    }
    
    var screenSize: ScreenSize {
        return ScreenSize(width: 0, height: 0)
    }
    
    var userAgent: String? {
        return "unknown"
    }
    
    var connection: ConnectionStatus {
        return ConnectionStatus.unknown
    }
    
    static var current: VendorSystem {
        #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
        return iOSVendorSystem()
//        #elseif os(watchOS)
//        return watchOSVendorSystem()
//        #elseif os(Linux)
//        return LinuxVendorSystem()
        #else
        return VendorSystem()
        #endif
    }
}

