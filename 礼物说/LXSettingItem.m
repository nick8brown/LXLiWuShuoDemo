//
//  LXSettingItem.m
//  网易彩票
//
//  Created by 曾令轩 on 15/12/7.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXSettingItem.h"

@implementation LXSettingItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title {
    LXSettingItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title {
    return [self itemWithIcon:nil title:title];
}

@end
