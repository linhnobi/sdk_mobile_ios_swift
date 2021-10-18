//
//  ViewControllerLifecycle.swift
//  AppDemo
//
//  Created by LinhNobi on 21/09/2021.
//

import UIKit

// MARK: - Declaration
public protocol ViewControllerLifeCycleBehavior {
    func afterLoading(_ viewController: UIViewController)
    func beforeAppearing(_ viewController: UIViewController)
    func afterAppearing(_ viewController: UIViewController)
    func beforeDisappearing(_ viewController: UIViewController)
    func afterDisappearing(_ viewController: UIViewController)
    func beforeLayingOutSubviews(_ viewController: UIViewController)
    func afterLayingOutSubviews(_ viewController: UIViewController)
}

// MARK: - Default implementation
extension ViewControllerLifeCycleBehavior {
    func afterLoading(_ viewController: UIViewController) {}
    func beforeAppearing(_ viewController: UIViewController) {}
    func afterAppearing(_ viewController: UIViewController) {}
    func beforeDisappearing(_ viewController: UIViewController) {}
    func afterDisappearing(_ viewController: UIViewController) {}
    func beforeLayingOutSubviews(_ viewController: UIViewController) {}
    func afterLayingOutSubviews(_ viewController: UIViewController) {}
}

// MARK: - UIViewController + Lifecycle Behavior
public extension UIViewController {
    
    final class LifeCycleBehaviorViewController: UIViewController {
        
        private let behaviors: [ViewControllerLifeCycleBehavior]
        weak var timer:Timer?
        var countTime: Int = 0
        
        init(behaviors: [ViewControllerLifeCycleBehavior]) {
            self.behaviors = behaviors
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            view.isHidden = true
            timer = nil
            applyBehaviors { $0.afterLoading($1) }
        }
        
        public override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            applyBehaviors { $0.beforeAppearing($1) }
        }
        
        public override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            applyBehaviors { $0.afterAppearing($1) }
//            getScreenView2()
            self.timer?.invalidate()
            self.timer = nil
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            print("Start : \(Date())")
            
//            let configScreens = getConfigAllScreen()
//            print("configScreens \(configScreens)")
        }
        
        public override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            applyBehaviors { $0.beforeDisappearing($1) }

            print("End : \(Date())")
        }
        
        public override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            applyBehaviors { $0.afterDisappearing($1) }
            print("viewDidDisappear")
            self.timer?.invalidate()
        }
        
        public override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            applyBehaviors { $0.beforeLayingOutSubviews($1) }
        }
        
        public override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            applyBehaviors { $0.afterLayingOutSubviews($1) }
        }
        
        private func applyBehaviors(
            handler: (_ behavior: ViewControllerLifeCycleBehavior, _ viewController: UIViewController) -> Void
        ) {
            guard let parentViewController = parent else { return }
            behaviors.forEach { handler($0, parentViewController) }
            self.timer?.invalidate()
            self.timer = nil
        }
        
        private func getConfigAllScreen() -> [ScreenSetting] {
            guard let encodedData = UserDefaults.standard.array(forKey: ScreenSettingUserDefaults) as? [Data] else {
                return []
            }

            return encodedData.map { try! JSONDecoder().decode(ScreenSetting.self, from: $0) }
        }
        
        private func getControllerName() -> String {
            let topVC = UIApplication.getTopViewController()
            let className = NSStringFromClass(topVC!.classForCoder).toString()
            let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String

            var controllerName = className.replacingOccurrences(of: appName!, with: "", options: NSString.CompareOptions.literal, range:nil)
            controllerName = controllerName.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range:nil)

            return controllerName
        }
        
        private func getScreenView(controllerName: String, screens: Array<ScreenSetting>) -> [ScreenSetting]{
            var result: Array<ScreenSetting> = []
            for screen in screens {
                if screen.controllerName.toString() == controllerName {
                    result = [screen]
                }
            }
            return result
        }
        private func getScreenView2() {
            var result: Array<ScreenSetting> = []
            let screens = getConfigAllScreen()
            let controllerName = getControllerName()
            for screen in screens {
                if screen.controllerName.toString() == controllerName {
                    result.append(ScreenSetting(title: screen.title, controllerName: screen.controllerName, timeVisit: screen.timeVisit))
                }
            }
            UserDefaults.standard.set(result, forKey: "m_screen_config_view")
            UserDefaults.standard.synchronize()
//            print("result \(UserDefaults.standard.array(forKey: "m_screen_config_view"))")
        }

        @objc private func timerAction() {
            countTime += 1
//            print("counter \(countTime)")

            let configScreens = getConfigAllScreen()

            if configScreens.count == 0 {
                self.timer?.invalidate()
                return
            }

            let controllerName = getControllerName()
            let screenView = getScreenView(controllerName: controllerName, screens: configScreens)
//            let screenView = UserDefaults.standard.array(forKey: "m_screen_config_view") as? [ScreenSetting]
//            print(" screenView \(screenView)")
//            let encodedData = UserDefaults.standard.array(forKey: ScreenSettingUserDefaults)
            
//            encodedData.map { try! JSONDecoder().decode(ScreenSetting.self, from: $0) }
            
            
            if screenView.count == 0 {
                self.timer?.invalidate()
                return
            }

            let timeConfig = screenView[0].timeVisit
            if timeConfig.count == 0 {
                self.timer?.invalidate()
                return
            }

            for time in timeConfig {
                if countTime == time {
                    print("counter \(countTime)")
                    HTTPClient.http.postMethod(event: "view_scree_by_time",
                                               profile_info: [
                                                "device_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
                                                "push_id": [
                                                            "push_id": "1c2193fdfac9dbb03f6eca61b944394db65b2347315c4abec52d73f12562915f",
                                                            "app_id": "IOS",
                                                            "is_logged": true,
                                                            "last_access": Date().iso8601(),
                                                            "os_type": 1,
                                                            "lang": "VI"
                                                        ]
                                               ],
                                               properties: [
                                                "time_visit": countTime,
                                                "screen_name": screenView[0].title,
                                               ])
                }

                if countTime == timeConfig[timeConfig.count - 1] {
                    self.timer?.invalidate()
                }
            }
            // Khởi tạo lại giá trị countTime khi quay lại màn hình
            if countTime > timeConfig[timeConfig.count - 1] {
                countTime = 0
            }
        }

    }

    func addBehaviors(_ behaviors: [ViewControllerLifeCycleBehavior]) {
        let behaviorVC = LifeCycleBehaviorViewController(behaviors: behaviors)
        addChild(behaviorVC)
        view.addSubview(behaviorVC.view)
        behaviorVC.didMove(toParent: self)
    }

}

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
