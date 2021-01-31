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
 
extern long prevAdViewTm;
extern ViewController *swiftViewController;
/*原生视频广告*/
//GADUnifiedNativeAdLoaderDelegate, GADVideoControllerDelegate
@interface ADViewController ()<GADRewardedAdDelegate>
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
    [self initUI];
    self.bIsShowAd = NO;
    [self createAndLoadRewardedAd];
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
    if (self.rewardedAd.isReady && (nowAdViewTm - prevAdViewTm) >= 5 * 60 * 1000 && _bIsFirstComing) {
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
        if (self.rewardedAd.isReady && (nowAdViewTm - prevAdViewTm) >= 5 * 60 * 1000 && _bIsFirstComing) {
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
