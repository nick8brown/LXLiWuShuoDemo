//
//  LXGiftCell.h
//  礼物说
//
//  Created by 曾令轩 on 15/12/13.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXGiftCell : UITableViewCell
@property (nonatomic, strong) NSArray *categorys;
@property (nonatomic, strong) NSArray *subCategorys;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (instancetype)initWithTableView:(UITableView *)tableView;
@end
