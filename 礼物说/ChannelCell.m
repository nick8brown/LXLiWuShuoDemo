//
//  ChannelCell.m
//  礼物说
//
//  Created by 曾令轩 on 15/11/27.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "ChannelCell.h"
#import "Channel.h"

@interface ChannelCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIButton *likesCountButton;

- (IBAction)likesCountButtonClick:(UIButton *)sender;
@end

@implementation ChannelCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    return [[[self class] alloc] initWithTableView:tableView];
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        self = [tableView dequeueReusableCellWithIdentifier:cell_ID];
    }
    return self;
}

- (void)setChannel:(Channel *)channel {
    _channel = channel;
    self.titleLabel.text = channel.title;
    self.coverImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:channel.cover_image_url]]];
    [self.likesCountButton setTitle:[NSString stringWithFormat:@"❤️ %@", channel.likes_count] forState:UIControlStateNormal];
}

- (IBAction)likesCountButtonClick:(UIButton *)sender {
#warning todo likes_count+1，心的颜色由白变红，且页面切换不丢失
}

@end
