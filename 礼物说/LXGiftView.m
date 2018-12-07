//
//  LXGiftView.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/9.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXGiftView.h"
#import "LXPopItem.h"
#import "UIColor+HtmlColor.h"

@interface LXGiftView () <UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *imgDatas;
@property (nonatomic, weak) UIScrollView *showView;
@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation LXGiftView

+ (instancetype)viewWithItem:(LXPopItem *)item {
    return [[[self class] alloc] initWithItem:item];
}

- (instancetype)initWithItem:(LXPopItem *)item {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 0, 560);
        self.backgroundColor = [UIColor whiteColor];
        // 图片数据
        self.imgDatas = [NSMutableArray arrayWithArray:item.image_urls];
        // 初始化展示视图
        [self setupViewWithItem:item];
    }
    return self;
}

#pragma mark - 展示视图
- (void)setupViewWithItem:(LXPopItem *)item {
    // showView
    if (item.image_urls.count != 1) {// scrollView
        [self setupShowView];
    } else {// imageView
        UIImageView *showView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, showView_WIDTH, showView_HEIGHT)];
        NSString *urlStr = [item.image_urls lastObject];
        showView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
        [self addSubview:showView];
    }
    // nameLabel
    CGFloat margin = 10;
    CGFloat nameLabelX = margin;
    CGFloat nameLabelY = showView_HEIGHT+margin;
    CGFloat nameLabelW = showView_WIDTH-2*margin;
    CGFloat nameLabelH = 40;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH)];
    nameLabel.text = item.name;
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.font = [UIFont systemFontOfSize:20];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:nameLabel];
    // priceLabel
    CGFloat priceLabelX = margin;
    CGFloat priceLabelY = CGRectGetMaxY(nameLabel.frame);
    CGFloat priceLabelW = showView_WIDTH-2*margin;
    CGFloat priceLabelH = 30;
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabelX, priceLabelY, priceLabelW, priceLabelH)];
    priceLabel.text = [NSString stringWithFormat:@"￥%@", item.price];
    priceLabel.textColor = [UIColor colorWithHexString:mainThemeHtmlColor];
    priceLabel.font = [UIFont systemFontOfSize:18];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:priceLabel];
    // describeLabel
    CGFloat describeLabelX = margin;
    CGFloat describeLabelY = CGRectGetMaxY(priceLabel.frame);
    CGFloat describeLabelW = showView_WIDTH-2*margin;
    CGFloat describeLabelH = self.frame.size.height-describeLabelY-2*margin;
    UILabel *describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(describeLabelX, describeLabelY, describeLabelW, describeLabelH)];
    describeLabel.text = item.describe;
    describeLabel.numberOfLines = 0;
    describeLabel.textColor = [UIColor darkGrayColor];
    describeLabel.font = [UIFont systemFontOfSize:15];
    describeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:describeLabel];
    // 分隔线
    CGFloat lineViewW = screenWIDTH;
    CGFloat lineViewH = 1;
    CGFloat lineViewX = 0;
    CGFloat lineViewY = CGRectGetMaxY(describeLabel.frame)+margin-lineViewH;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(lineViewX, lineViewY, lineViewW, lineViewH)];
    lineView.backgroundColor = lineColor_LX;
    [self addSubview:lineView];
    // bgView
    CGFloat bgViewX = 0;
    CGFloat bgViewY = CGRectGetMaxY(describeLabel.frame)+margin;
    CGFloat bgViewW = screenWIDTH;
    CGFloat bgViewH = margin;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH)];
    bgView.backgroundColor = bgColor;
    [self addSubview:bgView];
}

#pragma mark - 滚动视图
- (void)setupShowView {
    // 前后+1
    NSString *firstImg = [self.imgDatas firstObject];
    NSString *lastImg = [self.imgDatas lastObject];
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObject:lastImg];
    [tempArray addObjectsFromArray:self.imgDatas];
    [tempArray addObject:firstImg];
    self.imgDatas = tempArray;
    // scrollView
    UIScrollView *showView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, showView_WIDTH, showView_HEIGHT)];
    showView.contentSize = CGSizeMake(self.imgDatas.count*showView_WIDTH, showView_HEIGHT);
    showView.showsHorizontalScrollIndicator = NO;
    showView.pagingEnabled = YES;
    showView.bounces = NO;
    showView.delegate = self;
    [self addSubview:showView];
    self.showView = showView;
    // imageView
    for (int i = 0; i < self.imgDatas.count; i++) {
        CGFloat imageViewY = 0;
        CGFloat imageViewW = showView_WIDTH;
        CGFloat imageViewH = showView_HEIGHT;
        CGFloat imageViewX = i*imageViewW;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
        imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imgDatas[i]]]];
        [showView addSubview:imageView];
    }
    // pageControl
    CGFloat pageControlH = 30;
    CGFloat pageControlX = 0;
    CGFloat pageControlY = CGRectGetMaxY(showView.frame)-pageControlH;
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(pageControlX, pageControlY, 0, pageControlH)];
    pageControl.numberOfPages = self.imgDatas.count-2;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    // 显示第1页
    [showView scrollRectToVisible:CGRectMake(showView_WIDTH, 0, showView_WIDTH, showView_HEIGHT) animated:NO];
}
// pageControl
- (void)pageChange:(UIPageControl *)pageControl {
    NSInteger currentPage = pageControl.currentPage;
    [self.showView scrollRectToVisible:CGRectMake((currentPage+1)*showView_WIDTH, 0, showView_WIDTH, showView_HEIGHT) animated:NO];
}

#pragma mark - UIScrollViewDelegate
// scrollView滚动时调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentPage = scrollView.contentOffset.x/showView_WIDTH;
    self.pageControl.currentPage = currentPage-1;
}
// 减速完成（scrollView停止滚动）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = scrollView.contentOffset.x/showView_WIDTH;
    if (currentPage == 0) {
        [self.showView scrollRectToVisible:CGRectMake((self.imgDatas.count-2)*showView_WIDTH, 0, showView_WIDTH, showView_HEIGHT) animated:NO];
    } else if (currentPage == self.imgDatas.count-1) {
        [self.showView scrollRectToVisible:CGRectMake(showView_WIDTH, 0, showView_WIDTH, showView_HEIGHT) animated:NO];
    }
}

@end
