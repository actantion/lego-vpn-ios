//
//  UITableViewCell+loadCell.m
//  PlayGame
//
//  Created by admin on 2020/10/28.
//

#import "UITableView+loadCell.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation UITableView(LoadCell)
- (void)registCell:(NSString*)cellName
{
    [self registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellReuseIdentifier:cellName];
}
- (UITableViewCell*)reloadCell:(NSString*)cellName withModel:(UIBaseModel*)model withBlock:(__nullable success)block
{
    UITableViewCell* cell = [self dequeueReusableCellWithIdentifier:cellName];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setPropertyValue:block propertyName:@"_block"];
    SEL selector = NSSelectorFromString(@"setModel:");
    IMP imp = [cell methodForSelector:selector];
    id (*func)(id, SEL,UIBaseModel *) = (void *)imp;
    func(cell, selector,model);
    
    return cell;
}
@end




