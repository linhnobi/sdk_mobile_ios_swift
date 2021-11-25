//
//  File.swift
//  
//
//  Created by LinhNobi on 05/10/2021.
//

import Foundation
import UIKit

public class CommonFunc {
    static let commonFunc = CommonFunc()

    static func getConfigAllScreen() -> [ScreenSetting] {
        guard let encodedData = UserDefaults.standard.array(forKey: ScreenSettingUserDefaults) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(ScreenSetting.self, from: $0) }
    }
    
    static func getControllerName() -> String {
        let topVC = UIApplication.getTopViewController()
        let className = NSStringFromClass(topVC!.classForCoder).toString()
        let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String
        
        var controllerName = className.replacingOccurrences(of: appName!, with: "", options: NSString.CompareOptions.literal, range:nil)
        controllerName = controllerName.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil)
        
        return controllerName
    }
    
    static func getScreenView(controllerName: String, screens: Array<ScreenSetting>) -> [ScreenSetting]{
        var result: Array<ScreenSetting> = []
        for screen in screens {
            if screen.controllerName.toString() == controllerName {
                result = [screen]
            }
        }
        return result
    }
}
