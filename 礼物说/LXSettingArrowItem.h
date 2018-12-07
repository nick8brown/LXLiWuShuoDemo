//
//  LXSettingArrowItem.h
//  网易彩票
//
//  Created by 曾令轩 on 15/12/7.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXSettingItem.h"

@interface LXSettingArrowItem : LXSettingItem
// 点击这行cell需要跳转的控制器
@property (nonatomic, assign) Class destCtl;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title destCtl:(Class)destCtl;
+ (instancetype)itemWithTitle:(NSString *)title destCtl:(Class)destCtl;
@end
