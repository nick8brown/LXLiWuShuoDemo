//
//  LXFlowLayout.m
//  瀑布流2
//
//  Created by 曾令轩 on 15/12/16.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXFlowLayout.h"

@interface LXFlowLayout ()
{
    CGFloat itemW;
}
@property (nonatomic, strong) NSMutableArray *attrsArray;
@property (nonatomic, strong) NSMutableDictionary *maxYDict;
@end

@implementation LXFlowLayout

// 通过代码创建时，初始化一些设置
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.minimumInteritemSpacing = minimumSpacing;
        self.minimumLineSpacing = minimumSpacing;
        self.sectionInset = UIEdgeInsetsMake(minimumSpacing, minimumSpacing, minimumSpacing, minimumSpacing);
    }
    return self;
}

- (NSMutableArray *)attrsArray {
    if (_attrsArray == nil) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (NSMutableDictionary *)maxYDict {
    if (_maxYDict == nil) {
        _maxYDict = [NSMutableDictionary dictionary];
    }
    return _maxYDict;
}

// 布局前准备
- (void)prepareLayout {
    [super prepareLayout];
    // 重置最大y值
    for (int i = 0; i < self.colCount; i++) {
        self.maxYDict[[NSString stringWithFormat:@"%d", i]] = @(0);// 默认最大y值:0
    }
    // 清空属性数组
    [self.attrsArray removeAllObjects];
    // item总个数
    NSInteger itemsCount = [self.collectionView numberOfItemsInSection:0];// 这里只有1组
    // 添加item属性到attrsArray里
    for (int i = 0; i < itemsCount; i++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrsArray addObject:attrs];
    }
}

// 设置collectionView的ContentSize
- (CGSize)collectionViewContentSize {
    __block NSString *maxColumn = @"0";
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL * _Nonnull stop) {
        if ([maxY floatValue] > [self.maxYDict[maxColumn] floatValue]) {
            maxColumn = column;
        }
    }];
    return CGSizeMake(0, [self.maxYDict[maxColumn] floatValue]+self.sectionInset.bottom);
}

// 布局item
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 0.默认高度最小为第0列
    __block NSString *minColumn = @"0";
    // 1.查找高度最小的列
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL * _Nonnull stop) {
        if ([maxY floatValue] < [self.maxYDict[minColumn] floatValue]) {
            minColumn = column;
        }
    }];
    // 2.item的size
    itemW = (self.collectionView.frame.size.width-self.sectionInset.left-self.sectionInset.right-(self.colCount-1)*self.minimumInteritemSpacing)/self.colCount;
    CGFloat itemH = [self.delegate flowLayout:self heightForWidth:itemW atIndexPath:indexPath];
    // 3.item的orgin
    CGFloat itemX = self.sectionInset.left + [minColumn integerValue]*(itemW+self.minimumInteritemSpacing);
    CGFloat itemY = [self.maxYDict[minColumn] floatValue] + self.minimumLineSpacing;
    // 4.更新高度最小的列的最大y值
    self.maxYDict[minColumn] = @(itemY+itemH);
    // 5.创建属性（给frame赋值）
    UICollectionViewLayoutAttributes *itemAttrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    itemAttrs.frame = CGRectMake(itemX, itemY, itemW, itemH);
    return itemAttrs;
}

// 输出布局信息
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArray;
}

@end
