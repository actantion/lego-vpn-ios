//
//  NSDictionary+extension.h
//  houhan
//
//  Created by 虚竹 on 2017/7/20.
//  Copyright © 2017年 后汉集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (extension)

#pragma mark - 解析成对象：id、NSDictionary、NSString、NSArray
/**
 *  字典解析获取id类型
 *
 *  @param key 字符串key
 *
 *  @return id
 */
-(id)cc_objectForKey:(NSString *)key;

/**
 *  字典解析获取字典
 *
 *  @param key 字符串key
 *
 *  @return 字典
 */
- (NSDictionary *)cc_dictionaryForKey:(NSString *)key;

/**
 *  字典解析获取字符串
 *
 *  @param key 字符串key
 *
 *  @return 字符串
 */
- (NSString *)cc_stringForKey:(NSString *)key;

/**
 *  字典解析获取数组
 *
 *  @param key 字符串key
 *
 *  @return 数组串
 */
- (NSArray *)cc_arrayForKey:(NSString *)key;

/**
 *  字典解析后分隔字符串获取数组
 *
 *  @param key       字符串key
 *  @param separator 分隔符
 *
 *  @return 分割后的数组
 */
- (NSArray *)cc_arrayForKey:(NSString *)key
          separatedByString:(NSString *)separator;

#pragma mark - 解析成基本数据类型：BOOL、int、long、int64_t、NSInteger、CGFloat
/**
 *  字典解析获取BOOL
 *
 *  @param key 字符串key
 *
 *  @return BOOL
 */
- (BOOL)cc_boolForKey:(NSString *)key;

/**
 *  字典解析获取int
 *
 *  @param key 字符串key
 *
 *  @return int
 */
- (int)cc_intForKey:(NSString *)key;

/**
 *  字典解析获取long int
 *
 *  @param key 字符串key
 *
 *  @return long int
 */
- (long)cc_longForKey:(NSString *)key;

/**
 *  字典解析获取long long int
 *
 *  @param key 字符串key
 *
 *  @return long long int
 */
- (int64_t)cc_longLongForKey:(NSString *)key;

/**
 *  字典解析获取int
 *
 *  @param key 字符串key
 *
 *  @return int
 */
- (NSInteger)cc_integerForKey:(NSString *)key;

/**
 *  字典解析获取float
 *
 *  @param key 字符串key
 *
 *  @return float
 */
- (CGFloat)cc_floatForKey:(NSString *)key;

/**
 *  字典解析获取double
 *
 *  @param key 字符串key
 *
 *  @return double
 */
- (double)cc_doubleForKey:(NSString *)key;

#pragma mark - Dictionary To String、Array
/**
 NSDictionary转成NSString
 
 @return String
 */
- (NSString *)cc_toString;
@end
