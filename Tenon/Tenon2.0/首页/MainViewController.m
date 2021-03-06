//
//  MainViewController.m
//  Tenonvpn
//
//  Created by Raobin on 2020/8/30.
//  Copyright © 2020 Raobin. All rights reserved.
//

#import "MainViewController.h"
#import "AboutViewController.h"
#import "SettingViewController.h"
#import "RechargeViewController.h"
#import "WithdrawViewController.h"
#import "RBProgressView.h"
#import "MSWeakTimer.h"
#import "TenonVPN-Swift.h"
#import <Social/Social.h>
#import "TSShareHelper.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "libp2p/libp2p.h"
#import <CommonCrypto/CommonDigest.h>
#import "HomeGuideView.h"

long prevAdViewTm = 0;
ViewController *swiftViewController;
extern NSString* GlobalMonitorString;

@interface MainViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,GADBannerViewDelegate,GADRewardedAdDelegate,GADFullScreenContentDelegate>
{
    UIPickerView *pickViewss;
    NSArray *arrayOne;
    NSArray *arrayImg;
    NSArray *arrayShortCountry;
}
@property (nonatomic, assign) BOOL isFree;
@property (nonatomic, strong) UIView *freeView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UIButton *eyeBtn;
@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) NSString *codeString;

@property (nonatomic, strong) UILabel *typeSignLabel;
@property (nonatomic, strong) UILabel *typeTextLabel;

@property (nonatomic, assign) BOOL isLink;
@property (nonatomic, strong) UIView *linkBgView;
@property (nonatomic, strong) UILabel *linkLabel;
@property (nonatomic, strong) UIView *linkImg;
@property (nonatomic, strong) UILabel *linkNoticeLabel;

@property (nonatomic, strong) UIButton *aboutBtn;
@property (nonatomic, strong) UIButton *vipTgBtn;

@property (nonatomic, strong) UIView *inputAlertBgView;
@property (nonatomic, strong) UITextField *inputTextField;

@property (nonatomic, strong) UIView *ADView;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIView *loadingAdView;
@property (nonatomic, strong) RBProgressView *progressView;
@property (nonatomic, strong) MSWeakTimer *codeTimer;
@property (nonatomic, strong) UIButton *linkBtn;
@property(nonatomic, strong) NSMutableArray *shareArray;
@property(nonatomic, strong) NSMutableArray *functionArray;
@property (nonatomic, strong) NSString *choosedCountry;
//@property(nonatomic, strong) GADInterstitial *interstitial;
@property(nonatomic, strong) GADRewardedAd *rewardedAd;
@property(nonatomic, strong) GADRewardedAd *rewardedAd_5;
@property(nonatomic, strong) GADRewardedAd *rewardedAd_3;
@property(nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) NSTimer * rechargeTimer;
@property(nonatomic, strong) GADRewardedInterstitialAd* rewardedInterstitialAd;

@property (strong, nonatomic) UIAlertAction *okBtn;
@property (strong, nonatomic) UIAlertAction *cancelBtn;
@property (nonatomic, assign) BOOL outoftimeShowed;
@property (nonatomic, assign) UInt64 prevShowInsAdTimestamp;
@property (nonatomic, assign) NSInteger loadingTime;
@end

@implementation MainViewController

- (GADRewardedAd *)createAndLoadRewardedAd : (NSString* ) adUID {
    //NSString* adUID = @"ca-app-pub-1878869478486684/9128411174";
//    NSString* adUID = @"ca-app-pub-3940256099942544/1712485313";
    GADRewardedAd *rewardedAd = [[GADRewardedAd alloc]
                                 initWithAdUnitID:adUID];
    GADRequest *request = [GADRequest request];
    [rewardedAd loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
        if (error) {
            // Handle ad failed to load case.
            NSLog(@"Handle ad failed to load case.");
        } else {
            // Ad successfully loaded.
            NSLog(@"Ad successfully loaded.");
        }
    }];
    return rewardedAd;
}

- (void)rewardedAdDidDismiss:(GADRewardedAd *)rewardedAd {
    if (self.rewardedAd == rewardedAd) {
        self.rewardedAd = [self createAndLoadRewardedAd: @"ca-app-pub-1878869478486684/9128411174"];
    }
    
    if (self.rewardedAd_5 == rewardedAd) {
        self.rewardedAd_5 = [self createAndLoadRewardedAd: @"ca-app-pub-1878869478486684/5067800095"];
    }
    
    if (self.rewardedAd_3 == rewardedAd) {
        self.rewardedAd_3 = [self createAndLoadRewardedAd: @"ca-app-pub-1878869478486684/6456903388"];
    }
}

-(void)createAndLoadInsRewardedAd{
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
                [self createAndLoadInsRewardedAd];
            }
          }];
}

- (void)showInsAd {
    [_rewardedInterstitialAd presentFromRootViewController: self userDidEarnRewardHandler:^{
        GADAdReward *reward = self.rewardedInterstitialAd.adReward;
        NSString* rand_str = [self random:2048];
        NSString* gid = [self sha256HashForText:(rand_str)];
        [LibP2P AdReward:gid];
        if (reward.amount >= 5) {
            [TenonP2pLib.sharedInstance ChangeFreeUseTimeMilliWithVal:30 * 60 * 1000];
            NSLog(@"广告播放成功获得奖励 5: %@", reward.amount);
        } else if (reward.amount >= 3) {
            [TenonP2pLib.sharedInstance ChangeFreeUseTimeMilliWithVal:25 * 60 * 1000];
            NSLog(@"广告播放成功获得奖励 3");
        } else {
            [TenonP2pLib.sharedInstance ChangeFreeUseTimeMilliWithVal:20 * 60 * 1000];
            NSLog(@"广告播放成功获得奖励 1");
        }
    }];
    
    _prevShowInsAdTimestamp = [[NSDate date] timeIntervalSince1970]*1000;
    self.rewardedInterstitialAd = nil;
    [self createAndLoadInsRewardedAd];
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
    if (reward.amount.intValue >= 5) {
        [TenonP2pLib.sharedInstance ChangeFreeUseTimeMilliWithVal:30 * 60 * 1000];
    } else if (reward.amount.intValue >= 3) {
        [TenonP2pLib.sharedInstance ChangeFreeUseTimeMilliWithVal:25 * 60 * 1000];
    } else {
        [TenonP2pLib.sharedInstance ChangeFreeUseTimeMilliWithVal:20 * 60 * 1000];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.rewardedAd = [self createAndLoadRewardedAd: @"ca-app-pub-1878869478486684/9128411174"];
    self.rewardedAd_3 = [self createAndLoadRewardedAd: @"ca-app-pub-1878869478486684/5067800095"];
    self.rewardedAd_3 = [self createAndLoadRewardedAd: @"ca-app-pub-1878869478486684/6456903388"];
    
    self.rewardedInterstitialAd = nil;
    [self createAndLoadInsRewardedAd];
    self.view.backgroundColor = [UIColor blackColor];
    [self initNavView];
    [self initUI];
    [self reloadBalance];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadVPNStatus) name:@"kProxyServiceVPNStatusNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBalance) name:@"NOTIFICATION_BALANCE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLanguage) name:@"reloadLanguage" object:nil];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showAdsTimer) userInfo:nil repeats:YES];
    [self requestRechargeInterface];
    _outoftimeShowed = false;
}

- (void)showAdsTimer{
    [self reloadBalance];
}

- (void) showToast2 {
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:GCLocalizedString(@"Timeout") message:GCLocalizedString(@"Free time expires, watch ads or subscribe to VIP.") preferredStyle:UIAlertControllerStyleAlert];
    // 确定按钮监听
    _okBtn = [UIAlertAction actionWithTitle:GCLocalizedString(@"Watch Ads") style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        NSLog(@"点击了确定按钮");
        [self clickIncreaseFreeTime];
    }];
    _cancelBtn =[UIAlertAction actionWithTitle:GCLocalizedString(@"Become VIP") style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        NSLog(@"点击了取消按钮");
        [self chongBtnClicked];
    }];
    //添加按钮到弹出上
    [alert addAction:_okBtn];
    [alert addAction:_cancelBtn];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}

-(void)reloadBalance{
    NSUserDefaults * userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.tenon.tenonvpn"];
    [userDefaults synchronize];
    UInt64 mLeftFreeUseTimeMilli = [userDefaults integerForKey:@"mLeftFreeUseTimeMilli"];
      if (TenonP2pLib.sharedInstance.IsVip) {
        _typeSignLabel.text = [NSString stringWithFormat:@"%d%@",TenonP2pLib.sharedInstance.getLeftDays, GCLocalizedString(@"left_days")];
          if (mLeftFreeUseTimeMilli < 2000) {
              mLeftFreeUseTimeMilli = 3600 * 1000;
              [userDefaults setInteger:mLeftFreeUseTimeMilli forKey:@"mLeftFreeUseTimeMilli"];
          }
    } else {
        UInt64 hourLeft = mLeftFreeUseTimeMilli / (3600 * 1000);
        UInt64 minLeft = mLeftFreeUseTimeMilli / 60000 - hourLeft * 60;
        UInt64 secLeft = mLeftFreeUseTimeMilli / 1000 - hourLeft * 3600 - minLeft * 60;
        _typeSignLabel.text = [NSString stringWithFormat:@"%@%02llu:%02llu:%02llu", GCLocalizedString(@"Left"), hourLeft, minLeft, secLeft];
        
        if (!_isLink) {
            if (mLeftFreeUseTimeMilli >= 1000) {
                mLeftFreeUseTimeMilli -= 1000;
                [userDefaults setInteger:mLeftFreeUseTimeMilli forKey:@"mLeftFreeUseTimeMilli"];
            }
        }
        
        if (mLeftFreeUseTimeMilli <= 1000) {
            [self disconnectVpn];
            self.isLink = NO;
            [self refreshLinkView];
            if (!_outoftimeShowed) {
                [self showToast2];
                _outoftimeShowed = true;
            }
        }
    }
    
    _typeTextLabel.text = [NSString stringWithFormat:@"%lld TEN",TenonP2pLib.sharedInstance.GetBalance];
}

- (void)reloadVPNStatus{
    if (swiftViewController.user_started_vpn && TenonP2pLib.sharedInstance.IsVip) {
        if (self.codeTimer != nil) {
          [self.codeTimer invalidate];
          self.codeTimer = nil;
        }
        
        self.loadingView.hidden = YES;
        [self.loadingView removeFromSuperview];
        self.isLink = true;
        _loadingTime = 0;
    }else{
        _isLink = false;
    }
    [self refreshLinkView];
}

-(void)reloadLanguage
{
    for(UIView *view in [self.view subviews])
    {
        [view removeFromSuperview];
    }
    [self viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshFreeView];
}

#pragma mark -加载顶部视图
-(void)initNavView
{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, 273)];
    [self.view addSubview:navView];
    
    UIImageView *navImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, 273)];
    navImg.image = [UIImage imageNamed:@"black_bg5"];
    [navView addSubview:navImg];
    
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, top_H, 50, 50)];
    logoImg.image = [UIImage imageNamed:@"logo"];
    [navImg addSubview:logoImg];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(78, top_H, 150, 28)];
    label1.text = @"TenonVPN";
    label1.font = Font_H(28);
    label1.textColor = kRBColor(18, 181, 170);
    [navView addSubview:label1];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(82, top_H+36, 150, 14)];
    label2.text = [NSString stringWithFormat:@"V%@",app_Version];
    label2.font = [UIFont systemFontOfSize:16];
    label2.textColor = kRBColor(154, 162, 161);
    [navView addSubview:label2];
    
    UIView *shareV = [[UIView alloc] initWithFrame:CGRectMake(kWIDTH-116, top_H, 100, 36)];
    shareV.backgroundColor = kRBColor(21, 25, 25);
    shareV.layer.cornerRadius = 18.0f;
    [navView addSubview:shareV];
    
    UIImageView *shareImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 20, 20)];
    shareImg.image = [UIImage imageNamed:@"share_icon"];
    [shareV addSubview:shareImg];
    
    UILabel *shareLab = [[UILabel alloc] initWithFrame:CGRectMake(36, 0, 60, 36)];
//    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"AppLanguagesKey"] isEqualToString:@"en"]) {
        shareLab.text = GCLocalizedString(@"Share");
//    }
    
    shareLab.font = Font_B(16);
    shareLab.textColor = kRBColor(21, 203, 191);
    [shareV addSubview:shareLab];
    
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 36)];
    [shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [shareV addSubview:shareBtn];
    
    UIButton *settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, top_H, 40, 40)];
    [settingBtn addTarget:self action:@selector(editBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:settingBtn];
}

-(void)shareBtnClicked
{
    NSString* string1 = @"https://www.tenonvpn.net";
    NSString* string = [string1 stringByAppendingString:TenonP2pLib.sharedInstance.account_id];
    NSURL* url2 = [NSURL URLWithString:string];
    
    [TSShareHelper shareWithType:0
                   andController:self
                        andItems:@[url2]
                   andCompletion:^(TSShareHelper *shareHelper, BOOL success) {
        
                       if (success) {
                           NSLog(@"成功的回调");
                       }else{
                           NSLog(@"失败的回调");
                       }
                   }];
}

#pragma mark -加载视图
-(void)initUI
{
    _isFree = NO; //YES;
    _isShow = YES; //NO;
    _codeString = @"s823rjdf9s8hc23289rhvnweua8932s823rjdf9s8hc23289rhvnweua8932rkop";
    _freeView = [[UIView alloc] initWithFrame:CGRectMake(12, top_H+60, kWIDTH-24, 36)];
    _freeView.layer.cornerRadius = 4.0f;
    _freeView.backgroundColor = kRBColor(21, 25, 25);
    [self.view addSubview:_freeView];
    
    [self addLeftView];
    [self addRightView];
    [self addTwoLeftView];
    [self addTwoRightView];
    [self refreshLinkView];
    [self initInputAlertView];
    
    pickViewss = [[UIPickerView alloc] init] ;
    pickViewss.frame = CGRectMake(0,423+top_H, kWIDTH, 180);
    pickViewss.backgroundColor = [UIColor clearColor];
    pickViewss.dataSource = self;
    pickViewss.delegate = self;
    [self.view addSubview:pickViewss];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *subviews = self->pickViewss.subviews;
        if (!(subviews.count > 0)) {
            return;
        }
        NSArray *coloms = subviews.firstObject;
        if (coloms)
        {
            NSArray *subviewCache = [coloms valueForKey:@"subviewCache"];
            if (subviewCache.count > 0) {
                UIView *middleContainerView = [subviewCache.firstObject valueForKey:@"middleContainerView"];
                if (middleContainerView) {
                    middleContainerView.backgroundColor = kRBColor(1, 1, 1);
                    
                    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(10, 5, kWIDTH-40, 44)];
                    myView.backgroundColor = [UIColor clearColor];
                    myView.layer.borderColor = kRBColor(18, 181, 170).CGColor;
                    myView.layer.borderWidth = 1.0f;
                    myView.layer.cornerRadius = 22.0f;
                    [middleContainerView addSubview:myView];
                    
                    UIView *dianV = [[UIView alloc] initWithFrame:CGRectMake(kWIDTH-60, 20, 8, 8)];
                    dianV.layer.cornerRadius = 4.0f;
                    dianV.backgroundColor = kRBColor(18, 181, 170);
                    [myView addSubview:dianV];
                }
            }
        }
        NSUserDefaults* defaluts = [NSUserDefaults standardUserDefaults];
        NSString* tag = [defaluts objectForKey:@"FIRST_ENTER_APP"];
        NSString* click = [defaluts objectForKey:@"CLICK_SETTING"];
        if (tag == nil) {
            CGRect rect = CGRectMake(20, top_H, 50, 50);
            HomeGuideView* view = [[HomeGuideView alloc] nib];
            [view show:self withRect:rect];
            
            TenonProtocolView* vc = [NSBundle.mainBundle loadNibNamed:@"TenonProtocolView" owner:self options:nil][0];
            [self.view addSubview:vc];
            [vc mas_makeConstraints:^(MASConstraintMaker *make) {
                [make.edges setInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            }];
        }else if (click == nil){
            CGRect rect = CGRectMake(20, top_H, 50, 50);
            HomeGuideView* view = [[HomeGuideView alloc] nib];
            [view show:self withRect:rect];
        }
        
    });
    
    arrayOne = @[
                 GCLocalizedString(@"Automatic"),
                 GCLocalizedString(@"United States"),
                 GCLocalizedString(@"China"),
                 GCLocalizedString(@"Singapore"),
                 GCLocalizedString(@"Japan"),
                 GCLocalizedString(@"South Korea"),
                 GCLocalizedString(@"Canada"),
                 GCLocalizedString(@"France"),
                 GCLocalizedString(@"England"),
                 GCLocalizedString(@"Germany"),
                 GCLocalizedString(@"Australia"),
                 GCLocalizedString(@"Brazil"),
                 GCLocalizedString(@"Netherlands"),
                 GCLocalizedString(@"Hong Kong"),
                 GCLocalizedString(@"India"),
                 GCLocalizedString(@"Russia")];
    arrayImg = @[@"aa",@"us",@"cn",@"sg",@"jp",@"kr",@"ca",@"fr",@"gb",@"de",@"au",@"br",@"nl",@"hk",@"in",@"ru"];
    arrayShortCountry = @[@"AA",@"US",@"CN",@"SG",@"JP",@"KR",@"CA",@"FR",@"GB",@"DE",@"AU",@"BR",@"NL",@"HK",@"IN",@"RU"];
    
    if (!TenonP2pLib.sharedInstance.IsVip) {
        // 非vip显示地步广告
        [self addAdView];
    }
    
    
    _aboutBtn = [[UIButton alloc] init];
    [_aboutBtn setTitle:GCLocalizedString(@"About") forState:0];
    [_aboutBtn setTitleColor:kRBColor(21,203,191) forState:0];
    _aboutBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_aboutBtn addTarget:self action:@selector(aboutBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_aboutBtn];
    
    [_aboutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(55);
        make.centerX.mas_equalTo(-45);
        make.bottom.equalTo(_ADView.mas_top);
    }];
    
    _vipTgBtn = [[UIButton alloc] init];
    [_vipTgBtn setTitle:GCLocalizedString(@"Telegram") forState:0];
    [_vipTgBtn setTitleColor:kRBColor(21,203,191) forState:0];
    _vipTgBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_vipTgBtn addTarget:self action:@selector(tgBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_vipTgBtn];
    [_vipTgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(55);
        make.centerX.mas_equalTo(45);
        make.bottom.equalTo(_ADView.mas_top);
    }];
    
    if ([swiftViewController IsConnected]) {
        self.isLink = true;
        [self refreshLinkView];
    }
}

-(void)addADBgView
{
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT)];
    _loadingView.backgroundColor = kRGBA(0, 0, 0, 0.6);
    [self.view addSubview:_loadingView];
    [self.view bringSubviewToFront:_loadingView];
    //进度条
    RBProgressView *progressView = [[RBProgressView alloc] initWithFrame:CGRectMake(40, kHEIGHT/2+119*kSCALE, kWIDTH-80, 12*kSCALE)];
    //进度条边框宽度
    progressView.progerStokeWidth=1.0f;
    //进度条未加载背景
    progressView.progerssBackgroundColor=[UIColor blackColor];
    //进度条已加载 颜色
    progressView.progerssColor=kRBColor(18, 181, 170);
    //背景边框颜色
    progressView.progerssStokeBackgroundColor=kRBColor(18, 181, 170);
    [_loadingView addSubview:progressView];
    self.progressView = progressView;
}

-(void)aboutBtnClicked:(UIButton *)sender
{
    AboutViewController *nextVC = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

-(void)tgBtnClicked:(UIButton *)sender
{
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString: @"https://t.me/tenonvpn"];
    if (TenonP2pLib.sharedInstance.IsVip) {
        URL = [NSURL URLWithString: @"https://t.me/tenonvpn_vip"];
    }
    if (@available(iOS 10.0, *)) {
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            
        }];
    } else {
        // Fallback on earlier versions
        BOOL success = [application openURL:URL];
    }
}

-(void)addLeftView
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(12, top_H+106, (kWIDTH-35)/2, 104)];
    leftView.backgroundColor = kRBColor(21, 25, 25);
    leftView.layer.cornerRadius = 4.0f;
    leftView.layer.masksToBounds = YES;
    [self.view addSubview:leftView];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = GCLocalizedString(@"Anonymous User");
    _nameLabel.font = Font_B(20);
    _nameLabel.textColor = kRBColor(154, 162, 161);
    [leftView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView).offset(12);
        make.top.equalTo(leftView).offset(10);
    }];
    
    UIButton *editBtn = [[UIButton alloc] init];
    [editBtn setImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(inputBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.right.equalTo(leftView.mas_right).offset(-16);
        make.centerY.equalTo(_nameLabel);
    }];
    
    _codeLabel = [[UILabel alloc] init];
    _codeLabel.text = swiftViewController.local_account_id;
    _codeLabel.font = [UIFont systemFontOfSize:13];
    _codeLabel.textColor = kRBColor(76, 85, 85);
    _codeLabel.numberOfLines = 0;
    _codeLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [leftView addSubview:_codeLabel];
    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView).offset(10);
        make.right.equalTo(leftView.mas_right).offset(-14);
        make.top.equalTo(_nameLabel.mas_bottom).offset(6);
    }];
    self.codeLabel.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPre:)];
    [self.codeLabel addGestureRecognizer:longPress];
}

-(void)editBtnClicked
{
    NSUserDefaults* defaluts = [NSUserDefaults standardUserDefaults];
    [defaluts setObject:@"CLICK_SETTING" forKey:@"CLICK_SETTING"];
    [defaluts synchronize];
    SettingViewController *nextVC = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:nextVC animated:YES];
}

-(void)addRightView
{
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(23+(kWIDTH-35)/2, top_H+106, (kWIDTH-35)/2, 104)];
    rightView.backgroundColor = kRBColor(21, 25, 25);
    rightView.layer.cornerRadius = 4.0f;
    rightView.layer.masksToBounds = YES;
    [self.view addSubview:rightView];
    
    UILabel *titLabel = [[UILabel alloc] init];
    titLabel.text = GCLocalizedString(@"Private key");
    titLabel.font = Font_B(20);
    titLabel.textColor = kRBColor(154, 162, 161);
    [rightView addSubview:titLabel];
    [titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightView).offset(12);
        make.top.equalTo(rightView).offset(10);
    }];
    
    _eyeBtn = [[UIButton alloc] init];
    [_eyeBtn setImage:[UIImage imageNamed:@"hidden_icon"] forState:UIControlStateNormal];
    [_eyeBtn addTarget:self action:@selector(eyeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:_eyeBtn];
    [_eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.right.equalTo(rightView.mas_right).offset(-16);
        make.centerY.equalTo(titLabel);
    }];
    
    NSMutableString *codeS = [[NSMutableString alloc] init];
    for (int i=0;i<80;i++) {
        [codeS appendString:@"*"];
    }
    _keyLabel = [[UILabel alloc] init];
    _keyLabel.text = codeS.copy;
    _keyLabel.font = [UIFont systemFontOfSize:13];
    _keyLabel.textColor = kRBColor(76, 85, 85);
    _keyLabel.numberOfLines = 0;
    _keyLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [rightView addSubview:_keyLabel];
    [_keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightView).offset(10);
        make.right.equalTo(rightView.mas_right).offset(-14);
        make.top.equalTo(titLabel.mas_bottom).offset(6);
    }];
    self.keyLabel.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPre1:)];
    [self.keyLabel addGestureRecognizer:longPress];
}

-(void)eyeBtnClicked:(UIButton *)sender
{
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    _isShow = !_isShow;
    if(_isShow) {
        [_eyeBtn setImage:[UIImage imageNamed:@"show_icon"] forState:UIControlStateNormal];
        _keyLabel.text = swiftViewController.local_private_key;
    } else {
        [_eyeBtn setImage:[UIImage imageNamed:@"hidden_icon"] forState:UIControlStateNormal];
        NSMutableString *codeS = [[NSMutableString alloc] init];
        for (int i=0;i<80;i++) {
            [codeS appendString:@"*"];
        }
        _keyLabel.text = codeS.copy;
    }
}

-(void)inputBtnClicked
{
    _inputTextField.text = @"";
    _inputAlertBgView.hidden = NO;
    [self.view bringSubviewToFront:_inputAlertBgView];
}

-(void)addTwoLeftView
{
    UIView *twoLeftView = [[UIView alloc] initWithFrame:CGRectMake(12, top_H+220, (kWIDTH-35)/2, 106)];
    [self.view addSubview:twoLeftView];
    
    UIImageView *bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kWIDTH-35)/2, 106)];
    bgImgV.image = [UIImage imageNamed:@"black_bg3"];
    [twoLeftView addSubview:bgImgV];
    
    _typeSignLabel = [[UILabel alloc] init];
    _typeSignLabel.text = @"FREE!";
    _typeSignLabel.font = Font_B(20);
    _typeSignLabel.textColor = kRBColor(18, 181, 170);
    [twoLeftView addSubview:_typeSignLabel];
    [_typeSignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(twoLeftView).offset(12);
        make.top.equalTo(twoLeftView).offset(12);
        make.height.mas_equalTo(28);
    }];
    
    UILabel *chongL = [[UILabel alloc] init];
    chongL.text = GCLocalizedString(@"+");
    chongL.font = Font_B(30);
    chongL.textColor = kRBColor(18, 181, 170);
    [twoLeftView addSubview:chongL];
    [chongL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(twoLeftView).offset(-18);
        make.top.equalTo(twoLeftView).offset(12);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *chongBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (kWIDTH-35)/2, 106)];
    [chongBtn addTarget:self action:@selector(addMoreFreeTime) forControlEvents:UIControlEventTouchUpInside];
    [twoLeftView addSubview:chongBtn];
    
    _typeTextLabel = [[UILabel alloc] init];
    _typeTextLabel.text = GCLocalizedString(@"FreeDDDDDDDD");
    _typeTextLabel.font = [UIFont systemFontOfSize:18];
    _typeTextLabel.textColor = kRBColor(154, 162, 161);
    [twoLeftView addSubview:_typeTextLabel];
    [_typeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(twoLeftView).offset(12);
        make.top.equalTo(_typeSignLabel.mas_bottom).offset(30);
    }];
}

-(void)addTwoRightView
{
    UIView *alreadV = [self.view viewWithTag:333];
    [alreadV removeFromSuperview];
    
    UIView *twoRightView = [[UIView alloc] initWithFrame:CGRectMake(23+(kWIDTH-35)/2, top_H+220, (kWIDTH-45)/2, 106)];
    twoRightView.tag = 333;
    [self.view addSubview:twoRightView];
    twoRightView.clipsToBounds = YES;
    twoRightView.layer.masksToBounds = YES;
    
    UIImageView *bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kWIDTH-35)/2, 106)];
    bgImgV.image = [UIImage imageNamed:@"black_bg2"];
    [twoRightView addSubview:bgImgV];
    
    if(false) {
        UILabel *rtLabel = [[UILabel alloc] init];
        rtLabel.text = GCLocalizedString(@"Higher performance");
        rtLabel.font = Font_M(20);
        rtLabel.textColor = kRBColor(18, 181, 170);
        [twoRightView addSubview:rtLabel];
        [rtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(twoRightView).offset(-12);
            make.top.equalTo(twoRightView).offset(12);
            make.height.mas_equalTo(20);
        }];
        NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
        NSString *mystr = [defaultdata objectForKey:@"language"];
        if (!mystr || !mystr.length) {
            mystr = @"Default";
        }
        NSString *img_name = @"update_en";
        if ([mystr isEqualToString: @"Default"] || [mystr isEqualToString: @"English"]) {
            img_name = @"update_en";
        } else if ([mystr isEqualToString: @"中文"]) {
            img_name = @"update_cn";
        }
        UIImageView *updateImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:img_name]];
        [twoRightView addSubview:updateImg];
        [updateImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(twoRightView).offset(-12);
            make.top.equalTo(rtLabel.mas_bottom).offset(26);
            make.width.mas_equalTo(103);
            make.height.mas_equalTo(24);
        }];
        
//        UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (kWIDTH-35)/2, 106)];
//        [changeBtn addTarget:self action:@selector(toUpdateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [twoRightView addSubview:changeBtn];
    } else {
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(50, 20, (kWIDTH-35)/2-30, 10)];
        lineV.backgroundColor = [UIColor blackColor];
        [twoRightView addSubview:lineV];
        lineV.transform = CGAffineTransformMakeRotation(-M_PI/6);
        
        UILabel *chongL = [[UILabel alloc] init];
        chongL.text = GCLocalizedString(@"Charge flow");
        chongL.font = Font_B(20);
        chongL.textColor = kRBColor(18, 181, 170);
        [twoRightView addSubview:chongL];
        CGFloat leftF = 44;
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"AppLanguagesKey"] isEqualToString:@"en"]) {
            leftF = 30;
        }
        [chongL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(twoRightView).offset(leftF);
            make.top.equalTo(twoRightView).offset(12);
            make.height.mas_equalTo(20);
        }];
        
//        UILabel *tiL = [[UILabel alloc] init];
//        tiL.text = GCLocalizedString(@"Seel out");
//        tiL.font = Font_B(20);
//        tiL.textColor = kRBColor(18, 181, 170);
//        [twoRightView addSubview:tiL];
//        [tiL mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(twoRightView).offset(-12);
//            make.bottom.equalTo(twoRightView).offset(-12);
//            make.height.mas_equalTo(20);
//        }];
        
        UIButton *chongBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
        [chongBtn addTarget:self action:@selector(chongBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [twoRightView addSubview:chongBtn];
        
//        UIButton *tiXianBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 35, (kWIDTH-35)/2-50, 65)];
//        [tiXianBtn addTarget:self action:@selector(tiXianBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//        [twoRightView addSubview:tiXianBtn];
    }
    
}

-(void)toUpdateBtnClicked:(UIButton *)sender
{
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    [self changeBtnClicked:sender];
}

-(void)addMoreFreeTime
{
    [self clickIncreaseFreeTime];
}

-(void)chongBtnClicked
{
    RechargeViewController *nextVC = [[RechargeViewController alloc] init];
    nextVC.backBlock = ^{
    };
    [self.navigationController pushViewController:nextVC animated:YES];
}

-(void)tiXianBtnClicked
{
    NSURL* url2 = [NSURL URLWithString:@"https://www.tenonvpn.net/withdraw"];
    UIApplication *application = [UIApplication sharedApplication];
    if (@available(iOS 10.0, *)) {
        [application openURL:url2 options:@{} completionHandler:^(BOOL success) {

        }];
    } else {
        // Fallback on earlier versions
        BOOL success = [application openURL:url2];
    }
}

-(void)refreshLinkView
{
    [_linkBgView removeFromSuperview];
    [_linkNoticeLabel removeFromSuperview];
    if(!_isLink) {
        _linkBgView = [[UIView alloc] initWithFrame:CGRectMake((kWIDTH-150)/2, top_H+270, 150, 150)];
        _linkBgView.backgroundColor = kRBColor(67, 77, 76);
        _linkBgView.layer.cornerRadius = 75.0f;
        _linkBgView.layer.masksToBounds = YES;
        [self.view addSubview:_linkBgView];
        [self.view bringSubviewToFront:_linkBgView];
        
        _linkImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_link_icon"]];
        [_linkBgView addSubview:_linkImg];
        [_linkImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_linkBgView);
            make.width.height.mas_equalTo(32);
            make.top.equalTo(_linkBgView).offset(40);
        }];
        
        _linkLabel = [[UILabel alloc] init];
        _linkLabel.text = GCLocalizedString(@"Disconnect");
        _linkLabel.font = Font_B(20);
        _linkLabel.textColor = kRBColor(214, 223, 221);
        [_linkBgView addSubview:_linkLabel];
        [_linkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_linkBgView);
            make.top.equalTo(_linkImg.mas_bottom);
            make.height.mas_offset(33);
        }];
        
        self.linkBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        [self.linkBtn addTarget:self action:@selector(linkBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_linkBgView addSubview:self.linkBtn];
    }
    else
    {
        _linkBgView = [[UIView alloc] initWithFrame:CGRectMake((kWIDTH-162)/2, top_H+264, 162, 182)];
        [self.view addSubview:_linkBgView];
        [self.view bringSubviewToFront:_linkBgView];
        
        UIImageView *linkCircleImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 162, 174)];
        linkCircleImg.image = [UIImage imageNamed:@"circle_line"];
        [_linkBgView addSubview:linkCircleImg];
        
        UIView *yuanV = [[UIView alloc] initWithFrame:CGRectMake(6, 6, 150, 150)];
        yuanV.backgroundColor = kRBColor(21, 203, 191);
        yuanV.layer.cornerRadius = 75.0f;
        yuanV.layer.masksToBounds = YES;
        [_linkBgView addSubview:yuanV];
        
        _linkImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"link_icon"]];
        [yuanV addSubview:_linkImg];
        [_linkImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(yuanV);
            make.width.height.mas_equalTo(32);
            make.top.equalTo(yuanV).offset(40);
        }];
        
        _linkLabel = [[UILabel alloc] init];
        _linkLabel.text = GCLocalizedString(@"Connected");
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"AppLanguagesKey"] isEqualToString:@"en"]) {
            _linkLabel.font = Font_B(20);
        } else {
            _linkLabel.font = Font_B(20);
        }
        _linkLabel.textColor = kRBColor(0, 41, 51);
        [yuanV addSubview:_linkLabel];
        [_linkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(yuanV);
            make.top.equalTo(_linkImg.mas_bottom);
            make.height.mas_offset(33);
        }];
        
        self.linkBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 162, 162)];
        [self.linkBtn addTarget:self action:@selector(linkBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_linkBgView addSubview:self.linkBtn];
        
        _linkNoticeLabel = [[UILabel alloc] init];
        _linkNoticeLabel.text = GCLocalizedString(@"P2P networks are protecting your IP and data privacy");
        _linkNoticeLabel.font = [UIFont systemFontOfSize:12];
        _linkNoticeLabel.textColor = kRBColor(21, 209, 191);
        [self.view addSubview:_linkNoticeLabel];
        [_linkNoticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(linkCircleImg.mas_bottom).offset(3);
            make.height.mas_offset(18);
        }];
    }
}

-(void)disconnectVpn
{
    if (_loadingTime > 0) {
        return;
    }
    
    if (self.isLink == YES) {
        [swiftViewController DoClickDisconnect];
        self.isLink = NO;
        [self refreshLinkView];
    }
}

-(void)linkBtnClicked
{
    NSUserDefaults * userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.tenon.tenonvpn"];
    [userDefaults synchronize];
    UInt64 mLeftFreeUseTimeMilli = [userDefaults integerForKey:@"mLeftFreeUseTimeMilli"];
    if (mLeftFreeUseTimeMilli <= 1000) {
        [self showToast2];
        _outoftimeShowed = true;
        return;
    }
    
    if (_outoftimeShowed) {
        _outoftimeShowed = false;
    }

    if (self.isLink == YES) {
        [self disconnectVpn];
    }else {
        //[self showAdsTimer];
        [self connectVpn];
    }
}
- (void)connectVpn{
    if (_loadingTime > 0) {
        return;
    }
    
    [swiftViewController DoClickConnect];
    [self addtagBtnClicked];
    self.linkBtn.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.linkBtn.enabled = YES;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.isLink && swiftViewController.user_started_vpn) {
            self.isLink = true;
            [self refreshLinkView];
        }
    });
}
#pragma mark -刷新顶部视图
-(void)refreshFreeView
{
    [[self.freeView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addTwoRightView];
    if(_isFree)
    {
        UILabel *freeLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, 36)];
        freeLab.text = GCLocalizedString(@"Community");
        freeLab.textColor = kRBColor(18, 181, 170);
        freeLab.font = Font_B(19);
        [_freeView addSubview:freeLab];
        
        _typeSignLabel.text = @"FREE!";
        _typeTextLabel.text = GCLocalizedString(@"Free");
    }
    else
    {
        UILabel *proLab = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200, 36)];
        proLab.text = GCLocalizedString(@"Professional");
        proLab.textColor = kRBColor(18, 181, 170);
        proLab.font = Font_B(20);
        [_freeView addSubview:proLab];
        
        UILabel *freeLab = [[UILabel alloc] initWithFrame:CGRectMake(46, 0, 100, 36)];
        freeLab.text = GCLocalizedString(@"");
        freeLab.textColor = kRBColor(154, 162, 161);
        freeLab.font = Font_M(14);
        [_freeView addSubview:freeLab];
        
//        UILabel *freeL = [[UILabel alloc] initWithFrame:CGRectMake(kWIDTH-24-54, 0, 50, 36)];
//        freeL.text = GCLocalizedString(@"Free");
//        freeL.textColor = kRBColor(18, 181, 170);
//        freeL.font = [UIFont systemFontOfSize:19];
//        [_freeView addSubview:freeL];
//
//        UIImageView *changeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"change_icon"]];
//        [_freeView addSubview:changeImg];
//        [changeImg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_freeView);
//            make.height.width.mas_equalTo(18);
//            make.right.equalTo(freeL.mas_left).offset(-7);
//        }];
        
//        UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kWIDTH-24, 36)];
//        [changeBtn addTarget:self action:@selector(changeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [_freeView addSubview:changeBtn];
        
        if (TenonP2pLib.sharedInstance.vip_left_days >= 0) {
            UInt64 show_balance = TenonP2pLib.sharedInstance.GetBalance + TenonP2pLib.sharedInstance.GetLocalAmount;
            TenonP2pLib.sharedInstance.PayforVpn;
            _typeSignLabel.text = [NSString stringWithFormat:@"%d%@",TenonP2pLib.sharedInstance.vip_left_days, GCLocalizedString(@"left_days")];
            _typeTextLabel.text = [NSString stringWithFormat:@"%lld TEN",show_balance];
        } else {
            _typeSignLabel.text = [NSString stringWithFormat:@"%d%@", 0, GCLocalizedString(@"left_days")];
            _typeTextLabel.text = [NSString stringWithFormat:@"%d TEN",0];
        }
    }
    
    [self reloadBalance];
}

-(void)changeBtnClicked:(UIButton *)sender
{
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    _isFree = !_isFree;
    [self refreshFreeView];
}

-(void)initInputAlertView
{
    _inputAlertBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT)];
    _inputAlertBgView.backgroundColor = kRGBA(0, 0, 0, 0.6);
    [self.view addSubview:_inputAlertBgView];
    _inputAlertBgView.hidden = YES;
    
    UIView *_inputAlertView = [[UIView alloc] init];
    _inputAlertView.backgroundColor = kRGBA(30, 30, 30, 0.75);
    _inputAlertView.layer.cornerRadius = 14.0f;
    _inputAlertView.layer.masksToBounds = YES;
    [_inputAlertBgView addSubview:_inputAlertView];
    [_inputAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(270);
        make.height.mas_equalTo(150);
        make.center.equalTo(self.view);
    }];
    
    
    UILabel *titleLs = [[UILabel alloc] initWithFrame:CGRectMake(16, 20, 238, 22)];
    titleLs.textAlignment = NSTextAlignmentCenter;
    titleLs.textColor = [UIColor whiteColor];
    titleLs.font = Font_H(17);
    titleLs.text = GCLocalizedString(@"Enter private key");
    [_inputAlertView addSubview:titleLs];
    
    UIView *inputBgV = [[UIView alloc] initWithFrame:CGRectMake(16, 62, 238, 25)];
    inputBgV.layer.cornerRadius = 5.0f;
    inputBgV.backgroundColor = kRBColor(67, 77, 76);
    [_inputAlertView addSubview:inputBgV];
    
    _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 228, 25)];
    _inputTextField.textColor = [UIColor whiteColor];
    _inputTextField.placeholder = GCLocalizedString(@"Enter the 64-bit private key");
    _inputTextField.font = kFont(13);
    NSDictionary *dic = @{NSForegroundColorAttributeName:kRBColor(154, 162, 161), NSFontAttributeName:[UIFont systemFontOfSize:13]};
    _inputTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:GCLocalizedString(@"Enter the 64-bit private key") attributes:dic];
    [inputBgV addSubview:_inputTextField];
    
    UIView *henLine = [[UIView alloc] initWithFrame:CGRectMake(0, 105, 270, 0.5)];
    henLine.backgroundColor = kRBColor(60, 60, 67);
    [_inputAlertView addSubview:henLine];
    
    UIView *shuLine = [[UIView alloc] initWithFrame:CGRectMake(135, 105.5, 0.5, 44)];
    shuLine.backgroundColor = kRBColor(60, 60, 67);
    [_inputAlertView addSubview:shuLine];
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 105, 135, 44)];
    [cancleBtn setTitle:GCLocalizedString(@"Cancel") forState:UIControlStateNormal];
    [cancleBtn setTitleColor:kRBColor(214, 223, 221) forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = kFont(17);
    [cancleBtn addTarget:self action:@selector(cancleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_inputAlertView addSubview:cancleBtn];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(135, 105, 135, 44)];
    [confirmBtn setTitle:GCLocalizedString(@"OK") forState:UIControlStateNormal];
    [confirmBtn setTitleColor:kRBColor(18, 181, 170) forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = Font_B(17);
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_inputAlertView addSubview:confirmBtn];
}

-(void)cancleBtnClicked
{
    [self.view endEditing:YES];
    _inputTextField.text = @"";
    _inputAlertBgView.hidden = YES;
}

- (void)exitApplication {
    [UIView beginAnimations:@"exitApplication" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view cache:NO];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.view.bounds = CGRectMake(0, 0, 0, 0);
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

-(void)confirmBtnClicked
{
    [self.view endEditing:YES];
    int res = [swiftViewController ResetPrivateKey:_inputTextField.text];
    if (res == 1) {
        
    } else if (res == 2){
        [self.view makeToast:GCLocalizedString(@"invalid private key.") duration:2 position:CENTER];
    } else if (res == 3) {
        [self.view makeToast:GCLocalizedString(@"Set up to 3 private keys.") duration:2 position:CENTER];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:GCLocalizedString(@"OK")
                                    message:GCLocalizedString(@"after success reset private key, must restart program.")
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:GCLocalizedString(@"OK") style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) { [self exitApplication]; }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    _inputTextField.text = @"";
    _inputAlertBgView.hidden = YES;
}

-(void)addAdView
{
    _ADView = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT-60, kWIDTH, 60)];
    _ADView.backgroundColor = kRBColor(59, 34, 116);
    NSString* adUID = @"ca-app-pub-1878869478486684/1414406836";
    self.bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(CGSizeMake(_ADView.width, _ADView.height))];
    self.bannerView.frame = CGRectMake(0, 0, _ADView.width, _ADView.height);
    self.bannerView.adUnitID = adUID;
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    self.bannerView.delegate = self;
    
    [self.view addSubview:_ADView];
}

- (void)adViewDidReceiveAd:(GADBannerView *)adView {
  // Add adView to view and add constraints as above.
    [_ADView addSubview:self.bannerView];
    adView.alpha = 0;
    [UIView animateWithDuration:1.0 animations:^{
      adView.alpha = 1;
    }];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kWIDTH;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrayOne.count;
}

- (void)requestRechargeInterface{
    if ([[KeychainManager shareInstence] getKeyChainReceipt].length > 0) {
        UInt64 localAmount = [[TenonP2pLib sharedInstance] GetBalance];
        NSString *type = @"1";
        if (localAmount == 1990) {
            type = @"1";
        } else if (localAmount == 5950) {
            type = @"2";
        } else if (localAmount == 23800) {
            type = @"3";
        }
        
        [JTNetwork requestPostWithParam:@{@"account":[TenonP2pLib sharedInstance].account_id,
                                          @"receipt":[[KeychainManager shareInstence] getKeyChainReceipt],
                                          @"type":type}
                                    url:@"/appleIAPAuth" callback:^(JTBaseReqModel *model) {
            NSLog(@"调用服务端接口充值, %@, %@, %@",
                  [TenonP2pLib sharedInstance].account_id,
                  type,
                  [[KeychainManager shareInstence] getKeyChainReceipt]);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.rechargeTimer invalidate];
                self.rechargeTimer = nil;
                self.rechargeTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(requestRechargeInterface) userInfo:nil repeats:NO];
            });
        }];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH-40, 44)];
    myView.backgroundColor = [UIColor blackColor];
    
    UIImageView *imgs = [[UIImageView alloc] initWithFrame:CGRectMake(32, 15, 20, 14)];
    imgs.image = [UIImage imageNamed:arrayImg[row]];
    [myView addSubview:imgs];
    
    UILabel *labels = [[UILabel alloc] initWithFrame:CGRectMake(64, 0, 130, 44)];
    labels.font = [UIFont systemFontOfSize:18];
    labels.textColor = kRBColor(214, 223, 221);
    labels.text = arrayOne[row];
    [myView addSubview:labels];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(kWIDTH-182, 0, 100, 44)];
    label2.font = [UIFont systemFontOfSize:16];
    label2.textAlignment = NSTextAlignmentRight;
    label2.textColor = kRBColor(214, 223, 221);
    int value = arc4random() % 500 + 100;
    label2.text = [NSString stringWithFormat:@"%d %@",value, GCLocalizedString(@"nodes")];
    [myView addSubview:label2];
    return myView;
}

//设置显示内容的高度
- (CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50 ;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (![_choosedCountry isEqualToString: arrayShortCountry[row]]) {
        VpnManager.shared.choosed_country = arrayShortCountry[row];
        swiftViewController.choosed_country = arrayShortCountry[row];
        _choosedCountry = arrayShortCountry[row];
        [swiftViewController DoClickDisconnect];
        self.isLink = false;
        [self refreshLinkView];
    }
    
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    return (action == @selector(copy:) || action == @selector(copy1:));
//}

- (void)copy:(id)sender{
    NSLog(@"copy account id called: %@", swiftViewController.local_account_id);
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = swiftViewController.local_account_id;
}

- (void)copy1:(id)sender{
    NSLog(@"copy private key called: %@", swiftViewController.local_private_key);
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = swiftViewController.local_private_key;
}
// 处理长按事件
- (void)longPre:(UILongPressGestureRecognizer *)recognizer{
    [self becomeFirstResponder];
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = swiftViewController.local_account_id;
    [self.view makeToast:GCLocalizedString(@"Copy success!") duration:2 position:BOTTOM];
}

// 处理长按事件
- (void)longPre1:(UILongPressGestureRecognizer *)recognizer{
    [self becomeFirstResponder];
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = swiftViewController.local_private_key;
    [self.view makeToast:GCLocalizedString(@"Copy success!") duration:2 position:BOTTOM];
}

-(void)addtagBtnClicked
{
    [self addADBgView];
    self.progressView.progress = 0;
    
    _loadingTime = 7;
    
    self.progressView.textLabel.text = [NSString stringWithFormat:@"%@…%lds",GCLocalizedString(@"Linking for you"),(long)_loadingTime];
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    self.codeTimer = [MSWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getCodeTime) userInfo:nil repeats:YES dispatchQueue:(mainQueue)];
    
    [UIView animateWithDuration:_loadingTime animations:^{
        self.progressView.progress = 1;
      } completion:^(BOOL finished) {
          self.loadingView.hidden = YES;
          self.progressView.textLabel.text = [NSString stringWithFormat:@"%@…0s",GCLocalizedString(@"Linking for you")];
          [self.loadingView removeFromSuperview];
      }];
}

-(void)getCodeTime
{
    UInt64 nowTm = [[NSDate date] timeIntervalSince1970]*1000;
    if (self.rewardedInterstitialAd != nil && !TenonP2pLib.sharedInstance.IsVip && swiftViewController.user_started_vpn && (nowTm - _prevShowInsAdTimestamp >= 30000)) {
        [self showInsAd];
        if (self.codeTimer != nil) {
          [self.codeTimer invalidate];
          self.codeTimer = nil;
        }

        self.loadingView.hidden = YES;
        [self.loadingView removeFromSuperview];
        self.isLink = true;
        [self refreshLinkView];
        _loadingTime = 0;
    }
    
    if (swiftViewController.user_started_vpn && (TenonP2pLib.sharedInstance.IsVip || (nowTm - _prevShowInsAdTimestamp < 30000))) {
        if (self.codeTimer != nil) {
          [self.codeTimer invalidate];
          self.codeTimer = nil;
        }

        self.loadingView.hidden = YES;
        [self.loadingView removeFromSuperview];
        self.isLink = true;
        [self refreshLinkView];
        _loadingTime = 0;
    }
    _loadingTime -= 1;
    if(_loadingTime > 0) {
        self.progressView.textLabel.text = [NSString stringWithFormat:@"%@…%lds",GCLocalizedString(@"Linking for you"),(long)_loadingTime];
    } else {
        if (!swiftViewController.user_started_vpn) {
            [self.view makeToast:GCLocalizedString(@"exit_and_retry") duration:2 position:BOTTOM];
            self.isLink = false;
            [self refreshLinkView];
        }
        if (self.codeTimer != nil) {
          [self.codeTimer invalidate];
          self.codeTimer = nil;
        }
    }
}


-(void)clickIncreaseFreeTime
{
    [self addADBgView];
    self.progressView.progress = 0;
    _loadingTime = 7;
    self.progressView.textLabel.text = [NSString stringWithFormat:@"%@…%lds",GCLocalizedString(@"Linking for you"),(long)_loadingTime];
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    self.codeTimer = [MSWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incFreeGetCodeTime) userInfo:nil repeats:YES dispatchQueue:(mainQueue)];
    
    [UIView animateWithDuration:_loadingTime animations:^{
        self.progressView.progress = 1;
      } completion:^(BOOL finished) {
          self.loadingView.hidden = YES;
          self.progressView.textLabel.text = [NSString stringWithFormat:@"%@…0s",GCLocalizedString(@"Linking for you")];
          [self.loadingView removeFromSuperview];
      }];
}

-(void)incFreeGetCodeTime
{
    if (!TenonP2pLib.sharedInstance.IsVip) {
        bool adShowd = false;
        if (self.rewardedAd_5.isReady) {
            [self.rewardedAd_5 presentFromRootViewController:self delegate:self];
            adShowd = true;
            NSLog(@"rewardedAd_5 called!");
        } else if (self.rewardedAd_3.isReady) {
            [self.rewardedAd_3 presentFromRootViewController:self delegate:self];
            adShowd = true;
            NSLog(@"rewardedAd_3 called!");
        } else if (self.rewardedAd.isReady) {
            [self.rewardedAd presentFromRootViewController:self delegate:self];
            adShowd = true;
            NSLog(@"rewardedAd called!");
        }
        
        if (adShowd) {
            if (self.codeTimer != nil) {
              [self.codeTimer invalidate];
              self.codeTimer = nil;
            }

            self.loadingView.hidden = YES;
            [self.loadingView removeFromSuperview];
            _loadingTime = 0;
        }
    }
    
    if (swiftViewController.user_started_vpn && TenonP2pLib.sharedInstance.IsVip) {
        if (self.codeTimer != nil) {
          [self.codeTimer invalidate];
          self.codeTimer = nil;
        }

        self.loadingView.hidden = YES;
        [self.loadingView removeFromSuperview];
        _loadingTime = 0;
    }
    _loadingTime -= 1;
    if(_loadingTime > 0) {
        self.progressView.textLabel.text = [NSString stringWithFormat:@"%@…%lds",GCLocalizedString(@"Linking for you"),(long)_loadingTime];
    } else {

            [self.view makeToast:GCLocalizedString(@"ad_exit_and_retry") duration:2 position:BOTTOM];

        if (self.codeTimer != nil) {
          [self.codeTimer invalidate];
          self.codeTimer = nil;
        }
    }
}

@end
