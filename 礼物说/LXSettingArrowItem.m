//
//  LXSettingArrowItem.m
//  网易彩票
//
//  Created by 曾令轩 on 15/12/7.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXSettingArrowItem.h"

@implementation LXSettingArrowItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destCtl:(__unsafe_unretained Class)destCtl {
    LXSettingArrowItem *item = [self itemWithIcon:icon title:title];
    item.destCtl = destCtl;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title destCtl:(__unsafe_unretained Class)destCtl {
    return [self itemWithIcon:nil title:title destCtl:destCtl];
}

@end
