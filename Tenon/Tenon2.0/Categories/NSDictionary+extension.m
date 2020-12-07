//
//  NSDictionary+extension.m
//  houhan
//
//  Created by 虚竹 on 2017/7/20.
//  Copyright © 2017年 后汉集团. All rights reserved.
//

#import "NSDictionary+extension.h"

@implementation NSDictionary (extension)

#pragma mark - 解析成对象：id、NSDictionary、NSString、NSArray

-(id)cc_objectForKey:(NSString *)key {
    
    id value = [self objectForKey:key];
    if([value isKindOfClass:[NSNull class]] || !value) {
        return @"";
    }else {
        return value;
    }
}

- (NSDictionary *)cc_dictionaryForKey:(NSString *)key {
    
    id value = [self objectForKey:key];
    if([value isKindOfClass:[NSNull class]] || !value) {
        return @{};
    }else {
        return value;
    }
}

- (NSString *)cc_stringForKey:(NSString *)key {
    
    id value = [self objectForKey:key];
    if([value isKindOfClass:[NSNull class]] || !value) {
        return @"";
    }else {
        return [NSString stringWithFormat:@"%@",value];
    }
}

- (NSArray *)cc_arrayForKey:(NSString *)key {
    
    id value = [self objectForKey:key];
    if([value isKindOfClass:[NSNull class]] || !value) {
        return @[];
    }else{
        return value;
    }
}

- (NSArray *)cc_arrayForKey:(NSString *)key
          separatedByString:(NSString *)separator {
    
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNull class]] || !value) {
        return @[];
    }else if ([value isKindOfClass:[NSString class]]) {
        return [value componentsSeparatedByString:separator];
    }
    return @[];
}

#pragma mark - 解析成基本数据类型：BOOL、int、long、int64_t、NSInteger、CGFloat
- (BOOL)cc_boolForKey:(NSString *)key {
    
    id value = [self objectForKey:key];
    if([value isKindOfClass:[NSNull class]] || !value) {
        return false;
    }else{
        
        NSString *boolStr = [NSString stringWithFormat:@"%@",value];
        if ([boolStr isEqualToString:@"0"]) {
            return false;
        }else {
            return true;
        }
    }
}

- (int)cc_intForKey:(NSString *)key {
    NSString *valueString = [self cc_stringForKey:key];
    if (valueString.length) {
        return [valueString intValue];
    }else {
        return 0;
    }
}

- (long)cc_longForKey:(NSString *)key {
    id valueString = [self cc_objectForKey:key];
    if (valueString) {
        return [valueString longValue];
    }else {
        return 0;
    }
}

- (int64_t)cc_longLongForKey:(NSString *)key {
    NSString *valueString = [self cc_stringForKey:key];
    if (valueString.length) {
        return [valueString longLongValue];
    }else {
        return 0;
    }
}

- (NSInteger)cc_integerForKey:(NSString *)key {
    NSString *valueString = [self cc_stringForKey:key];
    if (valueString.length) {
        return [valueString integerValue];
    }else {
        return 0;
    }
}

- (CGFloat)cc_floatForKey:(NSString *)key {
    
    NSString *valueString = [self cc_stringForKey:key];
    if (valueString.length) {
        return [valueString floatValue];
    }else {
        return 0.0;
    }
}

- (double)cc_doubleForKey:(NSString *)key {
    
    NSString *valueString = [self cc_stringForKey:key];
    if (valueString.length) {
        return [valueString doubleValue];
    }else {
        return 0.0;
    }
}

#pragma mark - Dictionary To String、Array
// NSDictionary转成NSString
- (NSString *)cc_toString {
    if (!self) {
        return @"";
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:kNilOptions error:nil];
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding];
}

@end
