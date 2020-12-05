//
//  SettingViewController.m
//  Tenonvpn
//
//  Created by Raobin on 2020/8/30.
//  Copyright © 2020 Raobin. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "MainViewController.h"
#import "AppDelegate.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic, strong) UILabel *languageLabel;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *urlArray;
@property (nonatomic, strong) UIImageView *downImg;
@end

@implementation SettingViewController

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
    
    UILabel *aboutLab = [[UILabel alloc] initWithFrame:CGRectMake(20, topH+48, 140, 50)];
    aboutLab.text = GCLocalizedString(@"设置");
    aboutLab.textColor = kRBColor(154, 162, 161);
    aboutLab.font = Font_B(36);
    [self.view addSubview:aboutLab];
    
    UILabel *textLab = [[UILabel alloc] init];
    textLab.font = [UIFont systemFontOfSize:14];
    textLab.numberOfLines = 0;
    textLab.lineBreakMode = 1;
    textLab.textColor = kRBColor(154, 162, 161);
    [self.view addSubview:textLab];
    [textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(24);
        make.top.equalTo(aboutLab.mas_bottom).offset(20);
        make.width.mas_equalTo(kWIDTH-72);
    }];
    textLab.text = [NSString stringWithFormat:@"%@\n%@\nhttps://www.tenonvpn.net/telegramg…",GCLocalizedString(@"加入节点"),GCLocalizedString(@"第三方节点接入，一键式启动，并接入去中心化Tenon VPN网络，提供服务和路由")];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:textLab.text];
    NSRange range1 = [[str string] rangeOfString:GCLocalizedString(@"加入节点")];
    NSRange range2 = [[str string] rangeOfString:@"https://www.tenonvpn.net/telegramg…"];
    [str addAttribute:NSForegroundColorAttributeName value:kRBColor(18, 181, 170) range:range1];
    [str addAttribute:NSForegroundColorAttributeName value:kRBColor(18, 181, 170) range:range2];
    [str addAttribute:NSFontAttributeName value:Font_B(14) range:range1];
    [str addAttribute:NSFontAttributeName value:Font_B(14) range:range2];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4.0; // 设置行间距
    paragraphStyle.alignment = NSTextAlignmentJustified; //设置两端对齐显示
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    textLab.attributedText = str;
    
    UIView *oneView = [[UIView alloc] init];
    oneView.backgroundColor = kRBColor(21, 25, 25);
    oneView.layer.cornerRadius = 24.0f;
    oneView.layer.masksToBounds = YES;
    [self.view addSubview:oneView];
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.width.mas_equalTo(kWIDTH-40);
        make.height.mas_equalTo(48);
        make.top.equalTo(textLab.mas_bottom).offset(20);
    }];
    
    UILabel *lsitLab = [[UILabel alloc] init];
    lsitLab.text = GCLocalizedString(@"选择语言");
    lsitLab.textColor = kRBColor(18, 181, 170);
    lsitLab.font = Font_B(14);
    [oneView addSubview:lsitLab];
    [lsitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneView).offset(24);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(oneView);
    }];
    
    _downImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_icon"]];
    [oneView addSubview:_downImg];
    [_downImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(24);
        make.right.equalTo(oneView).offset(-16);
        make.centerY.equalTo(oneView);
    }];
    
    _languageLabel = [[UILabel alloc] init];
    _languageLabel.text = GCLocalizedString(@"中文");
    _languageLabel.textColor = kRBColor(154, 162, 161);
    _languageLabel.font = kFont(14);
    _languageLabel.textAlignment = NSTextAlignmentRight;
    [oneView addSubview:_languageLabel];
    [_languageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(oneView).offset(-52);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(oneView);
    }];
    
    UIButton *selectBtn = [[UIButton alloc] init];
    [selectBtn addTarget:self action:@selector(selectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [oneView addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(oneView);
        make.centerY.equalTo(oneView);
        make.height.mas_equalTo(48);
        make.width.mas_equalTo(100);
    }];
    
    _titleArray = @[GCLocalizedString(@"TG群"),@"Twitter",@"Facebook",GCLocalizedString(@"邮箱"),@"Skype"];
    _urlArray = @[@"https://www.tenonvpn.net/telegramg…",@"https://www.tenonvpn.net/twitter/tele…",@"https://www.tenonvpn.net/facebook/…",@"tenonvpn@gmail.com",@"tenonvpn@outlook.com"];
    _myTableView = [[UITableView alloc] init];
    _myTableView.tableFooterView = [[UIView alloc] init];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = [UIColor clearColor];
    _myTableView.scrollEnabled = NO;
    _myTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [_myTableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingTableViewCell"];
    _myTableView.estimatedRowHeight = 40;
    [self.view addSubview:_myTableView];
    [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.mas_equalTo(kWIDTH);
        make.top.equalTo(oneView.mas_bottom).offset(16);
        make.height.mas_equalTo(200);
    }];
    
    UIButton *twoBtn = [[UIButton alloc] init];
    twoBtn.layer.cornerRadius = 22.0f;
    twoBtn.titleLabel.font = Font_B(14);
    twoBtn.backgroundColor = kRBColor(18, 181, 170);
    [twoBtn setTitleColor:kRBColor(0, 41, 51) forState:0];
    [twoBtn setTitle:GCLocalizedString(@"更新版本") forState:0];
    [twoBtn addTarget:self action:@selector(updateBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twoBtn];
    [twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_myTableView.mas_bottom).offset(24);
        make.height.mas_equalTo(44);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellOneLab.text = _titleArray[indexPath.row];
    cell.cellTwoLab.text = _urlArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view makeToast:[NSString stringWithFormat:@"跳转%@",_urlArray[indexPath.row]] duration:2 position:BOTTOM];
}

-(void)updateBtnClicked
{
    [self.view makeToast:GCLocalizedString(@"更新版本") duration:2 position:BOTTOM];
}

-(void)selectBtnClicked
{
    WS(weakSelf);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:GCLocalizedString(@"选择语言") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
    UIAlertAction *action = [UIAlertAction actionWithTitle:GCLocalizedString(@"中文") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.languageLabel.text = GCLocalizedString(@"中文");
        [NSBundle setLanguage:@"zh-Hans"];
        [self resetRootViewController];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.languageLabel.text = @"English";
        [NSBundle setLanguage:@"en"];
        [self resetRootViewController];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"한글" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.languageLabel.text = @"한글";
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:GCLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
}

//重新设置
-(void)resetRootViewController
{
    for(UIView *view in [self.view subviews])
    {
        [view removeFromSuperview];
    }
    [self viewDidLoad];
  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLanguage" object:nil];
}
@end
