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
import AVFoundation

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate , CLLocationManagerDelegate ,WXApiDelegate {

    var bgTask:UIBackgroundTaskIdentifier!
    var window: UIWindow?
    var badgeTimer:DispatchSourceTimer!
    var backTask:UIBackgroundTaskIdentifier!
    var appleLocationManager:CLLocationManager!
    var player:AVAudioPlayer!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // MARK:角标设置用于后台持续状态测试
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.carPlay,.sound], completionHandler: { (success, error) in
            print("授权" + (success ? "成功" : "失败"))
        })
        IQKeyboardManager.shared.enable = true
        // MARK:微信支付初始化
//        WXApi.registerApp(WX_ID, universalLink: "TenonVPN")
        // MARK:位置更新初始化-用于后台保持
//        appleLocationManager = CLLocationManager()
//        appleLocationManager.allowsBackgroundLocationUpdates = true
//        appleLocationManager.desiredAccuracy = kCLLocationAccuracyBest
//        appleLocationManager.delegate = self
//        appleLocationManager.requestAlwaysAuthorization()
//        appleLocationManager.startUpdatingLocation()
//        startBgTask()
        
        // MARK:后台声音播放-用户后台保持
        startBgTask()
        do{
            self.player = try AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "click.mp3", withExtension: nil)!)
            self.player.prepareToPlay()
            self.player.numberOfLoops = 1
            let session:AVAudioSession = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playback)
            try session.setActive(true, options: AVAudioSession.SetActiveOptions.init())
            self.player.volume = 0
//            self.player.play()
        }catch let error as NSError {
            print(error.description)
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        // MARK:位置更新启动条件-用于后台保持
//        stratBadgeNumberCount()
//        startBgTask()
        // MARK:后台播放声音条件-用于后台保持
        UNUserNotificationCenter.current().getNotificationSettings { set in
            if set.authorizationStatus == UNAuthorizationStatus.authorized{
                DispatchQueue.main.sync {
                    self.stratBadgeNumberCount()
                    self.startBgTask()
                }
            }
            else{
                if VpnManager.shared.vpnStatus == .on{
                    VpnManager.shared.disconnect()
                }
            }
        }
    }

    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        appleLocationManager.stopUpdatingLocation()
//        appleLocationManager = nil
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        appleLocationManager.stopUpdatingLocation()
//        appleLocationManager = nil
//    }
    func stratBadgeNumberCount() {
        self.badgeTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        self.badgeTimer?.schedule(wallDeadline: DispatchWallTime.now(), repeating: DispatchTimeInterval.seconds(10), leeway: DispatchTimeInterval.seconds(0))
        self.badgeTimer?.setEventHandler(handler: { [weak self] in
            DispatchQueue.main.async {
                self?.player.play()
//                UIApplication.shared.applicationIconBadgeNumber += 10
//                self?.appleLocationManager = CLLocationManager()
//                self?.appleLocationManager.allowsBackgroundLocationUpdates = true
//                self?.appleLocationManager.desiredAccuracy = kCLLocationAccuracyBest
//                self?.appleLocationManager.delegate = self
//                self?.appleLocationManager.requestAlwaysAuthorization()
//                self?.appleLocationManager.startUpdatingLocation()
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // MARK:支付宝&微信回调
        if url.host == "safepay"{
            
        }else if url.host == "pay"{
            WXApi.handleOpen(url, delegate: self)
        }
//        if ([url.host isEqualToString:@"safepay"]) {
//            //跳转支付宝钱包进行支付，处理支付结果
//            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSLog(@"result = %@",resultDic);
//                }];
//        }else if ([url.host isEqualToString:@"pay"]) {
//            // 处理微信的支付结果
//            [WXApi handleOpenURL:url delegate:self];
//        }
        return true
    }
    func onResp(_ resp: BaseResp) {
//        NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
//        if([resp isKindOfClass:[PayResp class]]){
//            //支付返回结果，实际支付结果需要去微信服务器端查询
//            switch (resp.errCode) {
//            case 0:
//                payResoult = @"支付结果：成功！";
//                break;
//            case -1:
//                payResoult = @"支付结果：失败！";
//                break;
//            case -2:
//                payResoult = @"用户已经退出支付！";
//                break;
//            default:
//                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
//                break;
//            }
//        }
        if resp.isKind(of: PayResp.self){
            var result:String = "errorCode:"+String(resp.errCode)
            switch resp.errCode{
            case 0:
                result = "wechat payment success"
            case -1:
                result = "wechat payment failed"
            case -2:
                result = "user exit payment"
            default:
                result = "wechat payment failed"
            }
            print(result)
        }
    }
}

