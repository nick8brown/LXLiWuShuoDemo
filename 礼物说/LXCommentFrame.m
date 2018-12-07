//
//  LXCommentFrame.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/10.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXCommentFrame.h"
#import "LXComment.h"
#import "LXCommentUser.h"

@implementation LXCommentFrame

- (void)setComment:(LXComment *)comment {
    _comment = comment;
    // 头像
    CGFloat avatarImgViewX = commentCellSpacing;
    CGFloat avatarImgViewY = commentCellSpacing;
    CGFloat avatarImgViewW = 35;
    CGFloat avatarImgViewH = avatarImgViewW;
    _avatarImgViewFrame = CGRectMake(avatarImgViewX, avatarImgViewY, avatarImgViewW, avatarImgViewH);
    // 昵称
    CGFloat nickNameLabelX = CGRectGetMaxX(_avatarImgViewFrame)+commentCellSpacing;
    CGFloat nickNameLabelY = avatarImgViewY;
    CGSize nickNameLabelSize = [comment.user.nickname sizeWithAttributes:@{NSFontAttributeName:CommentFont_Name}];
    _nickNameLabelFrame = (CGRect){{nickNameLabelX, nickNameLabelY}, nickNameLabelSize};
    // 时间
    CGSize createdAtLabelSize = [[NSString stringWithFormat:@"%@", comment.created_at] sizeWithAttributes:@{NSFontAttributeName:CommentFont_Time}];
    CGFloat createdAtLabelX = screenWIDTH-createdAtLabelSize.width-commentCellSpacing;
    CGFloat createdAtLabelY = nickNameLabelY;
    _createdAtLabelFrame = (CGRect){{createdAtLabelX, createdAtLabelY}, createdAtLabelSize};
    // 内容
    CGFloat contentLabelX = nickNameLabelX;
    CGFloat contentLabelY = MAX(CGRectGetMaxY(_nickNameLabelFrame), CGRectGetMaxY(_createdAtLabelFrame))+commentCellSpacing;
    NSString *content = nil;
    if (comment.replied_comment) {
        content = [NSString stringWithFormat:@"回复 %@: %@", comment.replied_user.nickname, comment.content];
    } else {
        content = comment.content;
    }
    CGSize contentLabelSize = [content boundingRectWithSize:CGSizeMake(screenWIDTH-contentLabelX-commentCellSpacing, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:CommentFont_Content} context:nil].size;
    _contentLabelFrame = (CGRect){{contentLabelX, contentLabelY}, contentLabelSize};
    // cell
    CGFloat cellH = CGRectGetMaxY(_contentLabelFrame)+commentCellSpacing;
    _cellHeight = cellH;
}

@end
