//
//  LXFilterItemCell.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/16.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXFilterItemCell.h"
#import "LXFilterItem.h"
#import "NSString+Frame.h"
#import "UIColor+HtmlColor.h"
#import "UIImageView+WebCache.h"

@interface LXFilterItemCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCountLabel;
// 高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@end

@implementation LXFilterItemCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    return [[[self class] alloc] initWithCollectionView:collectionView indexPath:indexPath];
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    if (self = [super init]) {
        self = [collectionView dequeueReusableCellWithReuseIdentifier:FilterItemCell_ID forIndexPath:indexPath];
    }
    return self;
}

- (void)setItem:(LXFilterItem *)item {
    _item = item;
    [self.coverImgView setImageWithURL:[NSURL URLWithString:item.cover_image_url]];
    // 文字长度约束
    if (item.describe.length > 80) {
        self.describeLabel.text = [NSString stringWithFormat:@"%@...", [item.describe substringToIndex:80]];
    } else {
        self.describeLabel.text = item.describe;
    }
    self.describeLabel.numberOfLines = 0;
    self.describeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    // 高度约束
    self.heightConstraint.constant = [self.describeLabel.text heightWithFont:[UIFont systemFontOfSize:15] withinWidth:self.frame.size.width-2*8];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", item.price];
    self.priceLabel.textColor = [UIColor colorWithHexString:mainThemeHtmlColor];
    self.favoritesCountLabel.text = [NSString stringWithFormat:@"%@", item.favorites_count];
}

@end
