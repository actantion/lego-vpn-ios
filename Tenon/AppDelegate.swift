//
//  AppDelegate.swift
//  TenonVPN
//
//  Created by zly on 2019/4/17.
//  Copyright © 2019 zly. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , CLLocationManagerDelegate {

    var bgTask:UIBackgroundTaskIdentifier!
    var window: UIWindow?
    var badgeTimer:DispatchSourceTimer!
    var backTask:UIBackgroundTaskIdentifier!
    var appleLocationManager:CLLocationManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //        UIApplication.shared.applicationIconBadgeNumber = 0
        //        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.carPlay,.sound], completionHandler: { (success, error) in
        //            print("授权" + (success ? "成功" : "失败"))
        //        })
        IQKeyboardManager.shared.enable = true
        //        [WXApi registerApp:@"wxd930ea5d5a258f4f" withDescription:@"demo 2.0"];
//        WXApi.registerApp("wxd930ea5d5a258f4f")
        startBgTask()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        stratBadgeNumberCount()
        startBgTask()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        appleLocationManager.stopUpdatingLocation()
        appleLocationManager = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        appleLocationManager.stopUpdatingLocation()
        appleLocationManager = nil
    }
    func stratBadgeNumberCount() {
        self.badgeTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        self.badgeTimer?.schedule(wallDeadline: DispatchWallTime.now(), repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.seconds(0))
        self.badgeTimer?.setEventHandler(handler: { [weak self] in
            DispatchQueue.main.async {
                self?.appleLocationManager = CLLocationManager()
                self?.appleLocationManager.allowsBackgroundLocationUpdates = true
                self?.appleLocationManager.desiredAccuracy = kCLLocationAccuracyBest
                self?.appleLocationManager.delegate = self
                self?.appleLocationManager.requestAlwaysAuthorization()
                self?.appleLocationManager.startUpdatingLocation()
            }
        })
        self.badgeTimer?.resume()
    }
    
    func startBgTask() {
        self.bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.bgTask)
            print("application.backgroundTimeRemaining = %d",UIApplication.shared.backgroundTimeRemaining)
        })
    }
//
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if VpnManager.shared.vpnStatus == .on{
            VpnManager.shared.disconnect()
        }
    }
}

