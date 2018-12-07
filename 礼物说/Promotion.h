//
//  Promotion.h
//  礼物说
//
//  Created by 曾令轩 on 15/11/29.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Promotion : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *target_url;
@property (nonatomic, copy) NSString *url;

+ (instancetype)promotionWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
