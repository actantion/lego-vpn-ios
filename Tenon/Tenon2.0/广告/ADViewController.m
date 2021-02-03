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
@interface ADViewController ()<GADRewardedAdDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;//定位服务管理类
    CLGeocoder *_geocoder;//初始化地理编码器
}
@property (nonatomic, strong) MSWeakTimer *codeTimer;
@property (nonatomic, assign) NSInteger secondNum;
@property (nonatomic, strong) UIButton *getCodeBtn;
@property(nonatomic, strong) GADRewardedAd *rewardedAd;
@property(nonatomic, strong) GADAdLoader *adLoader;
@property (nonatomic, assign) BOOL bIsShowAd;
@property (nonatomic, assign) BOOL bIsFirstComing;
@end

@implementation ADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeLocationService];
    [self initUI];
    self.bIsShowAd = NO;
    [self createAndLoadRewardedAd];
    NSString* uuid = [self UUID];
    NSLog(@"设备唯一标识 = %@",uuid);
}
-(NSString *)UUID {
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.tenon.tenonvpn" accessGroup:@"group.com.tenon.tenonvpn"];
    NSString *UUID = [wrapper objectForKey:(__bridge id)kSecValueData];
    
    if (UUID.length == 0) {
        UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [wrapper setObject:UUID forKey:(__bridge id)kSecValueData];
    }
    
    return UUID;
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

/*原生视频广告*/
//    GADVideoOptions *videoOptions = [[GADVideoOptions alloc] init];
//    videoOptions.customControlsRequested = YES;
//    self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:@"ca-app-pub-3940256099942544/3986624511"
//                                       rootViewController:self
//                                                  adTypes:@[ kGADAdLoaderAdTypeUnifiedNative ]
//                                                  options:@[ videoOptions ]];
//    self.adLoader.delegate = self;
//    [self.adLoader loadRequest:[GADRequest request]];
//- (void)adLoader:(GADAdLoader *)adLoader
//    didReceiveUnifiedNativeAd:(GADUnifiedNativeAd *)nativeAd {
//  // Set the videoController's delegate to be notified of video events.
//  nativeAd.mediaContent.videoController.delegate = self;
//    NSLog(@"didReceiveUnifiedNativeAd");
//}
//
//- (void)adLoaderDidFinishLoading:(GADAdLoader *) adLoader {
//  // The adLoader has finished loading ads, and a new request can be sent.
//    NSLog(@"adLoaderDidFinishLoading");
//}

-(void)createAndLoadRewardedAd{
//    NSString* adUID = [[NSBundle mainBundle] infoDictionary][@"GADApplicationIdentifier"];
    NSString* adUID = @"ca-app-pub-3940256099942544/1712485313";
    self.rewardedAd = [[GADRewardedAd alloc]
          initWithAdUnitID:adUID];
    GADRequest *request = [GADRequest request];
    [self.rewardedAd loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
        if (error) {
            // Handle ad failed to load case.
        } else {
            // Ad successfully loaded.
        }
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _bIsFirstComing = [userDefaults boolForKey:@"first_coming"];
    printf("FFFFFFFFFFFFFFF %d", _bIsFirstComing);
    if (!_bIsFirstComing) {
        [userDefaults setBool:YES forKey:@"first_coming"];
        [userDefaults synchronize];
    }
    
    _secondNum = 5;
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
    [_getCodeBtn addTarget:self action:@selector(jumpBtnClicked) forControlEvents:UIControlEventTouchUpInside];
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
    
}

-(void)getCodeTime
{
    if(_secondNum>0)
    {
        _secondNum--;
        [_getCodeBtn setTitle:[NSString stringWithFormat:@"%@ %lds",GCLocalizedString(@"Skip Ads"),(long)_secondNum] forState:UIControlStateNormal];
    }
    
    long nowAdViewTm = [[NSDate date] timeIntervalSince1970] * 1000;
    if (self.rewardedAd.isReady && (nowAdViewTm - prevAdViewTm) >= 5 * 60 * 1000 && _bIsFirstComing && !TenonP2pLib.sharedInstance.IsVip) {
        prevAdViewTm = nowAdViewTm;
        self.bIsShowAd = YES;
        [self.rewardedAd presentFromRootViewController:self delegate:self];
        prevAdViewTm = [[NSDate date] timeIntervalSince1970]*1000;
        [self jumpBtnClicked];
    }
    
    if (_secondNum <= 0) {
        self.bIsShowAd = YES;
        [self jumpBtnClicked];
    }
}

-(void)jumpBtnClicked
{
    if (self.bIsShowAd == NO) {
        long nowAdViewTm = [[NSDate date] timeIntervalSince1970] * 1000;
        if (self.rewardedAd.isReady && (nowAdViewTm - prevAdViewTm) >= 5 * 60 * 1000 && _bIsFirstComing && !TenonP2pLib.sharedInstance.IsVip) {
            prevAdViewTm = nowAdViewTm;
            self.bIsShowAd = YES;
            [self.rewardedAd presentFromRootViewController:self delegate:self];
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
    }else{
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
