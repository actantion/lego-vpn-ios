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

extern ViewController *swiftViewController;
@interface ADViewController ()
@property (nonatomic, strong) MSWeakTimer *codeTimer;
@property (nonatomic, assign) NSInteger secondNum;
@property (nonatomic, strong) UIButton *getCodeBtn;
@end

@implementation ADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
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
  else
  {
      [self jumpBtnClicked];
  }
}

-(void)jumpBtnClicked
{
    if (self.codeTimer != nil) {
      [self.codeTimer invalidate];
      self.codeTimer = nil;
    }
    
    if([self.FROM isEqualToString:@"MAIN"])
    {
        MainViewController *nextVC = [[MainViewController alloc] init];
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
