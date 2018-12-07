//
//  LXEmptyCell.h
//  礼物说
//
//  Created by 曾令轩 on 15/12/18.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXEmptyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (instancetype)initWithTableView:(UITableView *)tableView;
@end
