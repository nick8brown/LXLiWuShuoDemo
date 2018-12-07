//
//  LXSubCategoryCell.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/14.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXSubCategoryCell.h"
#import "LXSubCategory.h"
#import "UIImageView+WebCache.h"

@interface LXSubCategoryCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation LXSubCategoryCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    return [[[self class] alloc] initWithCollectionView:collectionView indexPath:indexPath];
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    if (self = [super init]) {
        self = [collectionView dequeueReusableCellWithReuseIdentifier:SubCategoryCell_ID forIndexPath:indexPath];
    }
    return self;
}

- (void)setSubCategory:(LXSubCategory *)subCategory {
    _subCategory = subCategory;
    [self.iconImgView setImageWithURL:[NSURL URLWithString:subCategory.icon_url]];
    self.nameLabel.text = subCategory.name;
}

@end
