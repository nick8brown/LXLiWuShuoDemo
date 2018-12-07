//
//  LXTabBar.m
//  网易彩票
//
//  Created by 曾令轩 on 15/11/19.
//  Copyright (c) 2015年 曾令轩. All rights reserved.
//

#import "LXTabBar.h"
#import "LXTabBarButton.h"

@interface LXTabBar ()
// 记录当前选中的按钮
@property (nonatomic, weak) UIButton *selectedButton;
@end

@implementation LXTabBar

- (void)addTabBarButtonWithName:(NSString *)name selName:(NSString *)selName {
    // 创建按钮
    LXTabBarButton *btn = [LXTabBarButton buttonWithType:UIButtonTypeCustom];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selName] forState:UIControlStateSelected];
    // 监听（手指一按下去就会触发这个事件）
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    // 添加
    [self addSubview:btn];
    // 默认选中第0个按钮
    if (self.subviews.count == 1) {
        [self btnClick:btn];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger count = self.subviews.count;
    for (int i = 0; i < count; i++) {
        LXTabBarButton *btn = self.subviews[i];
        btn.tag = i;
        // 设置frame
        CGFloat btnY = 0;
        CGFloat btnW = self.frame.size.width/count;
        CGFloat btnH = self.frame.size.height;
        CGFloat btnX = i *btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

// 监听按钮点击
- (void)btnClick:(UIButton *)sender {
    // 0.通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectButtonFrom:self.selectedButton.tag to:sender.tag];
    }
    // 1.让当前选中的按钮取消选中
    self.selectedButton.selected = NO;
    // 2.让新点击的按钮选中
    sender.selected = YES;
    // 3.新点击的按钮就成为了“当前选中的按钮”
    self.selectedButton = sender;
    
}

@end
