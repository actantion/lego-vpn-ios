//
//  UIBaseModel.m
//  PlayGame
//
//  Created by admin on 2020/10/29.
//

#import "UIBaseModel.h"

@implementation UIBaseModel
+ (instancetype)initWithDic:(NSDictionary*)dic{
    UIBaseModel* model = [[UIBaseModel alloc] init];
    for (NSString* key in dic) {
        [model setPropertyValue:dic[key] propertyName:[NSString stringWithFormat:@"_%@",key]];
    }
    return model;
}
@end
