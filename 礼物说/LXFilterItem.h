//
//  LXFilterItem.h
//  礼物说
//
//  Created by 曾令轩 on 15/12/16.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXFilterItem : NSObject
@property (nonatomic, copy) NSString *cover_image_url;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, strong) NSNumber *favorites_count;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *price;

+ (instancetype)itemWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
