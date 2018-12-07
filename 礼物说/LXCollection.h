//
//  LXCollection.h
//  礼物说
//
//  Created by 曾令轩 on 15/12/11.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXCollection : NSObject
@property (nonatomic, copy) NSString *banner_image_url;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSNumber *posts_count;
@property (nonatomic, copy) NSString *title;
@end
