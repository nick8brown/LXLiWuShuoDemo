//
//  LXTableHeaderView.m
//  礼物说
//
//  Created by 曾令轩 on 15/11/27.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXTableHeaderView.h"
#import "LXButtonView.h"
#import "Promotion.h"

@interface LXTableHeaderView () <UIScrollViewDelegate>
// 网络数据
@property (nonatomic, strong) NSArray *bannersImgDatas;
// 旗帜广告视图
@property (nonatomic, weak) UIScrollView *ADScrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation LXTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // scrollView
        [self createScrollView];
        // buttonView
        [self createButtonView];
    }
    return self;
}

#pragma mark - 网络数据
// 旗帜广告
- (NSArray *)bannersImgDatas {
    if (_bannersImgDatas == nil) {
        NSURL *url = [NSURL URLWithString:banners_ImgDatasURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSArray *tempArray = tempDict[@"data"][@"banners"];
        NSMutableArray *imgArray = [NSMutableArray array];
        for (NSDictionary *dict in tempArray) {
            [imgArray addObject:dict[@"image_url"]];
        }
        _bannersImgDatas = imgArray;
    }
    return _bannersImgDatas;
}
// 宣传、推荐
- (NSArray *)promotionsImgDatas {
    if (_promotionsImgDatas == nil) {
        NSURL *url = [NSURL URLWithString:promotions_ImgDatasURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        _promotionsImgDatas = [self translateDataToModel:data];
    }
    return _promotionsImgDatas;
}
// 解析数据（json -> model）
- (NSArray *)translateDataToModel:(NSData *)data {
    NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSArray *tempArray = tempDict[@"data"][@"promotions"];
    NSMutableArray *itemsArray = [NSMutableArray array];
    NSMutableDictionary *modelDict = [NSMutableDictionary dictionary];
    for (NSDictionary *dict in tempArray) {
        [modelDict setObject:dict[@"title"] forKey:@"title"];
        [modelDict setObject:dict[@"icon_url"] forKey:@"icon_url"];
        [modelDict setObject:dict[@"target_url"] forKey:@"target_url"];
        Promotion *promotion = [Promotion promotionWithDictionary:modelDict];
        [itemsArray addObject:promotion];
        [modelDict removeAllObjects];
    }
    return itemsArray;
}

#pragma mark - 创建旗帜广告视图
- (void)createScrollView {
    // ADScrollView
    CGFloat ADScrollViewW = headerView_WIDTH;
    CGFloat ADScrollViewH = 150;
    UIScrollView *ADScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ADScrollViewW, ADScrollViewH)];
    ADScrollView.contentSize = CGSizeMake(self.bannersImgDatas.count*ADScrollViewW, ADScrollViewH);
    ADScrollView.showsHorizontalScrollIndicator = NO;
    ADScrollView.pagingEnabled = YES;
    ADScrollView.bounces = NO;
    ADScrollView.delegate = self;
    [self addSubview:ADScrollView];
    self.ADScrollView = ADScrollView;
    // imageView
    for (int i = 0; i < self.bannersImgDatas.count; i++) {
        CGFloat imageViewY = 0;
        CGFloat imageViewW = ADScrollViewW;
        CGFloat imageViewH = ADScrollViewH;
        CGFloat imageViewX = i*imageViewW;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
        imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.bannersImgDatas[i]]]];
        [ADScrollView addSubview:imageView];
    }
    // pageControl
    CGFloat pageControlW = 100;
    CGFloat pageControlH = 30;
    CGFloat pageControlX = (headerView_WIDTH-pageControlW)*0.5;
    CGFloat pageControlY = CGRectGetMaxY(ADScrollView.frame)-pageControlH;
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH)];
    pageControl.numberOfPages = self.bannersImgDatas.count;
    pageControl.currentPage = 0;
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    // timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(showAD) userInfo:nil repeats:YES];
}
// pageControl
- (void)pageChange:(UIPageControl *)pageControl {
    NSInteger currentPage = pageControl.currentPage;
    self.ADScrollView.contentOffset = CGPointMake(currentPage*ADScrollView_WIDTH, 0);
}
// timer
- (void)showAD {
    NSInteger currentPage = (self.pageControl.currentPage+1)%self.bannersImgDatas.count;
    self.ADScrollView.contentOffset = CGPointMake(currentPage*ADScrollView_WIDTH, 0);
    self.pageControl.currentPage = currentPage;
}

#pragma mark - 创建宣传、推荐视图
- (void)createButtonView {
    // btnView
    for (int i = 0; i < self.promotionsImgDatas.count; i++) {
        CGFloat btnViewY = CGRectGetMaxY(self.ADScrollView.frame);
        CGFloat btnViewW = headerView_WIDTH/self.promotionsImgDatas.count;
        CGFloat btnViewH = 90;
        CGFloat btnViewX = i*btnViewW;
        LXButtonView *btnView = [[LXButtonView alloc] initWithFrame:CGRectMake(btnViewX, btnViewY, btnViewW, btnViewH)];
        btnView.tag = 1000 + i;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [btnView addGestureRecognizer:tapGesture];
        [self addSubview:btnView];
    }
    // bottomView
    CGFloat bottomViewX = 0;
    CGFloat bottomViewW = headerView_WIDTH;
    CGFloat bottomViewH = 10;
    CGFloat bottomViewY = CGRectGetMaxY(self.frame)-bottomViewH;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH)];
    bottomView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    [self addSubview:bottomView];
}
// 点击手势
- (void)onTap:(UITapGestureRecognizer *)recognizer {
    NSInteger tag = recognizer.view.tag - 1000;
    NSDictionary *infoDict = @{@"tag":@(tag), @"data":self.promotionsImgDatas};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"haha" object:nil userInfo:infoDict];
}

#pragma mark - UIScrollViewDelegate
// 当手指点击scrollView时（准备滑动）
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
// 即将开始减速时调用
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.ADScrollView.contentOffset.x > (self.bannersImgDatas.count-1)*ADScrollView_WIDTH) {
        self.ADScrollView.contentOffset = CGPointMake(0, 0);
        self.pageControl.currentPage = 0;
    }
}
// 减速完成（scrollView停止滚动）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = scrollView.contentOffset.x/ADScrollView_WIDTH;
    self.pageControl.currentPage = currentPage;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(showAD) userInfo:nil repeats:YES];
}

@end
