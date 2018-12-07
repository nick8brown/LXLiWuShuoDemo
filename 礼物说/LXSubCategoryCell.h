//
//  LXSubCategoryCell.h
//  礼物说
//
//  Created by 曾令轩 on 15/12/14.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXSubCategory;

@interface LXSubCategoryCell : UICollectionViewCell
@property (nonatomic, strong) LXSubCategory *subCategory;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
@end
