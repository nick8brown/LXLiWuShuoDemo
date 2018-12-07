//
//  LXTabBar.h
//  网易彩票
//
//  Created by 曾令轩 on 15/11/19.
//  Copyright (c) 2015年 曾令轩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXTabBar;

@protocol LXTabBarDelegate <NSObject>
@optional
- (void)tabBar:(LXTabBar *)tabBar didSelectButtonFrom:(NSInteger)from to:(NSInteger)to;
@end

@interface LXTabBar : UIView
@property (nonatomic, weak) id <LXTabBarDelegate> delegate;

// 用来添加一个内部的按钮
- (void)addTabBarButtonWithName:(NSString *)name selName:(NSString *)selName;
@end
