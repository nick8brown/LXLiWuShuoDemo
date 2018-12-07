//
//  LXButtonView.m
//  礼物说
//
//  Created by 曾令轩 on 15/11/29.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXButtonView.h"

@interface LXButtonView ()

@end

@implementation LXButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // buttonView
        [self createButtonView];
    }
    return self;
}

#pragma mark - 创建button视图
- (void)createButtonView {
    // imageView
    CGFloat verticalMargin = 5;
    CGFloat imageViewY = verticalMargin;
    CGFloat imageViewW = 60;
    CGFloat imageViewH = 60;
    CGFloat imageViewX = (self.frame.size.width-imageViewW)*0.5;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
    [self addSubview:imageView];
    self.iconImageView = imageView;
    // label
    CGFloat labelX = 0;
    CGFloat labelY = CGRectGetMaxY(imageView.frame);
    CGFloat labelW = self.frame.size.width;
    CGFloat labelH = 20;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    self.titleLabel = label;
}

@end
