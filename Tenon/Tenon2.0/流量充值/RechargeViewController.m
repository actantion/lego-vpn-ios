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
#import "UITipsCell.h"
#import "UISpaceCell.h"
#import "TenonHeadCell.h"
#import "TSShareHelper.h"
#import "UITipsCell.h"
#import <StoreKit/StoreKit.h>
extern ViewController *swiftViewController;

@interface RechargeViewController ()<UITableViewDelegate,UITableViewDataSource,SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (nonatomic, assign)NSInteger selectIdx;
@property (nonatomic, strong)NSString* selectAppleGoodsID;
@property (nonatomic, strong)NSString* applepayProducID;
@property(nonatomic, strong) NSString* receipt;

@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray *listarray;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self addNav];
    [self initUI];
    self.selectIdx = -1;
    self.selectAppleGoodsID = @"";
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
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
    [self.navigationController popViewControllerAnimated:YES];
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
    
    UILabel *noticeLab = [[UILabel alloc] initWithFrame:CGRectMake(20, aboutLab.bottom+15, kWIDTH-40, 60)];
    noticeLab.text = GCLocalizedString(@"private_key_notices");
    noticeLab.textColor = kRBColor(18, 181, 170);
    noticeLab.lineBreakMode = NSLineBreakByWordWrapping;
    noticeLab.numberOfLines = 0;
    noticeLab.font = Font_B(14);
    [self.view addSubview:noticeLab];
    _listarray = [[NSMutableArray alloc] init];
    
    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITitleType),
                                                     BM_title:GCLocalizedString(@"Method one"),
                                                     BM_subTitle:GCLocalizedString(@"Transfer Tenon directly to your anonymous account"),
                                                     BM_dataArray:@[swiftViewController.local_account_id],
                                                     BM_mark:GCLocalizedString(@"Copy")
    }]];
    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                     BM_cellHeight:@10
    }]];
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
    [_listarray addObject:[UIBaseModel initWithDic:@{BM_type:@(UIOrderListType),
                                                     BM_title:GCLocalizedString(@"OrderList"),
                                                     BM_leading:@(20),
                                                     BM_titleSize:@(14),
                                                     BM_cellHeight:@(14),
                                                     BM_backColor:[UIColor clearColor],
                                                     BM_titleColor:[UIColor colorWithHex:0x12B5AA]
    }]];
    NSLog(@"transcations =  %@",TenonP2pLib.sharedInstance.GetTransactions);
    NSString* transcation = @"01/30 11:24,1,-66,5,931bf2a24cf7b6a14c70fe63a67a4780ece97b74755fe8dda16ab3c14eb7e12f,5,0;01/30 11:23,6,8,71,8246e90a8d82a44f68054b49e4738499a202a8ac3821d61abdbbcd99e8094b3c,0,0;01/30 11:18,6,7,63,2988b07a0786631aa8fe4b66398d91aa407318eb2eab55389acb846317370c0a,0,0;01/30 11:07,6,6,56,b876ae962588398778e7128e01b7872740bae2d77d086c655ec37e014996c30b,0,0;01/30 10:54,6,8,50,4e5508a4196eeb35308a4ae45d4aa3fe717c4ab84201b8d2bd62af1d3985e7fe,0,0;01/30 10:44,6,8,42,376f25f8d594884283835bbb6d47e4b45dadbae1242d77425fb58fdb1e379617,0,0;01/30 10:16,6,6,34,99088020d8e0cdd2acb7ab07c58716be6211fa297ee0e8ba2e937fc82226d2ab,0,0;01/30 10:11,6,6,28,907c1be591ac34c08e8b45d00650e6dea859e484ada3c3b319d5603fc58fdbcc,0,0;01/30 10:05,6,6,22,9af3de986e10c996d66e6fa6301f5baeb944609a6f9799aa21a5d7a266afea16,0,0;01/29 21:44,6,9,16,7bf525b1d679b66078c46787d51506655669b304810f37b4af5802de6cae696c,0,0;01/29 21:39,6,7,7,a5621a45749fba0b99b98056ce94eb139e203cb5a5a09fc12bf3f4dc9599d66e,0,0";
    NSMutableArray* array = [transcation componentsSeparatedByString:@";"];
    NSLog(@"array = %@",array);
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
                                                         BM_dataArray:@[dataArray[1],dataArray[2]]
        }]];
        idx++;
    }
    
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
    ADViewController *mainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ADViewController"];
    mainVC.FROM = @"AD";
    [self.navigationController pushViewController:mainVC animated:YES];
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
        cell.lbSubTitle.text = model.subTitle;
        [cell.btnEnter setTitle:model.mark forState:UIControlStateNormal];
        cell.clickBlock = ^{
            if ([model.index intValue] == 2) {
                // 包月
                self.selectIdx = 1;
                self.selectAppleGoodsID = @"91858c25f442453e95de063494981b1c"; // 测试消耗品 bf68d4c5c70048d68bfa5f1ac1f28d74
                self.applepayProducID = [NSString stringWithFormat:@"%@%@",[TenonP2pLib sharedInstance].account_id,[self getNowTimeTimestamp]];
                [self orderToApplePay];
            }else if ([model.index intValue] == 3) {
                // 包季
                self.selectIdx = 2;
                self.selectAppleGoodsID = @"f55ce3d2138349adb754eb6c1fff53b1";
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
        [cell setModel:model];
        return cell;
    }
    else{
        HistoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryListTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellOneLab.text = model.title;
        cell.cellTwoLab.text = model.subTitle;
        cell.cellThreeLab.text = model.dataArray[0];
        cell.cellForLab.text = model.dataArray[1];
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
}

- (void)PaySuccess{
    dispatch_async(dispatch_get_main_queue(), ^{
        [DKProgressHUD dismiss];
        [DKProgressHUD showSuccessWithStatus:@"购买成功"];
    });
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)orderToApplePay{
    //是否允许内购
    if ([SKPaymentQueue canMakePayments]) {
        [DKProgressHUD showLoading];
        NSArray *product = [[NSArray alloc] initWithObjects:self.selectAppleGoodsID,nil];
        NSSet *nsset = [NSSet setWithArray:product];
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
        request.delegate = self;
        [request start];
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [DKProgressHUD showInfoWithStatus:@"your phone cannot IAP"];
        });
        [DKProgressHUD dismiss];
    }
}
#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response NS_AVAILABLE_IOS(3_0)
{
    NSArray *product = response.products;
    if([product count] != 0){
        SKProduct *requestProduct = nil;
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
            [DKProgressHUD showInfoWithStatus:@"no product"];
            
        });
        [DKProgressHUD dismiss];
    }
}
#pragma mark - SKRequestDelegate
//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    [DKProgressHUD dismiss];
}

//请求结束
- (void)requestDidFinish:(SKRequest *)request
{
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
                [DKProgressHUD dismiss];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [self completeTransaction:tran];
            }
                break;
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"交易失败");
                self.view.userInteractionEnabled = YES;
                [DKProgressHUD dismiss];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [DKProgressHUD showInfoWithStatus:@"failed"];
                });
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                
            }
                break;
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [DKProgressHUD showLoading];
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
            [DKProgressHUD dismiss];
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
                    [self PaySuccess];
                    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [DKProgressHUD dismiss];
                        [DKProgressHUD showErrorWithStatus:model.message];
                    });
                    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                }
            }];
        }
        else{
            [DKProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
            [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
        }
    }
}
@end
