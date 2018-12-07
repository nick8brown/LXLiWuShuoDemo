//
//  LXNavigationController.m
//  网易彩票
//
//  Created by 曾令轩 on 15/11/19.
//  Copyright (c) 2015年 曾令轩. All rights reserved.
//

#import "LXNavigationController.h"

@interface LXNavigationController ()

@end

@implementation LXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

+ (void)initialize {
    // 设置导航栏主题
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setTintColor:[UIColor whiteColor]];
    // 设置背景图片
    [navBar setBackgroundImage:[UIImage imageNamed:@"navBar_0"] forBarMetrics:UIBarMetricsDefault];
    // 设置标题文字颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [navBar setTitleTextAttributes:attrs];
}

// 重写这个方法，能拦截所有的push操作
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:YES];
}

@end
