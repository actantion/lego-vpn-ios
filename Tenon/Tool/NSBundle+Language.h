//
//  NSBundle+Language.h
//  App内切换多语言
//
//  Created by 崇 on 2018.
//  Copyright © 2018年 崇. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GCLocalizedString(KEY) [[NSBundle mainBundle] localizedStringForKey:KEY value:nil table:@"Localizable"]

@interface NSBundle (Language)

+ (void)setLanguage:(NSString *)language;

@end
