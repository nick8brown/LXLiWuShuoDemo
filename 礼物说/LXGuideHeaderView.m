//
//  LXGuideHeaderView.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/13.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXGuideHeaderView.h"
#import "LXChannelGroup.h"

@implementation LXGuideHeaderView

+ (instancetype)viewWithSection:(NSInteger)section channelGroups:(NSArray *)channelGroups {
    return [[[self class] alloc] initWithSection:section channelGroups:channelGroups];
}

- (instancetype)initWithSection:(NSInteger)section channelGroups:(NSArray *)channelGroups {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 0, toolbarH);
        self.backgroundColor = [UIColor whiteColor];
        // 初始化子控件
        [self setupSubviewsWithSection:section channelGroups:channelGroups];
    }
    return self;
}
// 初始化子控件
- (void)setupSubviewsWithSection:(NSInteger)section channelGroups:(NSArray *)channelGroups {
    // title
    CGFloat titleLabelX = minimumSpacing;
    CGFloat titleLabelY = minimumSpacing;
    CGFloat titleLabelW = 60;
    CGFloat titleLabelH = 30;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH)];
    titleLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:titleLabel];
    if (!section) {
        // title
        titleLabel.text = @"专题";
        // check
        CGFloat checkLabelW = 2*titleLabelW;
        CGFloat checkLabelH = titleLabelH;
        CGFloat checkLabelX = screenWIDTH-checkLabelW-minimumSpacing;
        CGFloat checkLabelY = titleLabelY;
        UILabel *checkLabel = [[UILabel alloc] initWithFrame:CGRectMake(checkLabelX, checkLabelY, checkLabelW, checkLabelH)];
        checkLabel.text = @"查看全部>";
        checkLabel.font = [UIFont systemFontOfSize:13];
        checkLabel.textColor = [UIColor lightGrayColor];
        checkLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:checkLabel];
    } else {
        // title
        LXChannelGroup *group = channelGroups[section-1];
        titleLabel.text = group.name;
    }
}

@end
