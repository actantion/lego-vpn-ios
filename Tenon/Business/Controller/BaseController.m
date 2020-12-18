//
//  BaseController.m
//  CNUKwallet
//
//  Created by 黄焕林 on 2018/9/6.
//  Copyright © 2018年 黄焕林. All rights reserved.
//

#import "BaseController.h"
#import "UIColor+Extension.h"
#import "UIButton+LargeArea.h"

#define STATUS_BAR_HEIGHT (IS_IPHONE_X == YES?44.0f:20.0f)
#define NAVIGATION_HEIGHT 44.0f
#define IS_IPHONE_X [self isIphoneX]

@interface BaseController ()<UIGestureRecognizerDelegate>
@property (nonatomic, assign)BOOL isCanUseSideBack;  // 手势是否启动
@property (nonatomic, strong) UIButton* btnBack;
@end

@implementation BaseController

#pragma mark  life Cycle



- (void)hiddenBackBtn:(BOOL)bHidden{
    self.btnBack.hidden = bHidden;
}

- (BOOL)isIphoneX{
    if (@available(iOS 11.0, *)) {
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        if (window.safeAreaInsets.bottom > 0.0) return YES;
        else return NO;
    }
    else return NO;
}
- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navagationBarHiden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navition"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //配置navagationbar的属性
    [self.navigationController setNavigationBarHidden:_navagationBarHiden animated:YES];
    self.navigationController.navigationBar.tintColor =self.navagationBarTextColor?:[UIColor hexColor:@"#000000"];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.navagationBarTextColor?:[UIColor hexColor:@"#000000"],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
}

- (void)addNavigationView{
    self.vwNavigation = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, NAVIGATION_HEIGHT + STATUS_BAR_HEIGHT)];
    self.vwNavigation.backgroundColor = UIColor.blackColor;
    self.vwNavigation.alpha = 1;
    if (self.naviTitle.length == 0) {
        self.naviTitle = @" ";
    }
    UILabel* lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    lbTitle.text = self.naviTitle;
    [lbTitle sizeToFit];
    lbTitle.bottom = self.vwNavigation.bottom - 11.f;
    lbTitle.centerX = kWIDTH/2.f;
    lbTitle.textColor = APP_MAIN_COLOR;
    
    self.btnBack = [[UIButton alloc] initWithFrame:CGRectMake(16, 0, 8, 15)];
    [self.btnBack setEnlargeEdgeWithTop:10 right:20 bottom:10 left:20];
    [self.btnBack setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    self.btnBack.centerY = lbTitle.centerY;
    [self.vwNavigation addSubview:self.btnBack];
    [self.vwNavigation addSubview:lbTitle];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0,self.vwNavigation.height , kWIDTH, 1)];
    line.backgroundColor = kRBColor(21, 25, 25);
    [self.vwNavigation addSubview:line];
    [self.view addSubview:self.vwNavigation];
}
- (void)hiddenNavigation{
    self.vwNavigation.height = 0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *stringClass = NSStringFromClass(self.class);
    NSLog(@"当前类名 ：%@",stringClass);
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addNavigationView];
    self.reqParam = [[NSMutableDictionary alloc] init];
}

#pragma mark methods

- (void)goBack{
    [self pop];
}

- (void)push:(UIViewController *)viewController {
    if (self.navigationController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)pop{
    if (self.navigationController&&self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)popToRoot{
    if (self.navigationController&&self.navigationController.viewControllers.count>1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark Setter or Getter

- (void)setNavagationBarHiden:(BOOL)navagationBarHiden{
    _navagationBarHiden = navagationBarHiden;
    [self.navigationController setNavigationBarHidden:navagationBarHiden animated:YES];
}


@end
