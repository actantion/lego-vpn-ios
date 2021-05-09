//
//  KeychainManager.h
//  TenonVPN
//
//  Created by admin on 2021/2/8.
//  Copyright © 2021 zly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainItemWrapper.h"

NS_ASSUME_NONNULL_BEGIN

@interface KeychainManager : NSObject

@property (nonatomic, strong) KeychainItemWrapper *wrapper;
+ (KeychainManager *)shareInstence;
- (NSString*)getKeyChainReceipt;
- (NSInteger)getKeyChainType;
- (void)setKeyChainReceipt:(NSString*)receipt;
- (void)setKeyChainType:(NSInteger)Type;
- (void)setKeyChainTranscate:(NSString*)transcate;
- (NSString*)getKeyChainTranscate;
//- (NSString*)getKeyChainUUID;
- (void)setKeyChainPrikey:(NSString*)pirvateKey;
- (NSString*)getKeyChainPrikey;
- (void)clearKeyChain;
@end

NS_ASSUME_NONNULL_END
