//
//  RechargeVC.m
//  PlayGame
//
//  Created by FriendWu on 2020/11/24.
//

#import "RechargeVC.h"
#import <StoreKit/StoreKit.h>
#import "TenonVPN-Swift.h"
@interface RechargeVC ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property (nonatomic, assign)NSInteger selectIdx;
@property (nonatomic, strong)NSString* selectAppleGoodsID;
@property (nonatomic, strong)NSString* applepayProducID;
@property(nonatomic, strong) NSString* receipt;
@end

@implementation RechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTitle = @"Tenon充值";
    self.selectIdx = -1;
    self.selectAppleGoodsID = @"";
    [self addNavigationView];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    self.tableView.backgroundColor = UIColor.blackColor;
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIImageView *navImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.vwNavigation.height, kWIDTH, 273)];
    navImg.image = [UIImage imageNamed:@"black_bg5"];
    [self.view addSubview:navImg];
    [self.view sendSubviewToBack:navImg];
    [UIView animateWithDuration:1 animations:^{
        self.tableView.backgroundColor = UIColor.clearColor;
    }];
}
- (void)loadUI{
    [self.dataArray removeAllObjects];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UILabelContentType),
                                                         BM_title:@"Tenon",
                                                         BM_cellHeight:@(50),
                                                         BM_subTitle:[NSString stringWithFormat:@"%lld",[TenonP2pLib sharedInstance].now_balance],
                                                         BM_mark:@"余额："}]];
    
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                         BM_backColor:[UIColor clearColor],
                                                         BM_cellHeight:@(10)}]];
    
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_title:@"logo",
                                                         BM_subTitle:@"Tenon月会员",
                                                         BM_cellHeight:@(50),
                                                         BM_SubAlignment:@(2),
                                                         BM_mark:self.selectIdx == 1?@"1":@"0",
                                                         BM_type:@(UIImageLabelSelectType)}]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UILineType),
                                                         BM_leading:@(20),
                                                         BM_trading:@(20)}]];
    
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_title:@"logo",
                                                         BM_subTitle:@"Tenon季度会员",
                                                         BM_cellHeight:@(50),
                                                         BM_SubAlignment:@(2),
                                                         BM_mark:self.selectIdx == 2?@"1":@"0",
                                                         BM_type:@(UIImageLabelSelectType)}]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UILineType),
                                                         BM_leading:@(20),
                                                         BM_trading:@(20)}]];
    
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_title:@"logo",
                                                         BM_subTitle:@"Tenon年会员",
                                                         BM_cellHeight:@(50),
                                                         BM_SubAlignment:@(2),
                                                         BM_mark:self.selectIdx == 3?@"1":@"0",
                                                         BM_type:@(UIImageLabelSelectType)}]];
    
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                         BM_backColor:[UIColor clearColor],
                                                         BM_cellHeight:@(64)}]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_title:@"确认充值",
                                                         BM_leading:@(20),
                                                         BM_trading:@(20),
                                                         BM_backColor:MyGreenColor,
                                                         BM_titleColor:UIColor.whiteColor,
                                                         BM_cellHeight:@(50),
                                                         BM_type:@(UIConfirnBtnType)}]];
    
    [self.tableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSString *)getNowTimeTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UIBaseModel* model = self.dataArray[indexPath.row];
    if([model.type isEqual:@(UIConfirnBtnType)]){
        return [tableView reloadCell:@"UIConfirnBtnCell" withModel:model withBlock:^(id  _Nullable value) {
            NSLog(@"内购");
            if (self.selectAppleGoodsID.length == 0) {
                [DKProgressHUD showInfoWithStatus:@"please chose your product"];
                return;
            }
            self.applepayProducID = [NSString stringWithFormat:@"%@%@",[TenonP2pLib sharedInstance].account_id,[self getNowTimeTimestamp]];
            [self orderToApplePay];
        }];
    }else if ([model.type  isEqual: @(UIImageLabelSelectType)]) {
        return [tableView reloadCell:@"UIImageLabelSelectCell" withModel:model withBlock:nil];
    }else if([model.type  isEqual: @(UILabelContentType)]){
        return [tableView reloadCell:@"UILabelContentCell" withModel:self.dataArray[indexPath.row] withBlock:nil];
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 2) {
        self.selectIdx = 1;
        self.selectAppleGoodsID = @"91858c25f442453e95de063494981b1c";
    }else if (indexPath.row == 4) {
        self.selectIdx = 2;
        self.selectAppleGoodsID = @"f55ce3d2138349adb754eb6c1fff53b1";
    }else if (indexPath.row == 6) {
        self.selectIdx = 3;
        self.selectAppleGoodsID = @"f2893f61745d48638e14281b63d55f2e";
    }
    [self loadUI];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)PaySuccess{
    dispatch_async(dispatch_get_main_queue(), ^{
        [DKProgressHUD showInfoWithStatus:@"pay success"];
    });
    [self.navigationController popToRootViewControllerAnimated:YES];
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
                [DKProgressHUD showLoading];
                
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
        [DKProgressHUD dismiss];
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
    if (dic != nil) {
        [JTNetwork requestPostWithParam:@{@"transactionID":transaction.transactionIdentifier,
                                         @"receipt":self.receipt}
                                   url:@"/appleIAPAuth"
                              callback:^(JTBaseReqModel *model) {
            [DKProgressHUD dismiss];
            if (model.status == 1) {
                [self PaySuccess];
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [DKProgressHUD showInfoWithStatus:@"rechage failed"];
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
@end
