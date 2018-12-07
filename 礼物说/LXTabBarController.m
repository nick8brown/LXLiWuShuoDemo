//
//  LXTabBarController.m
//  网易彩票
//
//  Created by 曾令轩 on 15/11/19.
//  Copyright (c) 2015年 曾令轩. All rights reserved.
//

#import "LXTabBarController.h"
#import "LXTabBar.h"

@interface LXTabBarController () <LXTabBarDelegate>

@end

@implementation LXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.添加自己的tabbar
    LXTabBar *myTabBar = [[LXTabBar alloc] initWithFrame:self.tabBar.bounds];
    myTabBar.delegate = self;
    [self.tabBar addSubview:myTabBar];
    // 2.添加对应个数的按钮
    for (int i = 0; i < self.viewControllers.count; i++) {
        NSString *name = [NSString stringWithFormat:@"TabBar%d", i+1];
        NSString *selName = [NSString stringWithFormat:@"TabBar%dSel", i+1];
        [myTabBar addTabBarButtonWithName:name selName:selName];
    }
}

- (void)tabBar:(LXTabBar *)tabBar didSelectButtonFrom:(NSInteger)from to:(NSInteger)to {
    // 选中最新的控制器
    self.selectedIndex = to;
}

@end
