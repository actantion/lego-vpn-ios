//
//  JTNetwork.m
//  UKEX
//
//  Created by jitong on 2018/7/19.
//  Copyright © 2018年 funky. All rights reserved.
//

#import "JTNetwork.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIImage+TOOL.h"


//内部版本号
#define VSERSION  [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"]

@implementation JTNetwork

+ (JTNetwork *)manager {
    static JTNetwork *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[JTNetwork alloc]init];
    });
    return  sharedManager;
}

-(instancetype)init {
    self=[super init];
    if (self) {
        
    }
    return self;
}

- (void)addHeader:(NSDictionary *)body {
    _manager=[AFHTTPSessionManager manager];
   
    _manager.operationQueue.maxConcurrentOperationCount = 1;
}


//字典转为Json字符串
-(NSString *)dictionaryToJson:(NSDictionary *)dic
{
    if (!dic) {
        return @"";
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark - MD5加密 32位 大写
- (NSString *)MD5ForUpper32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}


+ (void)requestPostWithParam:(NSDictionary *)param url:(NSString *)url callback:(networkComplateBlock)callback {
    [[JTNetwork manager] addHeader:param];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SERVER_URL,url];
    NSLog(@"url ---  %@",urlString);
//    NSLog(@"param = %@",param);
    [[JTNetwork manager].manager POST:urlString parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        JTBaseReqModel *model = [JTBaseReqModel mj_objectWithKeyValues:responseObject];
        if (callback) {
            callback(model);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"客户端报错 %@",error);
        
        JTBaseReqModel *model = [[JTBaseReqModel alloc] init];
        model.message = (NSString *)model.data;
        model.error = error;
        model.status = -2;
        if (callback) {
            callback(model);
        }
    }];
    
}

+ (void)requestGetWithParam:(NSDictionary *)param url:(NSString *)url callback:(networkComplateBlock)callback {
    [[JTNetwork manager] addHeader:param];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",SERVER_URL,url];
    NSLog(@"url=%@",urlString);
    NSLog(@"param=%@",param);
    [[JTNetwork manager].manager GET:urlString parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        JTBaseReqModel *model = [JTBaseReqModel mj_objectWithKeyValues:dic];
        if (callback) {
            callback(model);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        JTBaseReqModel *model = [[JTBaseReqModel alloc] init];
        model.message = (NSString *)model.data;
        model.status = 0;
        if (callback) {
            callback (model);
        }
    }];
}

@end
