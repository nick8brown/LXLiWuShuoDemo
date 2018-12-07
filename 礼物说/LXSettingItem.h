//
//  LXSettingItem.h
//  网易彩票
//
//  Created by 曾令轩 on 15/12/7.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LXSettingItemOption)();

@interface LXSettingItem : NSObject
// 图标
@property (nonatomic, copy) NSString *icon;
// 标题
@property (nonatomic, copy) NSString *title;
// 点击那个cell需要做什么事情
@property (nonatomic, copy) LXSettingItemOption option;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;
+ (instancetype)itemWithTitle:(NSString *)title;
@end
