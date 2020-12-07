//
//  UIBaseModel.h
//  PlayGame
//
//  Created by admin on 2020/10/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define BM_modelId @"modelId"
#define BM_title @"title"
#define BM_titleSize @"titleSize"
#define BM_titleColor @"titleColor"
#define BM_subTitle @"subTitle"
#define BM_time @"time"
#define BM_subTitleSize @"subTitleSize"
#define BM_subTitleColor @"subTitleColor"
#define BM_backColor @"backColor"
#define BM_cellHeight @"cellHeight"
#define BM_type @"type"
#define BM_mark @"mark"
#define BM_leading @"leading"
#define BM_trading @"trading"
#define BM_top @"top"
#define BM_bottom @"bottom"
#define BM_dataArray @"dataArray"
#define BM_KeyBoardType @"keyboardType"
#define BM_Width @"width"
#define BM_TextField @"textField"
#define BM_SubAlignment @"subAlignment"
#define BM_TitleAlignment @"titleAlignment"
#define BM_imageName @"imageName"

typedef enum _UIType {
    UITitleType  = 1,
    UILineType,
    UITextType,
    UIFiledType,
    UISwitchType,
    UITipsType,
    UISpaceType,
    UIVerificationType,
    UIConfirnBtnType,
    UIForgetRegistType,
    UILabelButtonType,
    UIImageLabelSelectType,
    UIMyHeadNameIDType,
    UIOrderListType,
    UIOrderDetailHeaderType,
    UILabelContentType,
    UIMyPorketType
} UIType;


@interface UIBaseModel : NSObject
+ (instancetype)initWithDic:(NSDictionary*)dic;
@property (nonatomic, strong) NSString* modelId;
@property (nonatomic, strong) NSString* imageName;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSNumber* titleSize;
//    NSTextAlignmentLeft      = 0,    // Visually left aligned
//    NSTextAlignmentCenter    = 1,    // Visually centered
//    NSTextAlignmentRight     = 2,    // Visually right aligned
@property (nonatomic, strong) NSNumber* titleAlignment; // 0-left 1-center 2-right
@property (nonatomic, strong) UIColor* titleColor;
@property (nonatomic, strong) NSString* subTitle;
@property (nonatomic, strong) NSNumber* subTitleSize;
@property (nonatomic, strong) NSNumber* subAlignment; // 0-left 1-center 2-right

@property (nonatomic, strong) UIColor* subTitleColor;

@property (nonatomic, strong) UIColor* backColor;
@property (nonatomic, strong) NSNumber* cellHeight;
@property (nonatomic, strong) NSNumber* type;

@property (nonatomic, strong) NSNumber* leading;
@property (nonatomic, strong) NSNumber* trading;
@property (nonatomic, strong) NSNumber* width;
@property (nonatomic, strong) NSNumber* top;
@property (nonatomic, strong) NSNumber* bottom;

@property (nonatomic, strong) NSNumber* keyboardType;
@property (nonatomic, strong) id mark;
@property (nonatomic, strong) NSString* time;
@property (nonatomic, strong) NSMutableArray* dataArray;
@end

NS_ASSUME_NONNULL_END
