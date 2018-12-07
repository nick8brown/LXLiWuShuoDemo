//
//  ChannelCell.h
//  礼物说
//
//  Created by 曾令轩 on 15/11/27.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Channel;

@interface ChannelCell : UITableViewCell
@property (nonatomic, strong) Channel *channel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (instancetype)initWithTableView:(UITableView *)tableView;
@end
