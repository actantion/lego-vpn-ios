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
@property (nonatomic, strong) NSMutableArray *dataArray;
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
    NSString *language = [defaultdata objectForKey:@"language"];
    NSString *proxy = [defaultdata objectForKey:@"proxy pattern"];
    if (language.length == 0) {
        language = @"Default";
    }
    if (proxy.length == 0) {
        proxy = @"Default";
    }
    
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                     BM_cellHeight:@20}]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITipsType),
                                                         BM_title:GCLocalizedString(@"Join Nodes"),
                                                         BM_leading:@(36),
                                                         BM_titleSize:@(14),
                                                         BM_cellHeight:@(14),
                                                         BM_backColor:[UIColor clearColor],
                                                         BM_titleColor:APP_MAIN_COLOR}]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                     BM_cellHeight:@20}]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITipsType),
                                                         BM_title:GCLocalizedString(@"Third-party node access, one-click startup, and access to the decentralized Tenon VPN network to provide services and routing"),
                                                         BM_leading:@(36),
                                                         BM_titleSize:@(14),
                                                         BM_cellHeight:@(14),
                                                         BM_backColor:[UIColor clearColor],
                                                         BM_titleColor:MyBgLightGrayColor}]];
    
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UITipsType),
                                                         BM_title:@"https://github.com/tenondvpn/tenonvpn-join",
                                                         BM_Index:@"1",
                                                         BM_leading:@(36),
                                                         BM_titleSize:@(14),
                                                         BM_cellHeight:@(14),
                                                         BM_backColor:[UIColor clearColor],
                                                         BM_titleColor:APP_MAIN_COLOR}]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                     BM_cellHeight:@30}]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISwitchType),
                                                         BM_Index:@"2",
                                                         BM_title:GCLocalizedString(@"Language"),
                                                         BM_subTitle:GCLocalizedString(language)
    }]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                     BM_cellHeight:@20}]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISwitchType),
                                                         BM_Index:@"3",
                                                         BM_title:GCLocalizedString(@"proxy pattern"),
                                                         BM_subTitle:GCLocalizedString(proxy)
    }]];
    [self.dataArray addObject:[UIBaseModel initWithDic:@{BM_type:@(UISpaceType),
                                                     BM_cellHeight:@30}]];
    
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setModel:model];
        cell.clickBlock = ^{
            if ([model.index intValue] == 2) {
                // 选择语言
                [self selectBtnClicked];
            }else if ([model.index intValue] == 3) {
                // 代理模式
                [self selectBtnProxy];
            }
        };
        return cell;
    }else if ([model.type isEqual:@(UITextType)]){
        SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellOneLab.text = model.title;
        cell.cellTwoLab.text = model.subTitle;
        return cell;
    }else if ([model.type isEqual:@(UISpaceType)]){
        UISpaceCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UISpaceCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.constraintCellHeight.constant = model.cellHeight.floatValue;
        cell.backView.backgroundColor = UIColor.clearColor;
        return cell;
    }else if ([model.type isEqual:@(UITipsType)]){
        UITipsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITipsCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIBaseModel* model = self.dataArray[indexPath.row];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:[model.index intValue] == 1 ? model.title:model.subTitle];
    if (@available(iOS 10.0, *)) {
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            
        }];
    } else {
        // Fallback on earlier versions
        BOOL success = [application openURL:URL];
    }
}

-(void)updateBtnClicked
{
    [self.view makeToast:GCLocalizedString(@"Upgrade") duration:2 position:BOTTOM];
}

-(void)selectBtnClicked
{
    UIBaseModel* model = nil;
    for (UIBaseModel* tempModel in self.dataArray) {
        if ([tempModel.type isEqual:@(UISwitchType)] && [tempModel.index intValue] == 2) {
            model = tempModel;
        }
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:GCLocalizedString(@"Language") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:GCLocalizedString(@"中文") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        model.subTitle = GCLocalizedString(@"中文");
        [NSBundle setLanguage:@"zh-Hans-CN"];
        NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
        [defaultdata setObject:@"中文" forKey:@"language"];
        [defaultdata synchronize];
        [self resetRootViewController];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        model.subTitle = @"English";
        [NSBundle setLanguage:@"en"];
        
        NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
        [defaultdata setObject:@"English" forKey:@"language"];
        [defaultdata synchronize];
        [self resetRootViewController];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"한글" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        model.subTitle = @"한글";
        [NSBundle setLanguage:@"en"];
        
        NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
        [defaultdata setObject:@"한글" forKey:@"language"];
        [defaultdata synchronize];
        [self resetRootViewController];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:GCLocalizedString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)selectBtnProxy
{
    UIBaseModel* model = nil;
    for (UIBaseModel* tempModel in self.dataArray) {
        if ([tempModel.type isEqual:@(UISwitchType)] && [tempModel.index intValue] == 3) {
            model = tempModel;
        }
    }
    WS(weakSelf);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:GCLocalizedString(@"proxy pattern") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:GCLocalizedString(@"smart_route") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        model.subTitle = GCLocalizedString(@"smart_route");
        NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
        [defaultdata setObject:@"smart_route" forKey:@"proxy pattern"];
        [defaultdata synchronize];
        [weakSelf.myTableView reloadData];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:GCLocalizedString(@"global_route") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        model.subTitle = GCLocalizedString(@"global_route");
        NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
        [defaultdata setObject:@"global_route" forKey:@"proxy pattern"];
        [defaultdata synchronize];
        [weakSelf.myTableView reloadData];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:GCLocalizedString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [alert addAction:action2];
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
