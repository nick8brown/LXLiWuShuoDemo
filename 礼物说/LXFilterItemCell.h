//
//  LXFilterItemCell.h
//  礼物说
//
//  Created by 曾令轩 on 15/12/16.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXFilterItem;

@interface LXFilterItemCell : UICollectionViewCell
@property (nonatomic, strong) LXFilterItem *item;

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
@end
