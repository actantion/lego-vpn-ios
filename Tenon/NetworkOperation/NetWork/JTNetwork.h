//
//  JTNetwork.h
//  UKEX
//
//  Created by jitong on 2018/7/19.
//  Copyright © 2018年 funky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTBaseReqModel.h"
#import "AFNetworking.h"

typedef void(^networkComplateBlock)(JTBaseReqModel *model);


typedef void(^networkAotuoBlock)(NSArray *urls);
typedef void(^chechNetworkBlock)(BOOL isCheck,NSString  *time);

@interface JTNetwork : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;

+ (JTNetwork *)manager;


/**
 网络请求 Post
 
 @param param 请求参数
 @param url 请求地址
 @param callback 回调信息
 */
+ (void)requestPostWithParam:(NSDictionary *)param url:(NSString *)url callback:(networkComplateBlock)callback;

/**
 网络请求 Get
 
 @param param 请求参数
 @param url 请求地址
 @param callback 回调信息
 */
+ (void)requestGetWithParam:(NSDictionary *)param url:(NSString *)url callback:(networkComplateBlock)callback;



/**
 图片上传

 @param url 请求地址
 @param imageParm 图片
 @param baseParam 基本参数
 @param callback block
 */
+ (void)requestImageWithUrl:(NSString *)url WithImageParam:(NSDictionary *)imageParm WithBaseParam:(NSDictionary *)baseParam callback:(networkComplateBlock)callback;

/// 检测路线的快慢
/// @param callback block
+ (void)autoChooseUrlCallBack:(networkAotuoBlock)callback;

//检查是否是停机维护
+ (void)checkServerCallback:(chechNetworkBlock)callback;



@end
