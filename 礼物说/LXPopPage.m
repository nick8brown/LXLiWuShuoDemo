//
//  LXPopPage.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/8.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXPopPage.h"

@implementation LXPopPage

+ (instancetype)pageWithDictionary:(NSDictionary *)dict {
    return [[[self class] alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.items = dict[@"items"];
        self.next_url = dict[@"paging"][@"next_url"];
    }
    return self;
}

@end
