//
//  ADViewController.m
//  Tenonvpn
//
//  Created by Raobin on 2020/10/9.
//  Copyright © 2020 Raobin. All rights reserved.
//

#import "ADViewController.h"
#import "MSWeakTimer.h"
#import "MainViewController.h"
#import "TenonVPN-Swift.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "libp2p/libp2p.h"
#import <CommonCrypto/CommonDigest.h>
 
#import <CoreLocation/CoreLocation.h>

#import "KeychainItemWrapper.h"

extern long prevAdViewTm;
extern ViewController *swiftViewController;
/*原生视频广告*/
//GADUnifiedNativeAdLoaderDelegate, GADVideoControllerDelegate
@interface ADViewController ()<GADRewardedAdDelegate, CLLocationManagerDelegate, GADFullScreenContentDelegate>
{
    CLLocationManager *_locationManager;//定位服务管理类
    CLGeocoder *_geocoder;//初始化地理编码器
}
@property (weak, nonatomic) IBOutlet UILabel *lbFast;
@property (weak, nonatomic) IBOutlet UILabel *lbSimple;
@property (weak, nonatomic) IBOutlet UILabel *lbSafe;
@property (weak, nonatomic) IBOutlet UILabel *lbTrust;
@property (weak, nonatomic) IBOutlet UILabel *lbNoCenterVpn;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (nonatomic, strong) MSWeakTimer *codeTimer;
@property (nonatomic, assign) NSInteger secondNum;
@property (nonatomic, strong) UIButton *getCodeBtn;
@property(nonatomic, strong) GADAdLoader *adLoader;
@property (nonatomic, assign) BOOL bIsShowAd;
@property (nonatomic, assign) BOOL bIsFirstComing;
@property (nonatomic, assign) BOOL bJumpted;
@property(nonatomic, strong) GADRewardedInterstitialAd* rewardedInterstitialAd;
@end

@implementation ADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeLocationService];
    [self initUI];
    self.bIsShowAd = NO;
    self.rewardedInterstitialAd = nil;
    [self createAndLoadRewardedAd];
    self.bJumpted = false;
}

- (void)initializeLocationService {
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    //[_locationManager requestAlwaysAuthorization];//iOS8必须，这两行必须有一行执行，否则无法获取位置信息，和定位
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [_locationManager startUpdatingLocation];//开始定位之后会不断的执行代理方法更新位置会比较费电所以建议获取完位置即时关闭更新位置服务
    //初始化地理编码器
    _geocoder = [[CLGeocoder alloc] init];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{

    NSLog(@"%lu",(unsigned long)locations.count);
    CLLocation * location = locations.lastObject;
    // 纬度
    CLLocationDegrees latitude = location.coordinate.latitude;
    // 经度
    CLLocationDegrees longitude = location.coordinate.longitude;
    NSLog(@"%@",[NSString stringWithFormat:@"%lf", location.coordinate.longitude]);
//    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f", location.coordinate.longitude, location.coordinate.latitude,location.altitude,location.course,location.speed);
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"%@",placemark.name);
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"name,%@",placemark.name);
            NSLog(@"thoroughfare,%@",placemark.thoroughfare);
            NSLog(@"subThoroughfare,%@",placemark.subThoroughfare);
            NSLog(@"locality,%@",placemark.locality);
            NSLog(@"subLocality,%@",placemark.subLocality);
            NSLog(@"country,%@",placemark.country);
            NSLog(@"placemark.ISOcountryCode = %@",placemark.ISOcountryCode);
            VpnManager.shared.local_country = placemark.ISOcountryCode;
        }
        else if (error == nil && [placemarks count] == 0) {
            NSLog(@"No results were returned.");
        } else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
    [manager stopUpdatingLocation];
}

/// Tells the delegate that the ad failed to present full screen content.
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad
didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    NSLog(@"Ad did fail to present full screen content.");
}

/// Tells the delegate that the ad presented full screen content.
- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {

    NSLog(@"Ad did present full screen content.");
}

/// Tells the delegate that the ad dismissed full screen content.
- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
   NSLog(@"Ad did dismiss full screen content.");
}

-(void)createAndLoadRewardedAd{
    [GADRewardedInterstitialAd
           loadWithAdUnitID:@"ca-app-pub-1878869478486684/4656457319"
                    request:[GADRequest request]                                                                                                                                                        
          completionHandler:^(
              GADRewardedInterstitialAd *_Nullable rewardedInterstitialAd,
              NSError *_Nullable error) {
            if (!error) {
                NSLog(@"Ad did success to load full screen content.");
              self.rewardedInterstitialAd = rewardedInterstitialAd;
              self.rewardedInterstitialAd.fullScreenContentDelegate = self;
            } else {
                NSLog(@"Ad did failed to load full screen content. error(%@)", error);
                [NSThread sleepForTimeInterval:0.5f];
                [self createAndLoadRewardedAd];
            }
          }];
}

- (void)show {
  [_rewardedInterstitialAd presentFromRootViewController:self
                                userDidEarnRewardHandler:^{

                                  GADAdReward *reward =
                                      self.rewardedInterstitialAd.adReward;
                                  // TODO: Reward the user!
                                }];
}

-(void)dealloc
{
   if (self.codeTimer != nil) {
      [self.codeTimer invalidate];
      self.codeTimer = nil;
    }
}


-(void)initUI
{
    self.lbTitle.text = GCLocalizedString(@"The light of Blockchain Apps");
    self.lbNoCenterVpn.text = GCLocalizedString(@"Decentralization VPN");
    self.lbFast.text = GCLocalizedString(@"Fast");
    self.lbSafe.text = GCLocalizedString(@"Safe");
    self.lbTrust.text = GCLocalizedString(@"Reliable");
    self.lbSimple.text = GCLocalizedString(@"Easy");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _bIsFirstComing = [userDefaults boolForKey:@"first_coming"];
    if (!_bIsFirstComing) {
        [userDefaults setBool:YES forKey:@"first_coming"];
        [userDefaults synchronize];
    }
    

    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kRGBA(0, 0, 0, 0.6);
    bgView.layer.cornerRadius = 18.0f;
    bgView.layer.masksToBounds = YES;
    [self.myADView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(112);
        make.height.mas_equalTo(36);
        make.bottom.equalTo(_myADView.mas_bottom).offset(-20);
        make.right.equalTo(_myADView.mas_right).offset(-17);
    }];
    
    _getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 112, 36)];
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"%@ %lds",GCLocalizedString(@"Skip Ads"),(long)_secondNum] forState:0];
    [_getCodeBtn setTitleColor:kRBColor(154,162,161) forState:0];
    _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_getCodeBtn addTarget:self action:@selector(clickJumpBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_getCodeBtn];
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    self.codeTimer = [MSWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getCodeTime) userInfo:nil repeats:YES dispatchQueue:(mainQueue)];
    
    if([self.FROM isEqualToString:@"AD"]) {
        _getCodeBtn.enabled = NO;
    }
    
    swiftViewController = [ViewController new];
    if ([swiftViewController InitP2p] != 0) {
        [self.view makeToast:GCLocalizedString(@"Failed to initialize P2P network, please try again!") duration:2 position:BOTTOM];
        exit(0);
    }
    
    if (TenonP2pLib.sharedInstance.IsVip) {
        _secondNum = 2;
    } else {
        _secondNum = 6;
    }
    
}

-(void)getCodeTime
{
    if(_secondNum>0)
    {
        _secondNum--;
        [_getCodeBtn setTitle:[NSString stringWithFormat:@"%@ %lds",GCLocalizedString(@"Skip Ads"),(long)_secondNum] forState:UIControlStateNormal];
    }
    
    long nowAdViewTm = [[NSDate date] timeIntervalSince1970] * 1000;
    if (self.rewardedInterstitialAd != nil && !TenonP2pLib.sharedInstance.IsVip) {
        prevAdViewTm = nowAdViewTm;
        self.bIsShowAd = YES;
        [self show];
        prevAdViewTm = [[NSDate date] timeIntervalSince1970]*1000;
        [self jumpBtnClicked];
    }
    
    if (_secondNum <= 0) {
        self.bIsShowAd = YES;
        [self jumpBtnClicked];
    }
}

-(void)clickJumpBtnClicked
{
    if (self.bIsShowAd == NO) {
        long nowAdViewTm = [[NSDate date] timeIntervalSince1970] * 1000;
        if (self.rewardedInterstitialAd != nil && !TenonP2pLib.sharedInstance.IsVip) {
            prevAdViewTm = nowAdViewTm;
            self.bIsShowAd = YES;
            [self show];
            if (self.codeTimer != nil) {
                [self.codeTimer invalidate];
                self.codeTimer = nil;
            }
            if([self.FROM isEqualToString:@"MAIN"]){
                MainViewController *nextVC = [[MainViewController alloc] init];
                [self.navigationController pushViewController:nextVC animated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    
    if (TenonP2pLib.sharedInstance.IsVip || _secondNum <= 0) {
        if (self.codeTimer != nil) {
            [self.codeTimer invalidate];
            self.codeTimer = nil;
        }
        if([self.FROM isEqualToString:@"MAIN"]){
            MainViewController *nextVC = [[MainViewController alloc] init];
            [self.navigationController pushViewController:nextVC animated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)jumpBtnClicked
{
    if (self.bIsShowAd == NO) {
        long nowAdViewTm = [[NSDate date] timeIntervalSince1970] * 1000;
        if (self.rewardedInterstitialAd != nil && !TenonP2pLib.sharedInstance.IsVip) {
            prevAdViewTm = nowAdViewTm;
            self.bIsShowAd = YES;
            [self show];
            if (self.codeTimer != nil) {
                [self.codeTimer invalidate];
                self.codeTimer = nil;
            }
            if([self.FROM isEqualToString:@"MAIN"]){
                if (![self bJumpted]) {
                    self.bJumpted = true;
                    MainViewController *nextVC = [[MainViewController alloc] init];
                    [self.navigationController pushViewController:nextVC animated:YES];
                }
            }else{
                if (![self bJumpted]) {
                    self.bJumpted = true;
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }
    }
    
    if (TenonP2pLib.sharedInstance.IsVip || _secondNum <= 0) {
        if (self.codeTimer != nil) {
            [self.codeTimer invalidate];
            self.codeTimer = nil;
        }
        if([self.FROM isEqualToString:@"MAIN"]){
            if (![self bJumpted]) {
                self.bJumpted = true;
                MainViewController *nextVC = [[MainViewController alloc] init];
                [self.navigationController pushViewController:nextVC animated:YES];
            }
        }else{
            if (![self bJumpted]) {
                self.bJumpted = true;
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}
- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd {
    [self createAndLoadRewardedAd];
}
-(NSString*)sha256HashForText:(NSString*)text {
    const char* utf8chars = [text UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(utf8chars, (CC_LONG)strlen(utf8chars), result);

    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (NSString *)random: (int)len {
    char ch[len];
    for (int index=0; index<len; index++) {
        
        int num = arc4random_uniform(75)+48;
        if (num>57 && num<65) { num = num%57+48; }
        else if (num>90 && num<97) { num = num%90+65; }
        ch[index] = num;
    }
    
    return [[NSString alloc] initWithBytes:ch length:len encoding:NSUTF8StringEncoding];
}

- (void)rewardedAd:(nonnull GADRewardedAd *)rewardedAd
    userDidEarnReward:(nonnull GADAdReward *)reward
{
    NSString* rand_str = [self random:2048];
    NSString* gid = [self sha256HashForText:(rand_str)];
    [LibP2P AdReward:gid];
    
    NSLog(@"广告播放成功获得奖励, %@", gid);
}

@end
