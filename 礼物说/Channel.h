//
//  Channel.h
//  礼物说
//
//  Created by 曾令轩 on 15/11/27.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cover_image_url;
@property (nonatomic, copy) NSString *likes_count;
@property (nonatomic, copy) NSString *url;

+ (instancetype)channelWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
