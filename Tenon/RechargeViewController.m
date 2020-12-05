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

@interface RechargeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,copy) NSMutableArray *listarray;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self addNav];
    [self initUI];
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
    aboutLab.text = GCLocalizedString(@"充流量");
    aboutLab.textColor = kRBColor(154, 162, 161);
    aboutLab.font = Font_B(36);
    [self.view addSubview:aboutLab];
    
    UIView *textBgView = [[UIView alloc] init];
    textBgView.backgroundColor = kRBColor(21, 25, 25);
    textBgView.layer.cornerRadius = 4.0f;
    [self.view addSubview:textBgView];
    [textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kWIDTH-40);
        make.top.equalTo(aboutLab.mas_bottom).offset(8);
        make.height.mas_equalTo(236);
    }];
    
    UILabel *oneLab = [[UILabel alloc] init];
    oneLab.text = GCLocalizedString(@"方式一");
    oneLab.textColor = kRBColor(18, 181, 170);
    oneLab.font = Font_B(14);
    [textBgView addSubview:oneLab];
    [oneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBgView).offset(16);
        make.top.equalTo(textBgView).offset(16);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *oneContLab = [[UILabel alloc] init];
    oneContLab.text = GCLocalizedString(@"直接将Tenon转入您的匿名账户");
    oneContLab.textColor = kRBColor(154, 162, 161);
    oneContLab.font = kFont(14);
    [textBgView addSubview:oneContLab];
    [oneContLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneLab.mas_right).offset(12);
        make.top.equalTo(textBgView).offset(16);
        make.height.mas_equalTo(20);
    }];
    
    UIImageView *codeImg = [[UIImageView alloc] init];
    codeImg.image = [UIImage imageNamed:@"icon_code"];
    [textBgView addSubview:codeImg];
    [codeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(120);
        make.center.equalTo(textBgView);
    }];
    
    UILabel *codeLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 190, kWIDTH-88-16, 20)];
    codeLab.text = @"s823rjdf9s8hc23289rhvnweua8932s823rjdf9s…";
    codeLab.textColor = kRBColor(76, 85, 85);
    codeLab.font = kFont(12);
    [textBgView addSubview:codeLab];
    
    UIButton *copyBtn = [[UIButton alloc] init];
    [copyBtn addTarget:self action:@selector(copyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [copyBtn setTitle:GCLocalizedString(@"复制") forState:0];
    [copyBtn setTitleColor:kRBColor(18, 181, 170) forState:0];
    copyBtn.titleLabel.font = Font_B(14);
    [textBgView addSubview:copyBtn];
    CGFloat leftF = 28;
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"AppLanguagesKey"] isEqualToString:@"en"]) {
        leftF = 35;
    }
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(leftF);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(codeLab);
        make.right.equalTo(textBgView.mas_right).offset(-20);
    }];
    
    UIView *twoBgView = [[UIView alloc] init];
    twoBgView.backgroundColor = kRBColor(21, 25, 25);
    twoBgView.layer.cornerRadius = 4.0f;
    [self.view addSubview:twoBgView];
    [twoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kWIDTH-40);
        make.top.equalTo(textBgView.mas_bottom).offset(10);
        make.height.mas_equalTo(64);
    }];
    
    UILabel *twoLab = [[UILabel alloc] init];
    twoLab.text = GCLocalizedString(@"方式二");
    twoLab.textColor = kRBColor(18, 181, 170);
    twoLab.font = Font_B(14);
    [twoBgView addSubview:twoLab];
    [twoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(twoBgView).offset(16);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(twoBgView);
    }];
    
    UILabel *twoContLab = [[UILabel alloc] init];
    twoContLab.text = GCLocalizedString(@"月付/季付/年付");
    twoContLab.textColor = kRBColor(154, 162, 161);
    twoContLab.font = kFont(14);
    [twoBgView addSubview:twoContLab];
    [twoContLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(twoLab.mas_right).offset(12);
        make.centerY.equalTo(twoBgView);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *twoBtn = [[UIButton alloc] init];
    twoBtn.layer.cornerRadius = 18.0f;
    twoBtn.titleLabel.font = Font_B(14);
    twoBtn.backgroundColor = kRBColor(18, 181, 170);
    [twoBtn setTitleColor:kRBColor(0, 41, 51) forState:0];
    [twoBtn setTitle:GCLocalizedString(@"快速") forState:0];
    [twoBtn addTarget:self action:@selector(joinBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [twoBgView addSubview:twoBtn];
    [twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(36);
        make.centerY.equalTo(twoBgView);
        make.right.equalTo(twoBgView.mas_right).offset(-12);
    }];
    
    UIView *threeBgView = [[UIView alloc] init];
    threeBgView.backgroundColor = kRBColor(21, 25, 25);
    threeBgView.layer.cornerRadius = 4.0f;
    [self.view addSubview:threeBgView];
    [threeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kWIDTH-40);
        make.top.equalTo(twoBgView.mas_bottom).offset(10);
        make.height.mas_equalTo(64);
    }];
    
    UILabel *threeLab = [[UILabel alloc] init];
    threeLab.text = GCLocalizedString(@"方式三");
    threeLab.textColor = kRBColor(18, 181, 170);
    threeLab.font = Font_B(14);
    [threeBgView addSubview:threeLab];
    [threeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(threeBgView).offset(16);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(threeBgView);
    }];
    
    UILabel *threeContLab = [[UILabel alloc] init];
    threeContLab.text = GCLocalizedString(@"观看广告获得Tenon");
    threeContLab.textColor = kRBColor(154, 162, 161);
    threeContLab.font = kFont(14);
    [threeBgView addSubview:threeContLab];
    [threeContLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(threeLab.mas_right).offset(12);
        make.centerY.equalTo(threeBgView);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *threeBtn = [[UIButton alloc] init];
    threeBtn.layer.cornerRadius = 18.0f;
    threeBtn.titleLabel.font = Font_B(14);
    threeBtn.backgroundColor = kRBColor(18, 181, 170);
    [threeBtn setTitleColor:kRBColor(0, 41, 51) forState:0];
    [threeBtn setTitle:GCLocalizedString(@"进入") forState:0];
    [threeBtn addTarget:self action:@selector(lookADBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [threeBgView addSubview:threeBtn];
    [threeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(36);
        make.centerY.equalTo(threeBgView);
        make.right.equalTo(threeBgView.mas_right).offset(-12);
    }];
    
    UILabel *lsitLab = [[UILabel alloc] init];
    lsitLab.text = GCLocalizedString(@"历史记录");
    lsitLab.textColor = kRBColor(18, 181, 170);
    lsitLab.font = Font_B(14);
    [self.view addSubview:lsitLab];
    [lsitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.height.mas_equalTo(20);
        make.top.equalTo(threeBgView.mas_bottom).offset(20);
    }];
    
    _listarray = @[@"",@"",@"",@"",@""].mutableCopy;
    _myTableView = [[UITableView alloc] init];
    _myTableView.tableFooterView = [[UIView alloc] init];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = [UIColor clearColor];
    _myTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [_myTableView registerNib:[UINib nibWithNibName:@"HistoryListTableViewCell" bundle:nil] forCellReuseIdentifier:@"HistoryListTableViewCell"];
    _myTableView.estimatedRowHeight = 40;
    [self.view addSubview:_myTableView];
    [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.mas_equalTo(kWIDTH);
        make.top.equalTo(lsitLab.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}


-(void)copyBtnClicked
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"s823rjdf9s8hc23289rhvnweua8932s823rjdf9s…";
    [self.view makeToast:GCLocalizedString(@"复制成功") duration:2 position:BOTTOM];
}

-(void)joinBtnClicked
{
    [self.view makeToast:GCLocalizedString(@"快速") duration:2 position:BOTTOM];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryListTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellOneLab.text = @"500M";
    cell.cellTwoLab.text = @"2020.02.04";
    cell.cellThreeLab.text = GCLocalizedString(@"已过期");
    return cell;
}
@end
