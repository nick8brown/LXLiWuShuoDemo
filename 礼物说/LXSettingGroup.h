//
//  LXSettingGroup.h
//  网易彩票
//
//  Created by 曾令轩 on 15/12/7.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXSettingGroup : NSObject
// 头部标题
@property (nonatomic, copy) NSString *header;
// 尾部标题
@property (nonatomic, copy) NSString *footer;
// 存放着这组所有行的模型数据（这个数组中都是LXSettingItem对象）
@property (nonatomic, strong) NSArray *items;
@end
