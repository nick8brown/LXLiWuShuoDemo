//
//  LXChannel.h
//  礼物说
//
//  Created by 曾令轩 on 15/12/11.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXChannel : NSObject
@property (nonatomic, strong) NSNumber *group_id;
@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *items_count;
@property (nonatomic, copy) NSString *name;
@end
