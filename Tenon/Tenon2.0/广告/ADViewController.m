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
    if (self.rewardedAd.isReady) {
        self.bIsShowAd = YES;
        [self.rewardedAd presentFromRootViewController:self delegate:self];
        [self jumpBtnClicked];
    } else {
        NSLog(@"Ad wasn't ready");
    }
    if (_secondNum <= 0) {
        self.bIsShowAd = YES;
        [self jumpBtnClicked];
    }
}

-(void)jumpBtnClicked
{
    if (self.bIsShowAd == NO) {
        if (self.rewardedAd.isReady) {
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
        }else{
            
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
- (void)rewardedAd:(nonnull GADRewardedAd *)rewardedAd
    userDidEarnReward:(nonnull GADAdReward *)reward
{
    NSLog(@"广告播放成功获得奖励");
}
@end
