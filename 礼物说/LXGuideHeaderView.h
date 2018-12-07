//
//  LXGuideHeaderView.h
//  礼物说
//
//  Created by 曾令轩 on 15/12/13.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXGuideHeaderView : UIView
+ (instancetype)viewWithSection:(NSInteger)section channelGroups:(NSArray *)channelGroups;
- (instancetype)initWithSection:(NSInteger)section channelGroups:(NSArray *)channelGroups;
@end
