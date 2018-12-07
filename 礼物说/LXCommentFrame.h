//
//  LXCommentFrame.h
//  礼物说
//
//  Created by 曾令轩 on 15/12/10.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@class LXComment;

@interface LXCommentFrame : NSObject
// 评论
@property (nonatomic, strong) LXComment *comment;
// 头像
@property (nonatomic, assign, readonly) CGRect avatarImgViewFrame;
// 昵称
@property (nonatomic, assign, readonly) CGRect nickNameLabelFrame;
// 内容
@property (nonatomic, assign, readonly) CGRect contentLabelFrame;
// 时间
@property (nonatomic, assign, readonly) CGRect createdAtLabelFrame;
// cell
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@end
