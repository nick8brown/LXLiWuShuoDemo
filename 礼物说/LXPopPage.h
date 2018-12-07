//
//  LXPopPage.h
//  礼物说
//
//  Created by 曾令轩 on 15/12/8.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXPopPage : NSObject
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) NSString *next_url;

+ (instancetype)pageWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
