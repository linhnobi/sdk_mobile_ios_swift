//
//  MobioSDK.swift
//  AppDemo
//
//  Created by LinhNobi on 25/08/2021.
//

import Foundation

public class MobioSDK {
    internal var configuration: Configuration
//    internal let iOSlife = iOSLifecycleMonitor()
    
    public init(configuration: Configuration) {
        self.configuration = configuration
        print("configuration \(configuration.values.merchantID)")
        print("configuration \(configuration.values.token)")
//        appInfo.getScreenInfo()
//        getScreenInfo()
//        postDataToURL()
//        let modelName = UIDevice.current.localizedModel // iPhone
//        let modelName = UIDevice.current.identifierForVendor
        // let uuID = UIDevice.current.identifierForVendor!.uuidString // BB53382D-7465-4A6E-8813-C69395FE3E46
//        print("machineName : \(machineName())")
//        print("modelName : \(String(describing: modelName))")
        // print("uuID : \(uuID)")
        print("iOSLifecycleEvents")
        let iOSLifecycle = iOSLifecycleEvents()
        iOSLifecycle.application()
        let iOSlife = iOSLifecycleMonitor()
//        iOSLifecycle.setupListeners()
//        let context = Context(name: "Test")
//        print("data \(context.staticContext)")
       
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





