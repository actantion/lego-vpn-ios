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
#import "SettingSelectCell.h"
#import "UISpaceCell.h"
#import "UITipsCell.h"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic, strong) UILabel *languageLabel;
@property (nonatomic, strong) NSMutableArray *dataArray;
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

- (void)loadUI{
    self.dataArray = [[NSMutableArray alloc] init];
    NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
    NSString *mystr = [defaultdata objectForKey:@"language"];
    if (!mystr || !mystr.length) {
        mystr = @"Default";
    }
    
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                     BM_cellHeight:@20}]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITipsType),
                                                         BM_title:GCLocalizedString(@"Join the node"),
                                                         BM_leading:@(36),
                                                         BM_titleSize:@(14),
                                                         BM_cellHeight:@(14),
                                                         BM_backColor:[UIColor clearColor],
                                                         BM_titleColor:APP_MAIN_COLOR}]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                     BM_cellHeight:@20}]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISwitchType),
                                                         BM_title:GCLocalizedString(@"Language"),
                                                         BM_subTitle:GCLocalizedString(mystr)
    }]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                     BM_cellHeight:@10}]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITextType),
                                                         BM_title:GCLocalizedString(@"Third Node Join"),
                                                         BM_subTitle:@"https://github.com/tenondvpn/tenonvpn-join"}]];
    
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITextType),
                                                         BM_title:GCLocalizedString(@"TG Group"),
                                                         BM_subTitle:@"https://t.me/tenonvpn"}]];
    
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITextType),
                                                         BM_title:GCLocalizedString(@"Official website"),
                                                         BM_subTitle:@"https://www.tenonvpn.net"}]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITextType),
                                                         BM_title:@"Twitter",
                                                         BM_subTitle:@"https://twitter.com/tim_swu"}]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITextType),
                                                         BM_title:@"Facebook",
                                                         BM_subTitle:@"https://www.facebook.com/TenonVPN"}]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITextType),
                                                         BM_title:GCLocalizedString(@"Email"),
                                                         BM_subTitle:@"tenonvpn@gmail.com"}]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITextType),
                                                         BM_title:@"Skype",
                                                         BM_subTitle:@"tenonvpn@outlook.com"}]];

}
#pragma mark -加载视图
-(void)initUI
{
    CGFloat topH = isIPhoneXSeries ? 53.0f : 29.0f;
    
    UILabel *aboutLab = [[UILabel alloc] initWithFrame:CGRectMake(20, topH+48, 240, 50)];
    aboutLab.text = GCLocalizedString(@"Settings");
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
    [self loadUI];
    
    _myTableView = [[UITableView alloc] init];
    _myTableView.tableFooterView = [[UIView alloc] init];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = [UIColor clearColor];
    _myTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    [_myTableView registCell:@"SettingTableViewCell"];
    [_myTableView registCell:@"SettingSelectCell"];
    [_myTableView registCell:@"UISpaceCell"];
    [_myTableView registCell:@"UITipsCell"];
    
    
    [self.view addSubview:_myTableView];
    [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.mas_equalTo(kWIDTH);
        make.top.equalTo(aboutLab.mas_bottom).offset(16);
        make.height.mas_equalTo(kHEIGHT - aboutLab.bottom - 16);
    }];
    
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIBaseModel* model = self.dataArray[indexPath.row];
    if ([model.type  isEqual: @(UISwitchType)]) {
        SettingSelectCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SettingSelectCell"];
        [cell setModel:model];
        return cell;
    }else if ([model.type isEqual:@(UITextType)]){
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellOneLab.text = model.title;
        cell.cellTwoLab.text = model.subTitle;
        return cell;
    }else if ([model.type isEqual:@(UISpaceType)]){
        UISpaceCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UISpaceCell"];
        cell.constraintCellHeight.constant = model.cellHeight.floatValue;
        cell.backView.backgroundColor = UIColor.clearColor;
        return cell;
    }else if ([model.type isEqual:@(UITipsType)]){
        UITipsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITipsCell"];
        [cell setModel:model];
        return cell;
    }else{
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellOneLab.text = model.title;
        cell.cellTwoLab.text = model.subTitle;
        return cell;
    }
    
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIApplication *application = [UIApplication sharedApplication];
//    NSURL *URL = [NSURL URLWithString:_urlArray[indexPath.row]];
//    if (@available(iOS 10.0, *)) {
//        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
//            NSLog(@"Open %@: %d",self->_urlArray[indexPath.row],success);
//        }];
//    } else {
//        // Fallback on earlier versions
//        BOOL success = [application openURL:URL];
//        NSLog(@"Open %@: %d",_urlArray[indexPath.row],success);
//    }
//
//    [self.view makeToast:[NSString stringWithFormat:@"跳转%@",_urlArray[indexPath.row]] duration:2 position:BOTTOM];
//}

-(void)updateBtnClicked
{
    [self.view makeToast:GCLocalizedString(@"Upgrade") duration:2 position:BOTTOM];
}

-(void)selectBtnClicked
{
    WS(weakSelf);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:GCLocalizedString(@"Language") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
    UIAlertAction *action = [UIAlertAction actionWithTitle:GCLocalizedString(@"中文") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.languageLabel.text = GCLocalizedString(@"中文");
        [NSBundle setLanguage:@"zh-Hans-CN"];
        [self resetRootViewController];
        self->_languageLabel.text = @"中文";
        NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
        [defaultdata setObject:@"中文" forKey:@"language"];
        [defaultdata synchronize];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.languageLabel.text = @"English";
        [NSBundle setLanguage:@"en"];
        [self resetRootViewController];
        self->_languageLabel.text = @"English";
        NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
        [defaultdata setObject:@"English" forKey:@"language"];
        [defaultdata synchronize];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"한글" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.languageLabel.text = @"한글";
        [NSBundle setLanguage:@"en"];
        [self resetRootViewController];
        self->_languageLabel.text = @"한글";
        NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
        [defaultdata setObject:@"한글" forKey:@"language"];
        [defaultdata synchronize];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:GCLocalizedString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
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
