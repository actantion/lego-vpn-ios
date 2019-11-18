//
//  AppDelegate.swift
//  TenonVPN
//
//  Created by zly on 2019/4/17.
//  Copyright © 2019 zly. All rights reserved.
//
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var bgTask:UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    var badgeTimer:DispatchSourceTimer!
    var backTask:UIBackgroundTaskIdentifier!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UNUserNotificationCenter.current().getNotificationSettings { set in
            DispatchQueue.main.sync {
                self.stratBadgeNumberCount()
                self.startBgTask()
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func stratBadgeNumberCount() {
        self.badgeTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        self.badgeTimer?.schedule(wallDeadline: DispatchWallTime.now(), repeating: DispatchTimeInterval.seconds(3), leeway: DispatchTimeInterval.seconds(0))
        self.badgeTimer?.setEventHandler(handler: { [weak self] in
            DispatchQueue.main.async {
                // exec code
                NotificationCenter.default.post(name: UIApplication.didEnterBackgroundNotification, object: self, userInfo:nil)
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
}
