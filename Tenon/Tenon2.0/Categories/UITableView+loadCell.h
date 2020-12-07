//
//  UITableViewCell+loadCell.h
//  PlayGame
//
//  Created by admin on 2020/10/28.
//

#import <Foundation/Foundation.h>
typedef void(^success) (id _Nullable value);

NS_ASSUME_NONNULL_BEGIN

@interface UITableView(LoadCell)
- (void)registCell:(NSString*)cellName;
- (UITableViewCell*)reloadCell:(NSString*)cellName withModel:(UIBaseModel*)model withBlock:(__nullable success)block;

@end

NS_ASSUME_NONNULL_END
