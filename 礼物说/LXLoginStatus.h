//
//  LXLoginStatus.h
//  礼物说
//
//  Created by 曾令轩 on 15/12/21.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXLoginStatus : NSObject
@property (nonatomic, assign) BOOL isLogin;

+ (instancetype)allocWithZone:(struct _NSZone *)zone;
+ (instancetype)shareLoginStatus;
@end
