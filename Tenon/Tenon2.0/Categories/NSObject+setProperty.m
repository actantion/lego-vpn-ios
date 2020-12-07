//
//  UITableViewCell.m
//  PlayGame
//
//  Created by admin on 2020/10/30.
//

#import "NSObject+setProperty.h"
#import <objc/runtime.h>
@implementation NSObject(property)
- (BOOL)setPropertyValue:(id)propertyValue propertyName:(NSString *)propertyName {
    
    BOOL isPropertyExist= NO;
    unsigned int methodCount = 0;
    
    Ivar * ivars = class_copyIvarList([self class], &methodCount);
    for (unsigned int i = 0; i < methodCount; i ++) {
        Ivar ivar = ivars[i];
        const char * name = ivar_getName(ivar);
        const char * type = ivar_getTypeEncoding(ivar);
        NSString *tempPropertyName = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
        if([tempPropertyName isEqualToString:propertyName])
        {
            isPropertyExist = YES;
            object_setIvar(self, ivar,propertyValue);
            break;
        }
    }
    return isPropertyExist;
}
@end
