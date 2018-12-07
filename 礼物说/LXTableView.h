//
//  LXTableView.h
//  礼物说
//
//  Created by 曾令轩 on 15/11/27.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LXTableViewDelegate;

@interface LXTableView : UITableView
// 网络数据
@property (nonatomic, strong) NSArray *channelsItems;
@end
