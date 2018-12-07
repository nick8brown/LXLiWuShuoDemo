//
//  LXSettingCell.h
//  网易彩票
//
//  Created by 曾令轩 on 15/12/7.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXSettingItem;

@interface LXSettingCell : UITableViewCell
@property (nonatomic, strong) LXSettingItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
