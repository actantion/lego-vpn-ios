//
//  AboutViewController.m
//  Tenonvpn
//
//  Created by Raobin on 2020/8/30.
//  Copyright © 2020 Raobin. All rights reserved.
//

#import "AboutViewController.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

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
    aboutLab.text = @"关于";
    aboutLab.textColor = kRBColor(154, 162, 161);
    aboutLab.font = Font_B(36);
    [self.view addSubview:aboutLab];
    
    UILabel *companyLab = [[UILabel alloc] initWithFrame:CGRectMake(kWIDTH-160, topH+78, 140, 20)];
    companyLab.text = @"TenonVPN © 2020";
    companyLab.textAlignment = NSTextAlignmentRight;
    companyLab.textColor = kRBColor(154, 162, 161);
    companyLab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:companyLab];
    
    UIScrollView *textBgView = [[UIScrollView alloc] init];
    textBgView.contentSize = CGSizeMake(0,1000);
    textBgView.backgroundColor = kRBColor(21, 25, 25);
    textBgView.layer.cornerRadius = 4.0f;
    [self.view addSubview:textBgView];
    [textBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(kWIDTH-40);
        make.top.equalTo(companyLab.mas_bottom).offset(12);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30-kSafeAreaBottomHeight);
    }];
    
    UILabel *textLab = [[UILabel alloc] init];
    textLab.textColor = kRBColor(154, 162, 161);
    textLab.font = [UIFont systemFontOfSize:14];
    textLab.numberOfLines = 0;
    textLab.lineBreakMode = 1;
    [textBgView addSubview:textLab];
    [textLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textBgView).offset(16);
        make.top.equalTo(textBgView).offset(16);
        make.width.mas_equalTo(kWIDTH-72);
    }];
    textLab.text = @"加入节点\n第三方节点接入，一键式启动，并接入去中心化Tenon VPN网络，提供服务和路由\nhttps://www.tenonvpn.net/telegramg…\n\n免责声明\nTenon VPN is composed of a large number of decentralized nodes, because there is no centralized server, thus avoiding the authority of centralization, that is, you can access the network without any blocking.\n\n技术方案\n1. Tenon VPN is composed of a large number of decentralized nodes, because there is no centralized server, thus avoiding the authority of centralization, that is, you can access the network without any blocking.\n\n2. Although Tenon VPN is decentralized, its performance is superior to a centralized VPN server because TenonVPN provides an original intelligent route that can find the best communication route through the user's current network conditions.\n\n3. Tenon VPN is decentralized. All user data is encrypted by the user's private key. At the same time, the addition of the intelligent routing network ensures the client's anonymity in the entire decentralized world.\n\n4. With a powerful P2P network and secure encryption technology, Tenvon VPN acts as a routing node through the user's home PC, making blocking impossible.\n\n5. Tenon VPN is easy to use, requires no complicated configuration, and can be safely, quickly and reliably entered into the decentralized world with one-click connection.";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:textLab.text];
    NSRange range1 = [[str string] rangeOfString:@"加入节点"];
    NSRange range2 = [[str string] rangeOfString:@"https://www.tenonvpn.net/telegramg…"];
    NSRange range3 = [[str string] rangeOfString:@"免责声明"];
    NSRange range4 = [[str string] rangeOfString:@"技术方案"];
    [str addAttribute:NSForegroundColorAttributeName value:kRBColor(18, 181, 170) range:range1];
    [str addAttribute:NSForegroundColorAttributeName value:kRBColor(18, 181, 170) range:range2];
    [str addAttribute:NSForegroundColorAttributeName value:kRBColor(18, 181, 170) range:range3];
    [str addAttribute:NSForegroundColorAttributeName value:kRBColor(18, 181, 170) range:range4];
    [str addAttribute:NSFontAttributeName value:Font_B(14) range:range1];
    [str addAttribute:NSFontAttributeName value:Font_B(14) range:range2];
    [str addAttribute:NSFontAttributeName value:Font_B(14) range:range3];
    [str addAttribute:NSFontAttributeName value:Font_B(14) range:range4];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6.0; // 设置行间距
    paragraphStyle.alignment = NSTextAlignmentJustified; //设置两端对齐显示
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    textLab.attributedText = str;
}

@end
