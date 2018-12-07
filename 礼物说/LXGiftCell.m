//
//  LXGiftCell.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/13.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXGiftCell.h"
#import "LXCategory.h"
#import "LXSubCategory.h"
#import "LXSubCategoryHeaderView.h"
#import "LXSubCategoryCell.h"
#import "UIColor+HtmlColor.h"

@interface LXGiftCell () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIScrollView *navScrollView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UICollectionView *giftCollectionView;
@property (nonatomic, strong) NSMutableArray *sectionHsArray;
@property (nonatomic, strong) NSMutableArray *tapGesturesArray;
@property (nonatomic, weak) UIView *preView;
@property (nonatomic, assign) BOOL isNavScrollViewScroll;
@end

@implementation LXGiftCell

- (NSMutableArray *)sectionHsArray {
    if (_sectionHsArray == nil) {
        _sectionHsArray = [NSMutableArray array];
        for (int i = 0; i < self.categorys.count; i++) {
            NSInteger row = [self numberOfRowsInCollectionViewWithChannelsCount:[self.subCategorys[i] count]];
            CGFloat sectionH = row*subCategoryCell_HEIGHT;
            [self.sectionHsArray addObject:@(sectionH)];
        }
    }
    return _sectionHsArray;
}
// 计算collectionView的行数
- (NSInteger)numberOfRowsInCollectionViewWithChannelsCount:(NSInteger)count {
    if (count%3) {
        return count/3+1;
    } else {
        return count/3;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    return [[[self class] alloc] initWithTableView:tableView];
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        self = [tableView dequeueReusableCellWithIdentifier:GiftCell_ID];
    }
    return self;
}

- (void)setCategorys:(NSArray *)categorys {
    _categorys = categorys;
    if (!self.preView) {
        if (categorys) {
            // 初始化侧边导航栏
            [self setupNavScrollView];
            // 默认选中第1项
            [self selectObject:[self.tapGesturesArray firstObject]];
            // 初始化分类页
            [self setupGiftCollectionView];
        }
    }
}
// 选中某1项
- (void)selectObject:(UITapGestureRecognizer *)tap {
    [self setPreView:self.preView andCurrentView:tap.view];
    self.preView = tap.view;
}

#pragma mark - 侧边导航栏
- (void)setupNavScrollView {
    self.navScrollView.contentSize = CGSizeMake(navScrollView_WIDTH, self.categorys.count*categoryItem_HEIGHT);
    self.tapGesturesArray = [NSMutableArray array];
    for (int i = 0; i < self.categorys.count; i++) {
        // 导航按钮
        CGFloat categoryItemViewY = i*categoryItem_HEIGHT;
        UIView *categoryItemView = [[UIView alloc] initWithFrame:CGRectMake(0, categoryItemViewY, categoryItem_WIDTH, categoryItem_HEIGHT)];
        categoryItemView.tag = 100+i;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [categoryItemView addGestureRecognizer:tapGesture];
        [self.tapGesturesArray addObject:tapGesture];
        [self.navScrollView addSubview:categoryItemView];
        // 标题
        CGFloat nameLabelX = selectedView_WIDTH;
        CGFloat nameLabelY = minimumSpacing;
        CGFloat nameLabelW = categoryItem_WIDTH-nameLabelX;
        CGFloat nameLabelH = categoryItem_HEIGHT-2*nameLabelY;
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH)];
        LXCategory *category = self.categorys[i];
        nameLabel.text = category.name;
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.textColor = [UIColor darkGrayColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [categoryItemView addSubview:nameLabel];
    }
}

#pragma mark - 点击手势
- (void)onTap:(UITapGestureRecognizer *)recognizer {
    self.isNavScrollViewScroll = YES;
    if (self.preView) {
        // 设置前一个view、当前选中view
        [self setPreView:self.preView andCurrentView:recognizer.view];
    }
    self.preView = recognizer.view;
    // 滚动至对应组
    [self scrollToSectionWithRecognizer:recognizer];
}
// 设置前一个view、当前选中view
- (void)setPreView:(UIView *)preView andCurrentView:(UIView *)currentView {
    // 前一个view
    preView.backgroundColor = [UIColor clearColor];
    [[preView viewWithTag:selectedView_TAG] removeFromSuperview];
    [self labelSetTextColor:[UIColor darkGrayColor] inView:preView];
    // 当前选中view
    currentView.backgroundColor = [UIColor whiteColor];
    // 创建选中标记
    [currentView addSubview:[self createSelectedView]];
    // 设置标题颜色
    [self labelSetTextColor:[UIColor colorWithHexString:mainThemeHtmlColor] inView:currentView];
}
// 创建选中标记
- (UIView *)createSelectedView {
    CGFloat selectedViewX = 0;
    CGFloat selectedViewY = 0;
    CGFloat selectedViewW = selectedView_WIDTH;
    CGFloat selectedViewH = categoryItem_HEIGHT;
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(selectedViewX, selectedViewY, selectedViewW, selectedViewH)];
    selectedView.backgroundColor = [UIColor redColor];
    selectedView.tag = selectedView_TAG;
    return selectedView;
}
// 设置标题颜色
- (void)labelSetTextColor:(UIColor *)color inView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            UILabel *nameLabel = (UILabel *)subview;
            nameLabel.textColor = color;
        }
    }
}
// 滚动至对应组
- (void)scrollToSectionWithRecognizer:(UITapGestureRecognizer *)recognizer {
    for (int i = 0; i < self.tapGesturesArray.count; i++) {
        if (recognizer == self.tapGesturesArray[i]) {
            [self.giftCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }
    }
}

#pragma mark - 分类页
- (void)setupGiftCollectionView {
    // 设置流水布局
    [self setupFlowLayout];
    // 注册cell
    [self.giftCollectionView registerNib:[UINib nibWithNibName:@"LXSubCategoryCell" bundle:nil] forCellWithReuseIdentifier:SubCategoryCell_ID];
    // 注册supplementaryView
    [self.giftCollectionView registerNib:[UINib nibWithNibName:@"LXSubCategoryHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SubCategoryHeaderView_ID];
    [self.giftCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeaderView"];
    [self.giftCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SectionFooterView"];
    // 代理
    self.giftCollectionView.dataSource = self;
    self.giftCollectionView.delegate = self;
}
// 设置流水布局
- (void)setupFlowLayout {
    self.layout.itemSize = CGSizeMake(subCategoryCell_WIDTH, subCategoryCell_HEIGHT);
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
}

#pragma mark - UICollectionViewDataSource
// 组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.categorys.count;
}
// 项数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *subCategorysArray = self.subCategorys[section];
    return subCategorysArray.count;
}
// cell样式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LXSubCategoryCell *cell = [LXSubCategoryCell cellWithCollectionView:collectionView indexPath:indexPath];
    NSArray *subCategorysArray = self.subCategorys[indexPath.section];
    cell.subCategory = subCategorysArray[indexPath.item];
    return cell;
}
// 补充视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {// 组头视图
        if (indexPath.section) {
            LXSubCategoryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SubCategoryHeaderView_ID forIndexPath:indexPath];
            LXCategory *category = self.categorys[indexPath.section];
            headerView.nameLabel.text = category.name;
            return headerView;
        } else {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeaderView" forIndexPath:indexPath];
            return headerView;
        }
    } else {// 组尾视图
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"SectionFooterView" forIndexPath:indexPath];
        return footerView;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
// 组头高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section) {
        return CGSizeMake(giftCollectionView_WIDTH, subCategoryHeaderView_HEIGHT);
    } else {
        return CGSizeMake(giftCollectionView_WIDTH, CGFLOAT_MIN);
    }
}

#define mark - UIScrollViewDelegate
// scrollView滚动时调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.isNavScrollViewScroll = NO;
}
// 当手指点击scrollView时（准备滑动）
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (!self.isNavScrollViewScroll) {
        [self scrollViewDidScrollWithContentOffsetY:scrollView.contentOffset.y];
    }
}
// 1.
- (void)scrollViewDidScrollWithContentOffsetY:(CGFloat)contentOffsetY {
    if (contentOffsetY > [self.sectionHsArray[0] floatValue]) {
        for (int i = 0; i < self.sectionHsArray.count; i++) {
            [self setPreViewAndCurrentViewWithContentOffsetY:contentOffsetY index:i];
            contentOffsetY -= ([self.sectionHsArray[i] floatValue]+subCategoryHeaderView_HEIGHT);
        }
    } else {
        if (self.preView) {
            [self setPreView:self.preView andCurrentView:[self.tapGesturesArray[0] view]];
        }
        self.preView = [self.tapGesturesArray[0] view];
        [self.navScrollView scrollRectToVisible:CGRectMake(0, 0, categoryItem_WIDTH, categoryItem_HEIGHT) animated:NO];
    }
}
// 2.
- (void)setPreViewAndCurrentViewWithContentOffsetY:(CGFloat)contentOffsetY index:(NSInteger)index {
    if (contentOffsetY > [self.sectionHsArray[index] floatValue]) {
        if (index < self.sectionHsArray.count-1) {
            if (self.preView) {
                [self setPreView:self.preView andCurrentView:[self.tapGesturesArray[index+1] view]];
            }
            self.preView = [self.tapGesturesArray[index+1] view];
        }
        if ([UIScreen mainScreen].bounds.size.height == 667) {
            if (index < (self.sectionHsArray.count/2-1)) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.navScrollView.contentOffset = CGPointMake(0, (index+1)*categoryItem_HEIGHT);
                }];
            }
        } else {
            if (index < (self.sectionHsArray.count/2+1)) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.navScrollView.contentOffset = CGPointMake(0, (index+1)*categoryItem_HEIGHT);
                }];
            }
        }
    }
}

@end
