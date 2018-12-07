//
//  LXPresentCell.h
//  礼物说
//
//  Created by 曾令轩 on 15/12/10.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXPopItem;

@interface LXPresentCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView item:(LXPopItem *)item;
- (instancetype)initWithTableView:(UITableView *)tableView item:(LXPopItem *)item;
@end
