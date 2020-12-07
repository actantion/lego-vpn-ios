//
//  NSString+Tool.h
//  CNUKwallet
//
//  Created by 黄焕林 on 2018/10/19.
//  Copyright © 2018年 黄焕林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 range的校验结果
 */
typedef enum
{
    RangeCorrect = 0,
    RangeError = 1,
    RangeOut = 2,
    
}RangeFormatType;

/// <#Description#>
@interface NSString (Tool)

+(NSMutableAttributedString *)getPriceAttribute:(NSString *)string;

//获取当前时间戳  （以毫秒为单位）

+(NSString *)getNowTimeTimestamp3;

#pragma mark - MD5加密 32位 大写
- (NSString *)MD5ForUpper32Bate:(NSString *)str;
//MD5小写
- (NSString*)md532BitLower;
// sha1 加密
- (NSString *) sha1:(NSString *)input;

#pragma mark - 将某个时间转化成 时间戳
+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;


/**
 时间戳转字符串
 
 @param format @"yyyy-MM-dd HH:mm:ss"
 @return 时间字符串
 */
- (NSString *)jt_stringFromTimestampWithFormat:(NSString *)format;

//将时间戳转换成NSDate,加上时区偏移
+(NSDate*)zoneChange:(NSString*)spString WithZone:(NSString *)zone;

/// 字符串转NSDate
/// @param format @"yyyy-MM-dd HH:mm:ss"
/// @param zone 时区
- (NSDate *)jt_dateWithStringFormat:(NSString *)format dTimeZone:(NSString *)zone;


- (NSString *)jt_birthStringFromTimestamp;

/**
 保留小数点后8位
 
 @param count 保留几位小数
 @return 截取后的字符串
 */
- (NSString *)jt_subStringWithDortWithCount:(NSInteger)count;

/**
处理小数位数

@param coin 币种ID 或者币种名称
@return 截取后的字符串
*/
- (NSString *)jt_subStringWithDortCount:(NSString *)coin;


//计算小数点位数
- (NSInteger)jt_countDecimal;

/**
 
 去除浮点数字符串后面的0
 */
- (NSString *)jt_removeFloatAllZero;

//精确到两位小数点，不进行四舍五入
-(NSString *)afterTwoPoint;

//获取设备型号
+ (NSString *)getCurrentDeviceModel;

//判断是否含有非法字符 yes 有  no没有
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content;

/*
 *  设置行间距和字间距
 *
 *  @param lineSpace 行间距
 *  @param kern      字间距
 *
 *  @return 富文本
 */

-(NSAttributedString *)getAttributedStringWithLineSpace:(CGFloat)lineSpace kern:(CGFloat)kern;

/**
 获取字符串高度

 @param string 字符串内容
 @param lineSpacing 行间距
 @param font font
 @param width with
 @return height
 */
+ (CGFloat)getStringHeigth:(NSString *)string lineSpacing:(CGFloat)lineSpacing font:(UIFont*)font width:(CGFloat)width;
//获取宽度
+ (CGFloat)getStringwith:(NSString *)string lineSpacing:(CGFloat)lineSpacing font:(UIFont*)font higth:(CGFloat)heigth;

//验证是否输入英文
- (BOOL)validateLetter;

//验证是否输入中文
- (BOOL)validateChinese;

- (BOOL)validateNumber;
/**
 *  改变字体大小
 *
 *  @param font  字体大小(UIFont)
 *  @param range 范围(NSRange)
 *
 *  @return 转换后的富文本（NSMutableAttributedString）
 */
- (NSMutableAttributedString *)changeFont:(UIFont *)font
                                 andRange:(NSRange)range;

/**
*  改变字体颜色
*
*  @param color  字体颜色(UIColor)
*  @param font  字体大小(UIFont)
*  @param range 范围(NSRange)
*
*  @return 转换后的富文本（NSMutableAttributedString）
*/
- (NSMutableAttributedString *)changeColor:(UIColor *)color
                                   andFont:(UIFont *)font
                                  andRange:(NSRange)range;


/**
*  文字中间添加横线
*
*  @return 转换后的富文本（NSMutableAttributedString）
*/
- (NSMutableAttributedString *)addCenterLine;

// JSON字符串转化成字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//字典转Json
+(NSString*)dicToJson:(NSMutableDictionary *)dic;

//把字符串转成Base64编码

+ (NSString *)base64EncodeString:(NSString *)string;

//字符串解码
- (NSString *)stringEncodeBase64:(NSString *)base6;

/**
 比较两个版本号的大小
 
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2;

//解决科学计算法
- (NSString *)formartScientificNotation;

// 判断是否输入表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

// 判断是否是九宫格输入
+ (BOOL)isNineKeyBoard:(NSString *)string;
//随机生成数字和字母的随机数
+ (NSString *)getRandomStringWithNum:(NSInteger)num;

/**
 *
 * 判断字符串的长度
 *
 * param length 字节长度
 *
 * return YES 表示小于等于这个长度
 *
 */
- (BOOL)jt_judgeStringWithMaxLength:(NSInteger)length;

@end

NS_ASSUME_NONNULL_END
