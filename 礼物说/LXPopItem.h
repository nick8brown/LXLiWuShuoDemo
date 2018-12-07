//
//  LXPopItem.h
//  礼物说
//
//  Created by 曾令轩 on 15/12/8.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXPopItem : NSObject
@property (nonatomic, copy) NSString *cover_image_url;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, strong) NSNumber *favorites_count;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSArray *image_urls;
@property (nonatomic, copy) NSString *is_favorite;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, copy) NSString *purchase_url;
@property (nonatomic, copy) NSString *url;

+ (instancetype)itemWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
