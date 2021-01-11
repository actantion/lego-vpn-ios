
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 工具类
@interface HelpTool : NSObject

/// 获取今天的日期：年月日
+ (NSDictionary *)getTodayDate;

/// 获取当前时间戳
+ (NSString *)getCurrentTimestamp;

///获取当前的时间戳（13位）
+ (NSString *)getNowTimeStr;

/// 邮箱验证
/// @param email <#email description#>
+ (BOOL)justEmail:(NSString *)email;

/// 手机号码验证
/// @param mobile <#mobile description#>
+ (BOOL)justMobile:(NSString *)mobile;

/// 验证用户名
/// @param name <#name description#>
+ (BOOL)justUserName:(NSString *)name;

/// 验证昵称
/// @param nickname <#nickname description#>
+ (BOOL)justNickname:(NSString *)nickname;

/// 验证身份证号
/// @param identityCard <#identityCard description#>
+ (BOOL)justIdentityCard:(NSString *)identityCard;

/// 判断字符串是否为空
/// @param string <#string description#>
+ (BOOL)isBlankString:(NSString *)string;


/// 将字典转换成字符串
/// @param dict <#dict description#>
+ (NSString *)dictionaryToJson:(NSDictionary *)dict;


/// json格式化字符串转换成字典
/// @param jsonStr <#jsonStr description#>
+ (NSDictionary*)toJSONData:(NSString *)jsonStr;

/// 获取当前UDID
+ (NSString *)getDeviceIdentifierForVendor;

///获取到当前最上层的控制器
+ (UIViewController *)nowController;


///时间间隔转天，时，分
+ (NSString *)timeFormatter:(int)interval;

//传入 秒  得到  xx分钟xx秒
+(NSString *)getMMSSFromSS:(NSString *)totalTime;


#pragma mark - 处理后台返回的数据在iOS出现精度丢失的问题
///处理后台返回的数据在iOS出现精度丢失的问题
+ (NSDecimalNumber *)reviseDecimalNumberString:(id)valueStr;


///base64解码
+(NSString *)base64DecodeUrlString:(NSString *)base64CodeStr;

#pragma mark - 获取字符串高度
+ (CGFloat)getStringHeightWithText:(NSString *)text font:(UIFont *)font viewWidth:(CGFloat)width;

#pragma mark -退出登录后清除缓存
+(void)loginOutClearData;

#pragma mark -View 转图片
+ (UIImage *)convertViewToImage:(UIView *)view;

#pragma mark - 将图片转换成NSData
/// 将UIImage转成NSData格式
/// @param image Image图片
/// @param qualityFloat 当是JPEG格式时，压缩质量系数
+ (NSData*)getDataFromImage:(UIImage*)image compressionQuality:(CGFloat)qualityFloat;


#pragma mark -生成二维码
/// 生成二维码
/// @param urlString 二维码信息
/// @param size 图片大小
+(UIImage *)createCodeImageFormUrlstring:(NSString *)urlString withSize:(CGFloat)size;

// 获取plist中的值
+ (NSString *)URLSchemesForkey:(NSString *)key;
@end
NS_ASSUME_NONNULL_END
