//
//  LXPopItem.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/8.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXPopItem.h"

@implementation LXPopItem

+ (instancetype)itemWithDictionary:(NSDictionary *)dict {
    return [[[self class] alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.cover_image_url = dict[@"cover_image_url"];
        self.describe = dict[@"description"];
        self.favorites_count = dict[@"favorites_count"];
        self.ID = dict[@"id"];
        self.image_urls = dict[@"image_urls"];
        self.is_favorite = dict[@"is_favorite"];
        self.name = dict[@"name"];
        self.price = dict[@"price"];
        self.purchase_url = dict[@"purchase_url"];
        self.url = dict[@"url"];
    }
    return self;
}

@end
