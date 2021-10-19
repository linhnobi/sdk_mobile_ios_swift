//
//  MobioSDK.swift
//  AppDemo
//
//  Created by LinhNobi on 25/08/2021.
//

import Foundation

public class MobioSDK {

    internal var configuration: Configuration
    internal let iOSlife = iOSLifecycleMonitor()
    
    public init(configuration: Configuration) {
        self.configuration = configuration

        UserDefaults.standard.set(self.configuration.values.token, forKey: "m_token")
        UserDefaults.standard.set(self.configuration.values.merchantID, forKey: "m_merchant_id")
        UserDefaults.standard.synchronize()

    }
//    <E: RawEvent>
    internal func process(incomingEvent: Any) {
//        let event = incomingEvent.applyRawEventData(store: store)
//        _ = timeline.process(incomingEvent: event)
    }

}

extension MobioSDK {
    
    public func version() -> String {
        return MobioSDK.version()
    }
    
    public static func version() -> String {
        return __mobio_version
    }

}
