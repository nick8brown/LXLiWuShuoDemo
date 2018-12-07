//
//  LXFunctionCell.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/18.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXFunctionCell.h"

@implementation LXFunctionCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    return [[[self class] alloc] initWithTableView:tableView];
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        self = [tableView dequeueReusableCellWithIdentifier:FunctionCell_ID];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
