//
//  LXPopItemCell.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/8.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXPopItemCell.h"
#import "LXPopItem.h"
#import "UIColor+HtmlColor.h"

@interface LXPopItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCountLabel;
@end

@implementation LXPopItemCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    return [[[self class] alloc] initWithCollectionView:collectionView indexPath:indexPath];
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    if (self = [super init]) {
        self = [collectionView dequeueReusableCellWithReuseIdentifier:PopItemCell_ID forIndexPath:indexPath];
    }
    return self;
}

- (void)setItem:(LXPopItem *)item {
    _item = item;
    self.coverImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:item.cover_image_url]]];
    self.nameLabel.text = item.name;
    self.nameLabel.numberOfLines = 0;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", item.price];
    self.priceLabel.textColor = [UIColor colorWithHexString:mainThemeHtmlColor];
    self.favoritesCountLabel.text = [NSString stringWithFormat:@"%@", item.favorites_count];
}

@end
