

#import "HelpTool.h"

@implementation HelpTool

#pragma  mark - 获取当天的日期：年月日
+ (NSDictionary *)getTodayDate {
    
    //获取今天的日期
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay;
    
    NSDateComponents *components = [calendar components:unit fromDate:today];
    NSString *year = [NSString stringWithFormat:@"%ld", (long)[components year]];
    NSString *month = [NSString stringWithFormat:@"%02ld", (long)[components month]];
    NSString *day = [NSString stringWithFormat:@"%02ld", (long)[components day]];
    
    NSMutableDictionary *todayDic = [[NSMutableDictionary alloc] init];
    [todayDic setObject:year forKey:@"year"];
    [todayDic setObject:month forKey:@"month"];
    [todayDic setObject:day forKey:@"day"];

    return todayDic;
    
}

+ (NSString *)getCurrentTimes {
    //获得系统时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"HH:mm"];
//    NSString *  locationString=[dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    NSString *  morelocationString = [dateformatter stringFromDate:senddate];
    return morelocationString;
}

/**
 *  获取当前时间的时间戳（例子：1464326536）
 *
 *  @return 时间戳字符串型
 */
+ (NSString *)getCurrentTimestamp {
    //获取系统当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    // 转为字符型
    return timeString;
}

#pragma mark --- 获取当前时间戳--13位
+ (NSString *)getNowTimeStr{
    
    //获取当前时间戳
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeSp = [NSString stringWithFormat:@"%.0f", time];
    
    return timeSp;
}
 
//邮箱
+ (BOOL)justEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//手机号码验证
+ (BOOL)justMobile:(NSString *)mobile {
    //手机号以1+[3~8]的数组开头，九个 \d 数字字符
    NSString *phoneRegex = @"^[1][3-8]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//用户名
+ (BOOL)justUserName:(NSString *)name {
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}

//昵称
+ (BOOL)justNickname:(NSString *)nickname {
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *nicknamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [nicknamePredicate evaluateWithObject:nickname];
}

//身份证号
+ (BOOL)justIdentityCard:(NSString *)identityCard {
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//判断是否为空字符串
+ (BOOL)isBlankString:(NSString *)string {
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    NSString *temptStr = [NSString stringWithFormat:@"%@",string];
    if (string == nil || string == NULL || [temptStr isEqualToString:@"<null>"] || [temptStr isEqualToString:@""]||[temptStr isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//获取UDID
+ (NSString *)getDeviceIdentifierForVendor {
    CFUUIDRef  uuid_ref = CFUUIDCreate(nil);
    
    NSString  *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuid_ref);
    
    CFRelease(uuid_ref);
    
    return uuidString;
}

#pragma mark - 将字典转换成字符串
+ (NSString *)dictionaryToJson:(NSDictionary *)dict {
    NSError *parseError =nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&parseError];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}

#pragma mark - json格式化转换成字典
+ (NSDictionary*)toJSONData:(NSString *)jsonStr {
    if (jsonStr==nil) {
        return nil;
    }
    NSError *error=nil;
    NSData *objectData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:objectData options:0 error:&error];
    return jsonDic;
}

#pragma mark - 获取到当前最上层的控制器
+ (UIViewController *)nowController {
    UIViewController* vc = [UIApplication sharedApplication].windows[0].rootViewController;
    while (1)
    {
        if ([vc isKindOfClass:[UITabBarController class]])
        {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController)
        {
            vc = vc.presentedViewController;
        }
        else
        {
            break;
        }
    }
    return vc;
}

#pragma mark - 获取导航栈的栈顶视图
+(UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        //visibleViewController 就是当前显示的控制器,和哪个导航栈没有关系，只是当前显示的控制器，也就是说任意一个导航的visibleViewController所返回的值应该是一样的,
        //topViewController 是某个导航栈的栈顶视图
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

///时间间隔转天，时，分
+ (NSString *)timeFormatter:(int)interval {
    //    int seconds = interval % 60;
    //    int minutes = (interval / 60) % 60;
    //    int hours = interval / 3600;
    
    int days = (int)(interval/(3600*24));
    int hours = (int)((interval-days*24*3600)/3600);
    int minute = (int)(interval-days*24*3600-hours*3600)/60;
//  int second = interval-days*24*3600-hours*3600-minute*60;
    return [NSString stringWithFormat:@"还有%d天%d时%d分结束",days,hours,minute];
}
//传入 秒  得到  xx分钟xx秒
+(NSString *)getMMSSFromSS:(NSString *)totalTime{

    NSInteger seconds = [totalTime integerValue];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%.2ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%.2ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}

 
#pragma mark - 处理后台返回的数据在iOS出现精度丢失的问题
+ (NSDecimalNumber *)reviseDecimalNumberString:(id)valueStr {
    //直接传入精度丢失有问题的Double类型
    double conversionValue = [[NSString stringWithFormat:@"%@",valueStr] doubleValue];
    NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return decNumber;
}

 
///base64解码
+(NSString *)base64DecodeUrlString:(NSString *)base64CodeStr
{
    if (!base64CodeStr) return @"";
        
    NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:base64CodeStr options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    return [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
}

#pragma mark - 计算字符串高度
+ (CGFloat)getStringHeightWithText:(NSString *)text font:(UIFont *)font viewWidth:(CGFloat)width {
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);

    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;

    // 计算文字占据的宽高
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;

   // 当你是把获得的高度来布局控件的View的高度的时候.size转化为ceilf(size.height)。
    return  ceilf(size.height);
}

+ (BOOL)isValidUrlAddress:(NSString *)urlStr
{
    NSString *reg =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";

    NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];

    return [urlPredicate evaluateWithObject:urlStr];
}

//退出登录清除缓存
+ (void)loginOutClearData
{
    REMOVEDEFAULTS(@"USERNAME")
    REMOVEDEFAULTS(@"HEADIMAGE")
    REMOVEDEFAULTS(@"INVITECODE")
    REMOVEDEFAULTS(@"BALANCE")
    REMOVEDEFAULTS(@"TOKEN")
    REMOVEDEFAULTS(@"SOUND")
    REMOVEDEFAULTS(@"SHAREINFO")
    REMOVEDEFAULTS(@"POSTERSIMAGE")
    REMOVEDEFAULTS(@"WECHAT_NUM")
    REMOVEDEFAULTS(@"QQ_NUM")
}

//view直接转图片
+ (UIImage *)convertViewToImage:(UIView *)view
{
    UIImage *imageRet = [[UIImage alloc]init];
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
    
}

#pragma mark - 将图片转换成NSData
+ (NSData*)getDataFromImage:(UIImage*)image compressionQuality:(CGFloat)qualityFloat {
    NSData *data;
    if (qualityFloat<=0.0) {
        qualityFloat = 0.6f;
    } else if (qualityFloat>=1.0) {
        qualityFloat = 1.0f;
    }
    if(UIImagePNGRepresentation(image)) {//判断图片是不是png格式的文件
        data = UIImagePNGRepresentation(image);
    } else {//判断图片是不是jpeg格式的文件
        data = UIImageJPEGRepresentation(image, qualityFloat);
    }
    return data;
}

#pragma 生成二维码
+(UIImage *)createCodeImageFormUrlstring:(NSString *)urlString withSize:(CGFloat)size
{
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    // 3.将字符串转换成NSdata
    NSData *data  = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"L" forKey:@"inputCorrectionLevel"];
    // 5.生成二维码
    CIImage *outputImage = [filter outputImage];
    
    CGRect extent = CGRectIntegral(outputImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 6.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 7.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
@end
