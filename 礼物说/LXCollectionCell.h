//
//  LXCollectionCell.h
//  礼物说
//
//  Created by 曾令轩 on 15/12/11.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXCollectionCell : UITableViewCell
@property (nonatomic, strong) NSArray *collections;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (instancetype)initWithTableView:(UITableView *)tableView;
@end
