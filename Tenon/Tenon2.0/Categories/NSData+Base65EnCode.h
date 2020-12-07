//
//  NSData+Base65EnCode.h
//  CNUKwallet
//
//  Created by 黄焕林 on 2019/6/11.
//  Copyright © 2019 黄焕林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

void *NewBase64Decode(const char *inputBuffer, size_t length, size_t *outputLength);
char *NewBase64Encode(const void *inputBuffer, size_t length, bool separateLines, size_t *outputLength);

@interface NSData (Base65EnCode)

+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;

@end

NS_ASSUME_NONNULL_END
