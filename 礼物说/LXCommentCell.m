//
//  LXCommentCell.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/10.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXCommentCell.h"
#import "LXComment.h"
#import "LXCommentUser.h"
#import "LXCommentFrame.h"
#import "UIImageView+WebCache.h"

@interface LXCommentCell ()
// 头像
@property (nonatomic, weak) UIImageView *avatarImgView;
// 昵称
@property (nonatomic, weak) UILabel *nickNameLabel;
// 内容
@property (nonatomic, weak) UILabel *contentLabel;
// 时间
@property (nonatomic, weak) UILabel *createdAtLabel;
@end

@implementation LXCommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    LXCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCell_ID];
    if (cell == nil) {
        cell = [[LXCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CommentCell_ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加评论内部的子控件
        [self setupSubviews];
    }
    return self;
}
// 添加评论内部的子控件
- (void)setupSubviews {
    // 头像
    UIImageView *avatarImgView = [[UIImageView alloc] init];
    [self.contentView addSubview:avatarImgView];
    self.avatarImgView = avatarImgView;
    // 昵称
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.font = CommentFont_Name;
    nickNameLabel.textColor = CommentTextColor_Name;
    nickNameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:nickNameLabel];
    self.nickNameLabel = nickNameLabel;
    // 内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = CommentFont_Content;
    contentLabel.textColor = CommentTextColor_Content;
    nickNameLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    // 时间
    UILabel *createdAtLabel = [[UILabel alloc] init];
    createdAtLabel.font = CommentFont_Time;
    createdAtLabel.textColor = CommentTextColor_Time;
    nickNameLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:createdAtLabel];
    self.createdAtLabel = createdAtLabel;
}

- (void)setCommentFrame:(LXCommentFrame *)commentFrame {
    _commentFrame = commentFrame;
    LXComment *comment = self.commentFrame.comment;
    LXCommentUser *user = comment.user;
    // 头像
    self.avatarImgView.frame = self.commentFrame.avatarImgViewFrame;
    self.avatarImgView.layer.cornerRadius = self.avatarImgView.frame.size.width*0.5;
    self.avatarImgView.clipsToBounds = YES;
    [self.avatarImgView setImageWithURL:[NSURL URLWithString:user.avatar_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    // 昵称
    self.nickNameLabel.frame = self.commentFrame.nickNameLabelFrame;
    self.nickNameLabel.text = user.nickname;
    // 内容
    self.contentLabel.frame = self.commentFrame.contentLabelFrame;
    NSString *content = nil;
    if (comment.replied_comment) {
        content = [NSString stringWithFormat:@"回复 %@: %@", comment.replied_user.nickname, comment.content];
    } else {
        content = comment.content;
    }
    self.contentLabel.text = content;
    // 时间
    self.createdAtLabel.frame = self.commentFrame.createdAtLabelFrame;
    self.createdAtLabel.text = [NSString stringWithFormat:@"%@", comment.created_at];
}

@end
