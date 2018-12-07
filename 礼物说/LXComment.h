//
//  LXComment.h
//  礼物说
//
//  Created by 曾令轩 on 15/12/10.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LXCommentUser;

@interface LXComment : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSNumber *created_at;
@property (nonatomic, strong) LXComment *replied_comment;
@property (nonatomic, strong) LXCommentUser *replied_user;
@property (nonatomic, strong) LXCommentUser *user;
@end
