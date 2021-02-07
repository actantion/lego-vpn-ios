//
//
//  Created by leiwenkai on 2018/4/25.
//  Copyright © 2018年 com.askzhu. All rights reserved.
//

#import "AZHUDView.h"



static AZHUDView *loadingViewManager;

@interface AZHUDView()

@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation AZHUDView

+ (AZHUDView *)manager {
    @synchronized (self) {
        if (loadingViewManager == nil) {
            loadingViewManager = [[AZHUDView alloc] init];
        }
    }
    return loadingViewManager;
}

- (BOOL)willDealloc {
    return NO;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [APP_MAIN_COLOR colorWithAlphaComponent:0.1];
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    [self addSubview:self.loadingImageView];
    [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(30.f);
    }];
}

- (void)showInView:(UIView *)view withViewController:(UIViewController*)vc {
    if (view.frame.size.width == 600 && view.frame.size.height == 600) {
        self.frame = ZSWindow.bounds;
        [vc.view addSubview:self];
    } else {
        self.frame = view.bounds;
        [view addSubview:self];
    }
    
    [self.loadingImageView startAnimating];
}

- (void)dismiss {
    [self.loadingImageView stopAnimating];
    [self removeFromSuperview];
}


#pragma mark - geter

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray  = [[NSMutableArray alloc] init];
        for (int i = 1; i < 13; i ++) {
            [_imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"load%d.png", i]]];
        }
    }
    return _imageArray;
}

- (UIImageView *)loadingImageView {
    if (!_loadingImageView) {
        _loadingImageView = [[UIImageView alloc] init];
        _loadingImageView.animationImages = self.imageArray;
        _loadingImageView.animationDuration = 2.f;
    }
    return _loadingImageView;
}

@end
