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
@property (nonatomic, assign)NSInteger selectIdx;
@property (nonatomic, strong)NSString* selectAppleGoodsID;
@property (nonatomic, strong)NSString* applepayProducID;
@property(nonatomic, strong) NSString* receipt;

@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray *listarray;

@property(nonatomic, strong) GADRewardedAd *rewardedAd;
@property(nonatomic, strong) GADAdLoader *adLoader;
@property (nonatomic, assign) BOOL bIsShowAd;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIView *loadingAdView;
@property (nonatomic, strong) RBProgressView *progressView;
@property (nonatomic, strong) MSWeakTimer *codeTimer;
@property (nonatomic, assign) NSInteger loadingTime;
@property (nonatomic, assign) MainViewController* mainViewController;
@property (nonatomic, strong) NSTimer * timer;
@end

@implementation RechargeViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self createAndLoadRewardedAd];
    self.view.backgroundColor = [UIColor blackColor];
    [self addNav];
    [self initUI];
    self.selectIdx = -1;
    self.selectAppleGoodsID = @"";
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
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
                                                     BM_dataArray:@[swiftViewController.local_account_id],
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
    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                     BM_cellHeight:@10
    }]];
    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITipsType),
                                                     BM_Index:@"7",
                                                     BM_title:GCLocalizedString(@"Method seven"),
                                                     BM_subTitle:GCLocalizedString(@"mining"),
                                                     BM_mark:GCLocalizedString(@"Join")
    }]];
    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                     BM_cellHeight:@15}]];
    NSString* transcation = TenonP2pLib.sharedInstance.GetTransactions;
    NSLog(@"get transactions: %@", transcation);
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
        NSLog(transcation);
        [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UILineType),
                                                         BM_dataArray:@[GCLocalizedString(@"Transaction time"),GCLocalizedString(@"Type"),GCLocalizedString(@"volume of trade"),GCLocalizedString(@"Balance")]}]];
        NSInteger idx = 0;
        for (NSString* value in array) {
            NSMutableArray* dataArray = [value componentsSeparatedByString:@","];
            NSString* type = dataArray[1];
            NSString* typeValue = @"";
            if ([type intValue] == 1) {
                typeValue = GCLocalizedString(@"pay_for_vpn");
            }else if ([type intValue] == 2){
                typeValue = GCLocalizedString(@"transfer_out");
            }else if ([type intValue] == 3){
                typeValue = GCLocalizedString(@"Charge flow");
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
    
    UILabel *noticeLab = [[UILabel alloc] initWithFrame:CGRectMake(20, aboutLab.bottom+15, kWIDTH-40, 75)];
    noticeLab.text = GCLocalizedString(@"private_key_notices");
    noticeLab.textColor = kRBColor(18, 181, 170);
    noticeLab.lineBreakMode = NSLineBreakByWordWrapping;
    noticeLab.numberOfLines = 0;
    noticeLab.font = Font_B(16);
    [self.view addSubview:noticeLab];
    [self loadUI];
    
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
        make.top.equalTo(noticeLab.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}


-(void)copyBtnClicked
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = swiftViewController.local_account_id;
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
        cell.lbTitle.font = Font_H(16);
        cell.lbSubTitle.text = model.subTitle;
        cell.lbSubTitle.font = Font_H(16);
        [cell.btnEnter setTitle:model.mark forState:UIControlStateNormal];
        cell.clickBlock = ^{
            if ([model.index intValue] == 2) {
                // 包月
                self.selectIdx = 1;
                self.selectAppleGoodsID = @"5a7bd18ceafc43cfbe35a467044a4f74"; // 测试消耗品 bf68d4c5c70048d68bfa5f1ac1f28d74
                self.applepayProducID = [NSString stringWithFormat:@"%@%@",[TenonP2pLib sharedInstance].account_id,[self getNowTimeTimestamp]];
                [self orderToApplePay];
            }else if ([model.index intValue] == 3) {
                // 包季
                self.selectIdx = 2;
                self.selectAppleGoodsID = @"83f0b08931374fb4a80aa1ad4fc1cae5";
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
                NSURL* url2 = [NSURL URLWithString:@"https://www.tenonvpn.net"];
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

- (void)PaySuccess{
    dispatch_async(dispatch_get_main_queue(), ^{
        [DKProgressHUD dismissHud];
        [DKProgressHUD showSuccessWithStatus:GCLocalizedString(@"Buy Success")];
    });
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)orderToApplePay{
    //是否允许内购
    if ([SKPaymentQueue canMakePayments]) {
        [DKProgressHUD showHUDHoldOn:self];
        NSArray *product = [[NSArray alloc] initWithObjects:self.selectAppleGoodsID,nil];
        NSSet *nsset = [NSSet setWithArray:product];
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
        request.delegate = self;
        [request start];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [DKProgressHUD showInfoWithStatus:GCLocalizedString(@"your phone cannot IAP")];
        });
        [DKProgressHUD dismissHud];
    }
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
            [DKProgressHUD showInfoWithStatus:GCLocalizedString(@"no product")];
        });
        [DKProgressHUD dismissHud];
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
    [DKProgressHUD dismissHud];
}

#pragma mark - SKPaymentTransactionObserver
//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for(SKPaymentTransaction *tran in transactions){
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
            {
                NSLog(@"交易完成");
                [DKProgressHUD dismissHud];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [self completeTransaction:tran];
            }
                break;
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"交易失败");
                [DKProgressHUD dismissHud];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [DKProgressHUD showInfoWithStatus:GCLocalizedString(@"order failed")];
                });
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            }
                break;
            case SKPaymentTransactionStatePurchasing:
            {
                NSLog(@"商品添加进列表");
                [DKProgressHUD dismissHud];
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

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [DKProgressHUD showHUDHoldOn:self];
    });
    
    NSURL *rurl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *rdata = [NSData dataWithContentsOfURL:rurl];
    
    NSURL *url = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
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
        });
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        if (dic != nil) {
            
            [JTNetwork requestPostWithParam:@{@"account":[TenonP2pLib sharedInstance].account_id,
                                              @"receipt":self.receipt,
                                              @"type":@(self.selectIdx)}
                                        url:@"/appleIAPAuth"
                                   callback:^(JTBaseReqModel *model) {
                if (model.status == 1) {
                    NSLog(@"支付成功");
                    [self PaySuccess];
                    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [DKProgressHUD dismissHud];
                        [DKProgressHUD showErrorWithStatus:GCLocalizedString(@"order failed")];
                    });
                    NSLog(@"支付失败");
                    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                }
            }];
        }
        else{
            [DKProgressHUD dismissHud];
            [self.navigationController popViewControllerAnimated:YES];
            [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
        }
    }
}
@end
