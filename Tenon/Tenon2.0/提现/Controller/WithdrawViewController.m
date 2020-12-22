//
//  WithdrawViewController.m
//  Tenonvpn
//
//  Created by Raobin on 2020/8/30.
//  Copyright © 2020 Raobin. All rights reserved.
//

#import "WithdrawViewController.h"
#import "HistoryListTableViewCell.h"

@interface WithdrawViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,copy) NSMutableArray *listarray;
@property (nonatomic, strong) UITextField *numTextField;
@end

@implementation WithdrawViewController

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
    aboutLab.text = GCLocalizedString(@"Seel out");
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
    oneLab.text = GCLocalizedString(@"Destination Tenon Address");
    oneLab.textColor = kRBColor(18, 181, 170);
    oneLab.font = Font_B(14);
    [textBgView addSubview:oneLab];
    [oneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBgView).offset(16);
        make.top.equalTo(textBgView).offset(16);
        make.height.mas_equalTo(20);
    }];
    
    UIView *oneView = [[UIView alloc] init];
    oneView.backgroundColor = [UIColor blackColor];
    oneView.layer.cornerRadius = 4.0f;
    oneView.layer.masksToBounds = YES;
    [textBgView addSubview:oneView];
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBgView).offset(16);
        make.right.equalTo(textBgView).offset(-16);
        make.height.mas_equalTo(36);
        make.top.equalTo(textBgView).offset(40);
    }];
    
    UITextField *oneTextField = [[UITextField alloc] init];
    oneTextField.textColor = [UIColor whiteColor];
    oneTextField.placeholder = GCLocalizedString(@"Type or paste address");
    oneTextField.font = kFont(12);
    NSDictionary *dic = @{NSForegroundColorAttributeName:kRBColor(76, 85, 85), NSFontAttributeName:[UIFont systemFontOfSize:12]};
    oneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:GCLocalizedString(@"Type or paste address") attributes:dic];
    [oneView addSubview:oneTextField];
    [oneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneView).offset(12);
        make.centerY.equalTo(oneView);
        make.height.mas_equalTo(36);
        make.right.equalTo(oneView).offset(-20);
    }];
    
    UILabel *twoLab = [[UILabel alloc] init];
    twoLab.text = GCLocalizedString(@"Count");
    twoLab.textColor = kRBColor(18, 181, 170);
    twoLab.font = Font_B(14);
    [textBgView addSubview:twoLab];
    [twoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBgView).offset(16);
        make.top.equalTo(oneView.mas_bottom).offset(16);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *twoLab1 = [[UILabel alloc] init];
    twoLab1.text = [NSString stringWithFormat:@"%@ 10000 Tenon",GCLocalizedString(@"Allow to seel")];
    twoLab1.textColor = kRBColor(154, 162, 161);
    twoLab1.font = kFont(12);
    [textBgView addSubview:twoLab1];
    [twoLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBgView).offset(56);
        make.top.equalTo(oneView.mas_bottom).offset(16);
        make.height.mas_equalTo(20);
    }];
    
    UIView *twoView = [[UIView alloc] init];
    twoView.backgroundColor = [UIColor blackColor];
    twoView.layer.cornerRadius = 4.0f;
    twoView.layer.masksToBounds = YES;
    [textBgView addSubview:twoView];
    [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBgView).offset(16);
        make.right.equalTo(textBgView).offset(-80);
        make.height.mas_equalTo(36);
        make.top.equalTo(oneView.mas_bottom).offset(40);
    }];
    
    _numTextField = [[UITextField alloc] init];
    _numTextField.textColor = [UIColor whiteColor];
    _numTextField.placeholder = GCLocalizedString(@"Minimum Count 100");
    _numTextField.font = kFont(12);
    _numTextField.keyboardType = UIKeyboardTypeNumberPad;
    _numTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:GCLocalizedString(@"Minimum Count 100") attributes:dic];
    [twoView addSubview:_numTextField];
    [_numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(twoView).offset(12);
        make.centerY.equalTo(twoView);
        make.height.mas_equalTo(36);
        make.right.equalTo(twoView).offset(-20);
    }];
    
    UIButton *allBtn = [[UIButton alloc] init];
    [allBtn addTarget:self action:@selector(allBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [allBtn setTitle:GCLocalizedString(@"Seel out all") forState:0];
    [allBtn setTitleColor:kRBColor(18, 181, 170) forState:0];
    allBtn.titleLabel.font = Font_B(12);
    [textBgView addSubview:allBtn];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(36);
        make.centerY.equalTo(twoView);
        make.right.equalTo(textBgView.mas_right).offset(-16);
    }];
    
    UIButton *twoBtn = [[UIButton alloc] init];
    twoBtn.layer.cornerRadius = 18.0f;
    twoBtn.titleLabel.font = Font_B(14);
    twoBtn.backgroundColor = kRBColor(18, 181, 170);
    [twoBtn setTitleColor:kRBColor(0, 41, 51) forState:0];
    [twoBtn setTitle:GCLocalizedString(@"Seel out") forState:0];
    [twoBtn addTarget:self action:@selector(getBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [textBgView addSubview:twoBtn];
    [twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(textBgView.mas_bottom).offset(-20);
        make.height.mas_equalTo(44);
        make.left.equalTo(textBgView).offset(16);
        make.right.equalTo(textBgView.mas_right).offset(-16);
    }];
    
    UILabel *noticeLab = [[UILabel alloc] init];
    noticeLab.text = GCLocalizedString(@"Tip: At least 100 Tenon can be mentioned. For security, please keep your private key and don't tell anyone to ensure your account is safe.");
    noticeLab.textColor = kRBColor(18, 181, 170);
    noticeLab.font = kFont(12);
    noticeLab.numberOfLines = 0;
    [self.view addSubview:noticeLab];
    [noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(textBgView.mas_bottom).offset(8);
    }];
    
    UILabel *lsitLab = [[UILabel alloc] init];
    lsitLab.text = GCLocalizedString(@"History");
    lsitLab.textColor = kRBColor(18, 181, 170);
    lsitLab.font = Font_B(14);
    [self.view addSubview:lsitLab];
    [lsitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.height.mas_equalTo(20);
        make.top.equalTo(noticeLab.mas_bottom).offset(20);
    }];
    
    _listarray = @[@"",@"",@"",@"",@"",@"",@"",@""].mutableCopy;
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

-(void)allBtnClicked
{
    [self.view endEditing:YES];
    self.numTextField.text = @"10000";
}

-(void)getBtnClicked
{
    [self.view makeToast:GCLocalizedString(@"Seel out") duration:2 position:BOTTOM];
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
    cell.cellThreeLab.text = GCLocalizedString(@"Expired");
    return cell;
}

@end
