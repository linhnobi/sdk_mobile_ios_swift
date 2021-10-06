//
//  Screen.swift
//
//
//  Created by LinhNobi on 04/10/2021.
//

import Foundation

let ScreenSettingUserDefaults = "m_screen_setting"

extension MobioSDK {
    
    public func screenSetting(title: String, controllerName: String, timeVisit: Array<Int>) {
        addConfigScreen([ScreenSetting(title: title, controllerName: controllerName, timeVisit: timeVisit)])
    }
    
    public func addConfigScreen(_ screens: [ScreenSetting]) {
        let data = screens.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: ScreenSettingUserDefaults)
    }
    
    public func getConfigScreen() -> [ScreenSetting] {
        guard let encodedData = UserDefaults.standard.array(forKey: ScreenSettingUserDefaults) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(ScreenSetting.self, from: $0) }
    }
}

public struct ScreenSetting: Codable {
    public var title: String
    public var controllerName: String
    let timeVisit: Array<Int>
}
