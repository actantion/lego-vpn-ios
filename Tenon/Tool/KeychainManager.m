//
//  KeychainManager.m
//  TenonVPN
//
//  Created by admin on 2021/2/8.
//  Copyright © 2021 zly. All rights reserved.
//

#import "KeychainManager.h"


@implementation KeychainManager
+ (KeychainManager *)shareInstence {
    static KeychainManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[KeychainManager alloc] init];
        sharedManager.wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.tenon.tenonvpn" accessGroup:@"group.com.tenon.tenonvpn"];
    });
    return  sharedManager;
}
- (NSString*)getKeyChainReceipt{
    return [_wrapper objectForKey:(__bridge id)kSecAttrAccount];
}
- (NSInteger)getKeyChainType{
    return [[_wrapper objectForKey:(__bridge id)kSecAttrType] integerValue];
}

-(void)setKeyChainReceipt:(NSString*)receipt {
    [_wrapper setObject:receipt forKey:(__bridge id)kSecAttrAccount];
}
-(void)setKeyChainType:(NSInteger)Type {
    [_wrapper setObject:@(Type) forKey:(__bridge id)kSecAttrType];
}
- (void)setKeyChainTranscate:(NSString*)transcate{
    [_wrapper setObject:transcate forKey:(__bridge id)kSecAttrLabel];
}
- (NSString*)getKeyChainTranscate{
    NSString* ret = [NSString stringWithFormat:@"%@",[_wrapper objectForKey:(__bridge id)kSecAttrLabel]];
    return ret;
}
@end
