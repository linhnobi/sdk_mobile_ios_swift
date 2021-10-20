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
        addConfigScreen(ScreenSetting(title: title, controllerName: controllerName, timeVisit: timeVisit))
    }
    
    private func addConfigScreen(_ screens: ScreenSetting) {
        var configScreen = getConfigScreen()
        if configScreen.count == 0 {
            configScreen.append(ScreenSetting(title: screens.title, controllerName: screens.controllerName, timeVisit: screens.timeVisit))
        } else {
            for (index,item) in configScreen.enumerated() {
                    if (screens.controllerName == item.controllerName) {
                        configScreen[index].timeVisit = screens.timeVisit
                        configScreen[index].title = screens.title
                        let data = configScreen.map { try? JSONEncoder().encode($0) }
                        UserDefaults.standard.set(data, forKey: ScreenSettingUserDefaults)
                        UserDefaults.standard.synchronize()
                        return
                    }
                }
            configScreen.append(ScreenSetting(title: screens.title, controllerName: screens.controllerName, timeVisit: screens.timeVisit))
        }
        let data = configScreen.map { try? JSONEncoder().encode($0) }

        UserDefaults.standard.set(data, forKey: ScreenSettingUserDefaults)
        UserDefaults.standard.synchronize()
    }
    
    private func getConfigScreen() -> [ScreenSetting] {
        guard let encodedData = UserDefaults.standard.array(forKey: ScreenSettingUserDefaults) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(ScreenSetting.self, from: $0) }
    }
    
}

public struct ScreenSetting: Codable {
    public var title: String
    public var controllerName: String
    public var timeVisit: Array<Int>
}

