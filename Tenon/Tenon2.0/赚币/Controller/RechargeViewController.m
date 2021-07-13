//
//  RechargeViewController.m
//  Tenonvpn
//
//  Created by Raobin on 2020/8/30.
//  Copyright © 2020 Raobin. All rights reserved.
//

#import "RechargeViewController.h"
#import "HistoryListTableViewCell.h"
#import "ADViewController.h"
#import "TenonVPN-Swift.h"
#import "getTenonCell.h"
#import "UISpaceCell.h"
#import "TenonHeadCell.h"
#import "TSShareHelper.h"
#import "UITipsCell.h"
#import "OrderListHeaderCell.h"
#import "RBProgressView.h"
#import "MSWeakTimer.h"
#import "libp2p/libp2p.h"
#import <CommonCrypto/CommonDigest.h>
#import <StoreKit/StoreKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "MainViewController.h"

extern ViewController *swiftViewController;

@interface RechargeViewController()<UITableViewDelegate,UITableViewDataSource,SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (nonatomic, assign) NSInteger selectIdx;
@property (nonatomic, strong) NSString* selectAppleGoodsID;
@property (nonatomic, strong) NSString* applepayProducID;
@property (nonatomic, strong) NSString* receipt;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *listarray;

@property (nonatomic, strong) GADRewardedAd *rewardedAd;
@property (nonatomic, strong) GADAdLoader *adLoader;
@property (nonatomic, assign) BOOL bIsShowAd;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIView *loadingAdView;
@property (nonatomic, strong) RBProgressView *progressView;
@property (nonatomic, strong) MSWeakTimer *codeTimer;
@property (nonatomic, assign) NSInteger loadingTime;
@property (nonatomic, assign) MainViewController* mainViewController;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) NSTimer * rechargeTimer;
@property (nonatomic, assign) NSInteger prevPurchaseTime;
@end

@implementation RechargeViewController

- (void)requestRechargeInterface{
    if ([[KeychainManager shareInstence] getKeyChainReceipt].length == 0) {
        NSLog(@"交易凭证为空--用户第一次充值失败后，重新进入页面以后，app调用自动充值成功，并且清空了本地keychaint交易记录信息");
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
    }else{
        NSLog(@"交易凭证不为空--用户第一次充值失败后，重新进入页面以后，会走到这里，去调用充值接口");
        [JTNetwork requestPostWithParam:@{@"account":[TenonP2pLib sharedInstance].account_id,
                                          @"receipt":[[KeychainManager shareInstence] getKeyChainReceipt],
                                          @"type":@([[KeychainManager shareInstence] getKeyChainType])}
                                    url:@"/appleIAPAuth" callback:^(JTBaseReqModel *model) {
            NSLog(@"调用服务端接口充值");
            // 调用充值成功，再次启动定时器，验证转币是否成功（调用TenonP2pLib.GetBalance()去清空本地keychaint ），查看本地keychaint是否为空
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.rechargeTimer invalidate];
                self.rechargeTimer = nil;
                self.rechargeTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(requestRechargeInterface) userInfo:nil repeats:NO];
            });
        }];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self createAndLoadRewardedAd];
    self.view.backgroundColor = [UIColor blackColor];
    [self addNav];
    [self initUI];
    self.selectIdx = -1;
    self.selectAppleGoodsID = @"";
    if ([[KeychainManager shareInstence] getKeyChainReceipt].length == 0) {
        NSLog(@"getKeyChainReceipt");
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
    }else{
        // 交易凭证不为空，代表之前充值苹果验证通过以后，充值接口调用失败
        self.rechargeTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(requestRechargeInterface) userInfo:nil repeats:NO];
    }
}
- (void)startTimer{
    [_listarray removeAllObjects];
    [self loadUI];
    [_myTableView reloadData];
}
- (void)loadUI{
    _listarray = [[NSMutableArray alloc] init];
    
    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITitleType),
                                                     BM_title:GCLocalizedString(@"Method one"),
                                                     BM_titleSize:@(24),
                                                     BM_subTitle:GCLocalizedString(@"Transfer Tenon directly to your anonymous account"),
                                                     BM_dataArray:@[swiftViewController.local_private_key],
                                                     BM_subTitleSize:@(24),
                                                     BM_mark:GCLocalizedString(@"Copy")
    }]];
    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                     BM_cellHeight:@10}]];
    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITipsType),
                                                     BM_Index:@"2",
                                                     BM_title:GCLocalizedString(@"Method two"),
                                                     BM_subTitle:GCLocalizedString(@"$9 per month"),
                                                     BM_mark:GCLocalizedString(@"Buy")
    }]];
    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                     BM_cellHeight:@1
    }]];
    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITipsType),
                                                     BM_Index:@"3",
                                                     BM_title:GCLocalizedString(@"Method three"),
                                                     BM_subTitle:GCLocalizedString(@"$21 per quarter/20% off"),
                                                     BM_mark:GCLocalizedString(@"Buy")
    }]];
    
    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                     BM_cellHeight:@1
    }]];
    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITipsType),
                                                     BM_Index:@"4",
                                                     BM_title:GCLocalizedString(@"Method four"),
                                                     BM_subTitle:GCLocalizedString(@"$62 per year /60% off"),
                                                     BM_mark:GCLocalizedString(@"Buy")
    }]];
    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                     BM_cellHeight:@10
    }]];
    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITipsType),
                                                     BM_Index:@"5",
                                                     BM_title:GCLocalizedString(@"Method five"),
                                                     BM_subTitle:GCLocalizedString(@"Watch ads to earn Tenon"),
                                                     BM_mark:GCLocalizedString(@"Go")
    }]];
    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                     BM_cellHeight:@10
    }]];
    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITipsType),
                                                     BM_Index:@"6",
                                                     BM_title:GCLocalizedString(@"Method six"),
                                                     BM_subTitle:GCLocalizedString(@"Share to earn Tenon"),
                                                     BM_mark:GCLocalizedString(@"Share")
    }]];
//    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
//                                                     BM_cellHeight:@10
//    }]];
//    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITipsType),
//                                                     BM_Index:@"7",
//                                                     BM_title:GCLocalizedString(@"Method seven"),
//                                                     BM_subTitle:GCLocalizedString(@"mining"),
//                                                     BM_mark:GCLocalizedString(@"Join")
//    }]];
    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                     BM_cellHeight:@15}]];
    NSString* transcation = @"";
    if ([[KeychainManager shareInstence] getKeyChainTranscate].length == 0) {
        transcation = TenonP2pLib.sharedInstance.GetTransactions;
    }else{
        NSString* local_trans = [[KeychainManager shareInstence] getKeyChainTranscate];
        NSMutableArray* array = [local_trans componentsSeparatedByString:@","];
        UInt64 balance = [[TenonP2pLib sharedInstance] GetBalance];
        if (balance > 1844674407370955161) {
            balance = 0;
        }
        
        int local_amount = [array[2] intValue];
        balance += local_amount;
        NSString* record = [NSString stringWithFormat:@"%@,%s,%@,%llu,%@,0,0;",array[0],"3",array[2],balance,array[4]];
        transcation = [NSString stringWithFormat:@"%@%@", record, TenonP2pLib.sharedInstance.GetTransactions];
    }
    
    if (transcation.length != 0) {
        [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UIOrderListType),
                                                         BM_title:GCLocalizedString(@"OrderList"),
                                                         BM_leading:@(20),
                                                         BM_titleSize:@(20),
                                                         BM_cellHeight:@(20),
                                                         BM_backColor:[UIColor clearColor],
                                                         BM_titleColor:[UIColor colorWithHex:0x12B5AA]
        }]];
        [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                         BM_cellHeight:@8}]];
        
        NSMutableArray* array = [transcation componentsSeparatedByString:@";"];
        [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UILineType),
                                                         BM_dataArray:@[GCLocalizedString(@"Transaction time"),GCLocalizedString(@"Type"),GCLocalizedString(@"volume of trade"),GCLocalizedString(@"Balance")]}]];
        NSInteger idx = 0;
        for (NSString* value in array) {
            NSMutableArray* dataArray = [value componentsSeparatedByString:@","];
            if (dataArray.count < 4) {
                continue;
            }
            NSString* type = dataArray[1];
            NSString* typeValue = @"";
            if ([type intValue] == 1) {
                typeValue = GCLocalizedString(@"pay_for_vpn");
            }else if ([type intValue] == 2){
                typeValue = GCLocalizedString(@"transfer_out");
            }else if ([type intValue] == 3){
                typeValue = GCLocalizedString(@"recharge");
            }else if ([type intValue] == 4){
                typeValue = GCLocalizedString(@"transfer_in");
            }else if ([type intValue] == 5){
                typeValue = GCLocalizedString(@"share_reward");
            }else if ([type intValue] == 6){
                typeValue = GCLocalizedString(@"watch_ad_reward");
            }else if ([type intValue] == 7){
                typeValue = GCLocalizedString(@"mining");
            }
            [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITextType),
                                                             BM_title:dataArray[0],
                                                             BM_subTitle:typeValue,
                                                             BM_backColor:idx%2 == 0?[UIColor whiteColor]:[UIColor colorWithHex:0x12B5AA],
                                                             BM_dataArray:@[dataArray[3],dataArray[2]]
            }]];
            idx++;
        }
    }
}
-(void)createAndLoadRewardedAd{
    self.rewardedAd = [[GADRewardedAd alloc]
          initWithAdUnitID:AD_ID];
    GADRequest *request = [GADRequest request];
    [self.rewardedAd loadRequest:request completionHandler:^(GADRequestError * _Nullable error) {
        if (error) {
            // Handle ad failed to load case.
            [self createAndLoadRewardedAd];
        } else {
            // Ad successfully loaded.
        }
    }];
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
    [self.view makeToast:GCLocalizedString(@"ad_reward_info") duration:2 position:BOTTOM];
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

-(void)addNav
{
    CGFloat topH = isIPhoneXSeries ? 53.0f : 29.0f;
    
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, topH+5, 11, 18)];
    backImg.image = [UIImage imageNamed:@"back_icon"];
    [self.view addSubview:backImg];
    
    UILabel *backLab = [[UILabel alloc] initWithFrame:CGRectMake(29, topH, 140, 28)];
    backLab.text = @"Tenon VPN";
    backLab.textColor = kRBColor(18, 181, 170);
    backLab.font = Font_H(24);
    [self.view addSubview:backLab];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, topH, 200, 30)];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

-(void)backBtnClicked
{
    if (self.backBlock) {
        self.backBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    if (self.timer) {
        [self.timer invalidate];
    }
}
#pragma mark -加载视图


-(void)initUI
{
    CGFloat topH = isIPhoneXSeries ? 53.0f : 29.0f;
    
    UILabel *aboutLab = [[UILabel alloc] initWithFrame:CGRectMake(20, topH+48, 200, 50)];
    aboutLab.text = GCLocalizedString(@"Charge flow");
    aboutLab.textColor = kRBColor(154, 162, 161);
    aboutLab.font = Font_B(36);
    [self.view addSubview:aboutLab];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, aboutLab.bottom - 5, kWIDTH-40, 150)];
    UILabel *label = [[UILabel alloc] init];
    CGSize s = [GCLocalizedString(@"payment_notice") sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kWIDTH-50, 2000) ];
    label.textColor = kRBColor(18, 181, 170);
    label.font = Font_B(16);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.frame =CGRectMake(5, 5, s.width, s.height + 80);
    label.text =GCLocalizedString(@"payment_notice");
    label.numberOfLines = 0;
    label.backgroundColor =[UIColor clearColor];
    
    scrollView.contentSize = label.frame.size;
    [scrollView addSubview:label];
    [self.view addSubview:scrollView];
    
    
//    UILabel *paymentNotice = [[UILabel alloc] initWithFrame:CGRectMake(20, aboutLab.bottom+15, kWIDTH-40, 300)];
//    paymentNotice.text = GCLocalizedString(@"payment_notice");
//    paymentNotice.textColor = kRBColor(18, 181, 170);
//    paymentNotice.lineBreakMode = NSLineBreakByWordWrapping;
//    paymentNotice.numberOfLines = 0;
//    paymentNotice.font = Font_B(15);
//    [self.view addSubview:paymentNotice];
    [self loadUI];
    
    
    UILabel *termOfUse = [[UILabel alloc] initWithFrame:CGRectMake(kWIDTH-320, scrollView.bottom+15, kWIDTH-40, 25)];
    termOfUse.text = GCLocalizedString(@"《Terms Of Use》");
    termOfUse.textColor = kRBColor(154, 162, 161);
    termOfUse.lineBreakMode = NSLineBreakByWordWrapping;
    termOfUse.numberOfLines = 0;
    termOfUse.font = Font_B(16);
    [self.view addSubview:termOfUse];
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTouchUpInside:)];
    [termOfUse addGestureRecognizer:labelTapGestureRecognizer];
    termOfUse.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    UILabel *termOfUse1 = [[UILabel alloc] initWithFrame:CGRectMake(kWIDTH-185, scrollView.bottom+15, kWIDTH-40, 25)];
    termOfUse1.text = GCLocalizedString(@"《Privacy Policy》");
    termOfUse1.textColor = kRBColor(154, 162, 161);
    termOfUse1.lineBreakMode = NSLineBreakByWordWrapping;
    termOfUse1.numberOfLines = 0;
    termOfUse1.font = Font_B(16);
    [self.view addSubview:termOfUse1];
    UITapGestureRecognizer *labelTapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTouchUpInside2:)];
    [termOfUse1 addGestureRecognizer:labelTapGestureRecognizer2];
    termOfUse1.userInteractionEnabled = YES; // 可以理解为设置label可被点击
    
    _myTableView = [[UITableView alloc] init];
    _myTableView.tableFooterView = [[UIView alloc] init];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = [UIColor clearColor];
    _myTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    _myTableView.allowsSelection = NO;
    [_myTableView registCell:@"HistoryListTableViewCell"];
    [_myTableView registCell:@"getTenonCell"];
    [_myTableView registCell:@"UISpaceCell"];
    [_myTableView registCell:@"TenonHeadCell"];
    [_myTableView registCell:@"UITipsCell"];
    [_myTableView registCell:@"OrderListHeaderCell"];
    
    
    _myTableView.estimatedRowHeight = 40;
    [self.view addSubview:_myTableView];
    [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.mas_equalTo(kWIDTH);
        make.top.equalTo(termOfUse1.mas_bottom).offset(15);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}


-(void)copyBtnClicked
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = swiftViewController.local_private_key;
    [self.view makeToast:GCLocalizedString(@"Copy success!") duration:2 position:BOTTOM];
}

-(void)lookADBtnClicked
{
    [self addADBgView];
    self.progressView.progress = 0;
    _loadingTime = 5;
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
    if (self.rewardedAd.isReady) {
        [self.rewardedAd presentFromRootViewController:self delegate:self];
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
        [self.view makeToast:GCLocalizedString(@"Ad is not ready.") duration:2 position:BOTTOM];
        if (self.codeTimer != nil) {
          [self.codeTimer invalidate];
          self.codeTimer = nil;
        }
    }
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listarray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIBaseModel* model = self.listarray[indexPath.row];
    if ([model.type  isEqual: @(UITipsType)]) {
        getTenonCell* cell = [tableView dequeueReusableCellWithIdentifier:@"getTenonCell"];
        cell.lbTitle.text = model.title;
//        cell.lbTitle.font = Font_H(16);
        cell.lbSubTitle.text = model.subTitle;
//        cell.lbSubTitle.font = Font_H(16);
        [cell.btnEnter setTitle:model.mark forState:UIControlStateNormal];
        cell.clickBlock = ^{
            if ([model.index intValue] == 2) {
                // 包月
                self.selectIdx = 1;
                self.selectAppleGoodsID = @"801e6fc815664187b410b0a1672e6bbb"; // 测试消耗品 bf68d4c5c70048d68bfa5f1ac1f28d74
                self.applepayProducID = [NSString stringWithFormat:@"%@%@",[TenonP2pLib sharedInstance].account_id,[self getNowTimeTimestamp]];
                [self orderToApplePay];
            }else if ([model.index intValue] == 3) {
                // 包季
                self.selectIdx = 2;
                self.selectAppleGoodsID = @"ba84d7514e76446eb8e424c475a4d9b8";
                self.applepayProducID = [NSString stringWithFormat:@"%@%@",[TenonP2pLib sharedInstance].account_id,[self getNowTimeTimestamp]];
                [self orderToApplePay];
            }else if ([model.index intValue] == 4) {
                // 包年
                self.selectIdx = 3;
                self.selectAppleGoodsID = @"f2893f61745d48638e14281b63d55f2e";
                self.applepayProducID = [NSString stringWithFormat:@"%@%@",[TenonP2pLib sharedInstance].account_id,[self getNowTimeTimestamp]];
                [self orderToApplePay];
            }else if ([model.index intValue] == 5) {
                // 观看
                [self lookADBtnClicked];
            }else if ([model.index intValue] == 6) {
                // 分享
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
            }else if ([model.index intValue] == 7) {
                // 挖矿
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/tenondvpn/tenonvpn-join"]];
            }
        };
        return cell;
    }else if ([model.type isEqual:@(UITitleType)]){
        TenonHeadCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TenonHeadCell"];
        cell.lbTitle.text = model.title;
        cell.lbSubTitle.text = model.subTitle;
        cell.lbTitle.font = Font_H(16);
        cell.lbSubTitle.font = Font_H(16);
        cell.lbContent.text = model.dataArray[0];
        cell.clickBlock = ^{
            [self copyBtnClicked];
        };
        [cell.btnEnter setTitle:model.mark forState:UIControlStateNormal];
        return cell;
    }else if ([model.type isEqual:@(UISpaceType)]){
        UISpaceCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UISpaceCell"];
        cell.constraintCellHeight.constant = model.cellHeight.floatValue;
        cell.backView.backgroundColor = UIColor.clearColor;
        return cell;
    }else if ([model.type isEqual:@(UIOrderListType)]){
        UITipsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITipsCell"];
        cell.lbTips.font = Font_H(20);
        [cell setModel:model];
        return cell;
    }else if ([model.type isEqual:@(UILineType)]){
        OrderListHeaderCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OrderListHeaderCell"];
//        [cell setModel:model];
        cell.lb1.text = model.dataArray[0];
        cell.lb2.text = model.dataArray[1];
        cell.lb3.text = model.dataArray[2];
        cell.lb4.text = model.dataArray[3];
        cell.lb1.font = Font_H(16);
        cell.lb2.font = Font_H(16);
        cell.lb3.font = Font_H(16);
        cell.lb4.font = Font_H(16);
        return cell;
    }else{
        HistoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryListTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellOneLab.text = model.title;
        cell.cellTwoLab.text = model.subTitle;
        cell.cellThreeLab.text = model.dataArray[0];
        cell.cellForLab.text = model.dataArray[1];
        cell.cellOneLab.font = Font_H(14);
        cell.cellTwoLab.font = Font_H(14);
        cell.cellThreeLab.font = Font_H(14);
        cell.cellForLab.font = Font_H(14);
        cell.backView.backgroundColor = model.backColor;
        return cell;
    }
}


// 内购相关

-(NSString *)getNowTimeTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [DKProgressHUD dismissHud];
    if (self.timer) {
        [self.timer invalidate];
    }

}

- (void)PaySuccess:(SKPaymentTransaction *)transaction{
    dispatch_async(dispatch_get_main_queue(), ^{
//        [[KeychainManager shareInstence] setKeyChainReceipt:@""];
//        [[KeychainManager shareInstence] setKeyChainType:0];
//        [[KeychainManager shareInstence] setKeyChainTranscate:@""];
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
        [DKProgressHUD dismissHud];
        [DKProgressHUD showSuccessWithStatus:GCLocalizedString(@"Buy Success")];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)orderToApplePay{
    NSLog(@"DDDDDDDDDDDDDDDDD: %lu", (unsigned long)[[KeychainManager shareInstence] getKeyChainReceipt].length);
    if ([[KeychainManager shareInstence] getKeyChainReceipt].length != 0) {
        [self.view makeToast:GCLocalizedString(@"paying") duration:2 position:BOTTOM];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //是否允许内购
        if ([SKPaymentQueue canMakePayments]) {
            [DKProgressHUD showHUDHoldOn:self];
            NSArray *product = [[NSArray alloc] initWithObjects:self.selectAppleGoodsID,nil];
            NSSet *nsset = [NSSet setWithArray:product];
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
            request.delegate = self;
            [request start];
        }else{
            [DKProgressHUD showInfoWithStatus:GCLocalizedString(@"your phone cannot IAP")];
            [DKProgressHUD dismissHud];
        }
    });
}
#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response NS_AVAILABLE_IOS(3_0)
{
    NSArray *product = response.products;
    if([product count] != 0){
        SKProduct *requestProduct = nil;
        NSLog(@"product = %@",product);
        for (SKProduct *pro in product) {
            if([pro.productIdentifier isEqualToString:self.selectAppleGoodsID]){
                requestProduct = pro;
            }
        }
        
        //发送购买请求
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:requestProduct];
        payment.applicationUsername = self.applepayProducID;
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [DKProgressHUD dismissHud];
            [DKProgressHUD showInfoWithStatus:GCLocalizedString(@"no product")];
        });
    }
}
#pragma mark - SKRequestDelegate
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    [DKProgressHUD dismissHud];
}

//请求结束
- (void)requestDidFinish:(SKRequest *)request
{
//    [DKProgressHUD dismissHud];
}

#pragma mark - SKPaymentTransactionObserver
//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([transactions count] != 1) {
            NSLog(@"transactions count = %ld",[transactions count]);
            [self.navigationController popViewControllerAnimated:YES];
            [DKProgressHUD dismissHud];
        }else{
            for(SKPaymentTransaction *tran in transactions){
                switch (tran.transactionState) {
                    case SKPaymentTransactionStatePurchased:
                    {
                        NSLog(@"交易完成");
                        [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                        [DKProgressHUD dismissHud];
                        [self completeTransaction:tran];
                    }
                        break;
                    case SKPaymentTransactionStateFailed:
                    {
                        NSLog(@"交易失败");
                        [DKProgressHUD dismissHud];
                        [DKProgressHUD showInfoWithStatus:GCLocalizedString(@"order failed")];
                        [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                    }
                        break;
                    case SKPaymentTransactionStatePurchasing:
                    {
                        // 此处不能调用 finishTransaction 否则会闪退
                        NSLog(@"商品添加进列表");
                    }
                        break;
                        //            case SKPaymentTransactionStateRestored:
                        //            {
                        //                NSLog(@"已经购买过商品");
                        //                [DKProgressHUD dismissHud];
                        //                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                        //            }
                        //                break;
                    default:
                    {
                        NSLog(@"交易失败 default");
                        [DKProgressHUD dismissHud];
                        [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                    }
                        break;
                }
            }
        }
    });
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [DKProgressHUD showHUDHoldOn:self];
    });
    
    NSURL *rurl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *rdata = [NSData dataWithContentsOfURL:rurl];
    
    NSURL *url = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
    urlRequest.HTTPMethod = @"POST";
    NSString *encodeStr = [rdata base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    _receipt = encodeStr;
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\":\"%@\"}", _receipt];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    urlRequest.HTTPBody = payloadData;
    NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    if (result == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [DKProgressHUD dismissHud];
            [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
        });
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if (dic != nil) {
            NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
            [formatter setDateFormat:@"MM-dd hh:mm"];
            NSString *dateex =  [formatter stringFromDate:[NSDate date]];
            NSString *date = [[NSString alloc] initWithFormat:@"%@", dateex];
            NSString *type = @"1";
            NSString *amount = @"";
            if (self.selectIdx == 1) {
                amount = @"1990";
            }else if(self.selectIdx == 2){
                amount = @"5950";
            }else if (self.selectIdx == 3){
                amount = @"23800";
            }else{
                amount = @"1990";
            }
            UInt64 balance = [[TenonP2pLib sharedInstance] GetBalance];
            NSString *gid = [self sha256HashForText:(self.receipt)];
            NSString* record = [NSString stringWithFormat:@"%@,%@,%@,%llu,%@,0,0;",date,type,amount,balance,gid];
            NSLog(@"record = %@",record);
            [[KeychainManager shareInstence] setKeyChainReceipt:self.receipt];
            [[KeychainManager shareInstence] setKeyChainType:self.selectIdx];
            [[KeychainManager shareInstence] setKeyChainTranscate:record];
            
            [JTNetwork requestPostWithParam:@{@"account":[TenonP2pLib sharedInstance].account_id, @"receipt":self.receipt, @"type":@(self.selectIdx)} url:@"/appleIAPAuth" callback:^(JTBaseReqModel *model) {
                if (model.status == 1) {
                    NSLog(@"支付成功");
                    [self PaySuccess:transaction];
                }else if(model.status == -2){
                    // 网络请求报错
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [DKProgressHUD dismissHud];
                        [DKProgressHUD showErrorWithStatus:GCLocalizedString(@"order failed")];
                        NSLog(@"支付失败");
                        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                    });
                }else{
                    // 服务端验证失败
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [[KeychainManager shareInstence] setKeyChainReceipt:@""];
//                        [[KeychainManager shareInstence] setKeyChainTranscate:@""];
//                        [[KeychainManager shareInstence] setKeyChainType:0];
                        [DKProgressHUD dismissHud];
                        [DKProgressHUD showErrorWithStatus:GCLocalizedString(@"order failed")];
                        NSLog(@"支付失败");
                        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                    });
                }
            }];
        }else{
            NSLog(@"支付失败2");
            [DKProgressHUD dismissHud];
            [self.navigationController popViewControllerAnimated:YES];
            [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
        }
    }
}

-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
   UILabel *label=(UILabel*)recognizer.view;
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"https://www.tenonvpn.net/views/termsOfUse.html"];
    if (@available(iOS 10.0, *)) {
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            NSLog(@"Open %@: %d",@"https://www.tenonvpn.net/views/termsOfUse.html",success);
        }];
    } else {
        // Fallback on earlier versions
        BOOL success = [application openURL:URL];
        NSLog(@"Open %@: %d",@"https://www.tenonvpn.net/views/termsOfUse.html",success);
    }
}

-(void) labelTouchUpInside2:(UITapGestureRecognizer *)recognizer{
   UILabel *label=(UILabel*)recognizer.view;
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"https://www.tenonvpn.net/views/privacyPolicy.html"];
    if (@available(iOS 10.0, *)) {
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            NSLog(@"Open %@: %d",@"https://www.tenonvpn.net/views/privacyPolicy.html",success);
        }];
    } else {
        // Fallback on earlier versions
        BOOL success = [application openURL:URL];
        NSLog(@"Open %@: %d",@"https://www.tenonvpn.net/views/privacyPolicy.html",success);
    }
}

@end
