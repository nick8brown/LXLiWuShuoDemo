//
//  LXCategory.h
//  礼物说
//
//  Created by 曾令轩 on 15/12/13.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXCategory : NSObject
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *subcategories;
@end
