//
//  LXChannelCell.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/13.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXChannelCell.h"
#import "LXChannel.h"
#import "UIImageView+WebCache.h"

@interface LXChannelCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation LXChannelCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    return [[[self class] alloc] initWithCollectionView:collectionView indexPath:indexPath];
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    if (self = [super init]) {
        self = [collectionView dequeueReusableCellWithReuseIdentifier:ChannelCell_ID forIndexPath:indexPath];
    }
    return self;
}

- (void)setChannel:(LXChannel *)channel {
    _channel = channel;
    [self.iconImgView setImageWithURL:[NSURL URLWithString:channel.icon_url]];
    self.nameLabel.text = channel.name;
}

@end
