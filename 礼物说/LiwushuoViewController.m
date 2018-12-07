//
//  LiwushuoViewController.m
//  礼物说
//
//  Created by 曾令轩 on 15/11/25.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LiwushuoViewController.h"
#import "LXLoginViewController.h"
#import "LXDailySignInViewController.h"
#import "LXTableView.h"
#import "LXTableHeaderView.h"
#import "LXButtonView.h"
#import "Promotion.h"
#import "Channel.h"
#import "WebViewController.h"
#import "SearchViewController.h"

@interface LiwushuoViewController () <UIScrollViewDelegate>
// 导航栏
@property (weak, nonatomic) IBOutlet UIScrollView *navScrollView;
@property (weak, nonatomic) IBOutlet UIButton *navButton;
@property (nonatomic, strong) NSMutableArray *navViews;
@property (nonatomic, strong) UIButton *preBtn;
@property (nonatomic, assign) BOOL isSelectMore;
// 页面
@property (weak, nonatomic) IBOutlet UIScrollView *pageScrollView;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (nonatomic, strong) LXTableHeaderView *headerView;

- (IBAction)dailySignIn:(UIBarButtonItem *)sender;
- (IBAction)easySearch:(UIBarButtonItem *)sender;
- (IBAction)navViewChange:(UIButton *)sender;
@end

@implementation LiwushuoViewController
{
    NSArray *navItems;
    NSArray *channels;
    NSArray *colorsArray;
    NSURLSession *session;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isSelectMore = NO;
    navItems = @[@"精选", @"海淘", @"礼物", @"美食", @"数码", @"运动", @"涨姿势"];
    channels = @[@100, @129, @111, @118, @121, @123, @120];
    UIColor *color_0 = [UIColor colorWithRed:166/255.0 green:205/255.0 blue:76/255.0 alpha:1];
    UIColor *color_1 = [UIColor colorWithRed:235/255.0 green:137/255.0 blue:136/255.0 alpha:1];
    UIColor *color_2 = [UIColor colorWithRed:146/255.0 green:155/255.0 blue:252/255.0 alpha:1];
    UIColor *color_3 = [UIColor colorWithRed:228/255.0 green:115/255.0 blue:155/255.0 alpha:1];
    colorsArray = @[color_0, color_1, color_2, color_3];
    session = [NSURLSession sharedSession];
    // 初始化导航栏
    [self initialNavScrollView];
    // 初始化页面
    [self initialPageScrollView];
    // 默认加载第1页数据
    [self loadPage:0];
    // 监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadWebView:) name:WEBVIEW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPromotionWebView:) name:@"haha" object:nil];
}
// 回调方法
- (void)loadWebView:(NSNotification *)notification {
    WebViewController *webViewCtl = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webViewCtl.urlStr = notification.userInfo[@"url"];
    [self.navigationController pushViewController:webViewCtl animated:YES];
}
- (void)loadPromotionWebView:(NSNotification *)notification {
    NSInteger tag = [notification.userInfo[@"tag"] integerValue];
    Promotion *promotion = notification.userInfo[@"data"][tag];
    WebViewController *webViewCtl = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webViewCtl.titleStr = promotion.title;
    webViewCtl.urlStr = promotion.target_url;
    [self.navigationController pushViewController:webViewCtl animated:YES];
}

#pragma mark - 导航栏
- (void)initialNavScrollView {
    CGFloat multiple = (CGFloat)navItems.count/maximumNumberOfNavItems;
    self.navScrollView.contentSize = CGSizeMake(multiple*navScrollView_WIDTH, navScrollView_HEIGHT);
    self.navScrollView.showsHorizontalScrollIndicator = NO;
    // 添加按钮
    self.navViews = [NSMutableArray array];
    for (int i = 0; i < navItems.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnY = 0;
#warning todo 显示5个按钮，宽度待改
        CGFloat btnW = navScrollView_WIDTH/maximumNumberOfNavItems;
        CGFloat btnH = navScrollView_HEIGHT;
        CGFloat btnX = i*btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setTitle:navItems[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
        [self.navViews addObject:btn];
        [self.navScrollView addSubview:btn];
    }
}

#pragma mark - 页面
- (void)initialPageScrollView {
    self.pageScrollView.contentSize = CGSizeMake(navItems.count*pageScrollView_WIDTH, pageScrollView_HEIGHT);
    self.pageScrollView.showsHorizontalScrollIndicator = NO;
    self.pageScrollView.showsVerticalScrollIndicator = NO;
    self.pageScrollView.pagingEnabled = YES;
    self.pageScrollView.delegate = self;
    // 添加tableView
    self.pageViews = [NSMutableArray array];
    for (int i = 0; i < navItems.count; i++) {
        CGFloat tableViewY = 0;
        CGFloat tableViewW = pageScrollView_WIDTH;
        CGFloat tableViewH = pageScrollView_HEIGHT;
        CGFloat tableViewX = i*tableViewW;
        LXTableView *tableView = [[LXTableView alloc] initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH) style:UITableViewStylePlain];
        if (i == 0) {
            CGFloat headerViewW = tableViewW;
            CGFloat headerViewH = 250;
            LXTableHeaderView *headerView = [[LXTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, headerViewW, headerViewH)];
            tableView.tableHeaderView = headerView;
            self.headerView = headerView;
        }
        [self.pageViews addObject:tableView];
        [self.pageScrollView addSubview:tableView];
    }
}

#pragma mark - 加载数据
// 页面切换
- (void)changePage:(UIButton *)sender {
    NSInteger currentPage = sender.tag - 1000;
    [self loadPage:currentPage];
    self.pageScrollView.contentOffset = CGPointMake(currentPage*pageScrollView_WIDTH, 0);
}
// 加载当前页
- (void)loadPage:(NSInteger)currentPage {
    // 显示当前页在导航栏的位置
    [self markCurrentPage:currentPage];
    // 加载btnView
    for (UIView *view in self.headerView.subviews) {
        if ([view isKindOfClass:[LXButtonView class]]) {
            LXButtonView *btnView = (LXButtonView *)view;
            NSInteger i = btnView.tag - 1000;
            Promotion *promotion = self.headerView.promotionsImgDatas[i];
            NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:promotion.icon_url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    btnView.iconImageView.image = [UIImage imageWithData:data];
                });
            }];
            [dataTask resume];
            btnView.titleLabel.text = promotion.title;
            btnView.titleLabel.textColor = colorsArray[i];
        }
    }
    // 页面数据
    NSString *urlStr = [NSString stringWithFormat:@"http://api.liwushuo.com/v2/channels/%@/items?ad=2&gender=1&generation=1&limit=20&offset=0", channels[currentPage]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        LXTableView *currentTableView = self.pageViews[currentPage];
        currentTableView.channelsItems = [self translateDataToModel:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [currentTableView reloadData];
        });
    }];
    [dataTask resume];
}
// 标记当前页标题颜色
- (void)markCurrentPage:(NSInteger)currentPage {
    if (self.preBtn) {
        [self.preBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    [self.navViews[currentPage] setTitleColor:[UIColor colorWithRed:228/255.0 green:81/255.0 blue:96/255.0 alpha:1] forState:UIControlStateNormal];
    self.preBtn = self.navViews[currentPage];
}
// 解析数据（json -> model）
- (NSArray *)translateDataToModel:(NSData *)data {
    NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSArray *tempArray = tempDict[@"data"][@"items"];
    NSMutableArray *itemsArray = [NSMutableArray array];
    NSMutableDictionary *modelDict = [NSMutableDictionary dictionary];
    for (NSDictionary *dict in tempArray) {
        if (dict[@"title"] && dict[@"cover_image_url"] && dict[@"likes_count"] && dict[@"url"]) {
            [modelDict setObject:dict[@"title"] forKey:@"title"];
            [modelDict setObject:dict[@"cover_image_url"] forKey:@"cover_image_url"];
            [modelDict setObject:[NSString stringWithFormat:@"%@", dict[@"likes_count"]] forKey:@"likes_count"];
            [modelDict setObject:dict[@"url"] forKey:@"url"];
            Channel *channel = [Channel channelWithDictionary:modelDict];
            [itemsArray addObject:channel];
            [modelDict removeAllObjects];
        }
    }
    return itemsArray;
}

#pragma mark - IBAction
// 每日签到
- (IBAction)dailySignIn:(UIBarButtonItem *)sender {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user objectForKey:loginStatus_isLogin]) {
        LXDailySignInViewController *dailySignInCtl = [[LXDailySignInViewController alloc] initWithNibName:@"LXDailySignInViewController" bundle:nil];
        [self.navigationController pushViewController:dailySignInCtl animated:YES];
    } else {
        LXLoginViewController *loginCtl = [[LXLoginViewController alloc] initWithNibName:@"LXLoginViewController" bundle:nil];
        loginCtl.preCtl = self;
        [self presentViewController:loginCtl animated:YES completion:nil];
    }
}
// 搜索
- (IBAction)easySearch:(UIBarButtonItem *)sender {
    SearchViewController *searchViewCtl = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewCtl animated:YES];
}
// 选择更多
- (IBAction)navViewChange:(UIButton *)sender {
    if (!self.isSelectMore) {
        [UIView animateWithDuration:0.5 animations:^{
            self.navScrollView.contentOffset = CGPointMake((navItems.count-maximumNumberOfNavItems)*navItem_WIDTH, 0);
        } completion:^(BOOL finished) {
            self.isSelectMore = YES;
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.navScrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            self.isSelectMore = NO;
        }];
    }
}

#pragma mark - UIScrollViewDelegate
// 减速完成（scrollView停止滚动）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = scrollView.contentOffset.x/pageScrollView_WIDTH;
    if (currentPage < maximumNumberOfNavItems) {
        self.navScrollView.contentOffset = CGPointMake(0, 0);
    } else {
        self.navScrollView.contentOffset = CGPointMake((currentPage-maximumNumberOfNavItems+1)*navItem_WIDTH, 0);
    }
    [self loadPage:currentPage];
}

@end
