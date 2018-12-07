//
//  LXLoginStatus.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/21.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXLoginStatus.h"

@implementation LXLoginStatus

static LXLoginStatus *instance;
+(instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+ (instancetype)shareLoginStatus {
    return [[self alloc] init];
}

@end
