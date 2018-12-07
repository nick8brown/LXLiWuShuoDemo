//
//  LXGuideViewController.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/11.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXGuideViewController.h"
#import "LXSelectGiftViewController.h"
#import "LXCollection.h"
#import "LXChannelGroup.h"
#import "LXChannel.h"
#import "LXCategory.h"
#import "LXSubCategory.h"
#import "LXGuideHeaderView.h"
#import "LXGiftHeaderView.h"
#import "LXCollectionCell.h"
#import "LXChannelGroupCell.h"
#import "LXGiftCell.h"
#import "SearchViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"

@interface LXGuideViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *guideSegmentedControl;
@property (nonatomic, assign) BOOL isGuide;
@property (nonatomic, strong) NSArray *collections;
@property (nonatomic, strong) NSArray *channelGroups;
@property (nonatomic, strong) NSArray *channels;
@property (nonatomic, strong) NSArray *categorys;
@property (nonatomic, strong) NSArray *subCategorys;

- (IBAction)guideValueChange:(UISegmentedControl *)sender;
@end

@implementation LXGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -minimumSpacing, 0);
    // 注册cell
    [self.tableView registerClass:[LXCollectionCell class] forCellReuseIdentifier:CollectionCell_ID];
    [self.tableView registerClass:[LXChannelGroupCell class] forCellReuseIdentifier:ChannelGroupCell_ID];
    [self.tableView registerNib:[UINib nibWithNibName:@"LXGiftCell" bundle:nil] forCellReuseIdentifier:GiftCell_ID];
    // 默认展示攻略页
    self.isGuide = YES;
    // 加载专题栏数据
    [self setupTopicDatas];
    // 加载分类栏数据
    [self setupChannelGroupDatas];
    // 加载侧边导航栏数据
    [self setupCategoryDatas];
}

#pragma mark - 加载专题栏数据
- (void)setupTopicDatas {
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 2.发送请求
    [manager GET:Collection_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"-----【分类】-----【加载专题栏数据】-----【成功】-----");
        // 将字典数组转为模型数组（里面放的就是LXCollection模型）
        self.collections = [LXCollection objectArrayWithKeyValuesArray:responseObject[@"data"][@"collections"]];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-----【分类】-----【加载专题栏数据】-----【失败】-----");
    }];
}

#pragma mark - 加载分类栏数据
- (void)setupChannelGroupDatas {
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 2.发送请求
    [manager GET:Channel_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"-----【分类】-----【加载分类栏数据】-----【成功】-----");
        // 将字典数组转为模型数组（里面放的就是LXChannelGroup模型）
        self.channelGroups = [LXChannelGroup objectArrayWithKeyValuesArray:responseObject[@"data"][@"channel_groups"]];
        // 将字典数组转为模型数组（里面放的就是LXChannel模型）
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"data"][@"channel_groups"]) {
            [tempArray addObject:[LXChannel objectArrayWithKeyValuesArray:dict[@"channels"]]];
        }
        self.channels = tempArray;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-----【分类】-----【加载分类栏数据】-----【失败】-----");
    }];
}

#pragma mark - 加载侧边导航栏数据
- (void)setupCategoryDatas {
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 2.发送请求
    [manager GET:SubCategory_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"-----【分类】-----【加载侧边导航栏数据】-----【成功】-----");
        // 将字典数组转为模型数组（里面放的就是LXCategory模型）
        self.categorys = [LXCategory objectArrayWithKeyValuesArray:responseObject[@"data"][@"categories"]];
        // 将字典数组转为模型数组（里面放的就是LXSubCategory模型）
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"data"][@"categories"]) {
            [tempArray addObject:[LXSubCategory objectArrayWithKeyValuesArray:dict[@"subcategories"]]];
        }
        self.subCategorys = tempArray;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-----【分类】-----【加载侧边导航栏数据】-----【失败】-----");
    }];
}

#pragma mark - UITableViewDataSource
// 段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.isGuide) {
        return 1;
    }
    return 4;
}
// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
// cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isGuide) {
        if (!indexPath.section) {
            LXCollectionCell *cell = [LXCollectionCell cellWithTableView:tableView];
            cell.collections = self.collections;
            return cell;
        } else {
            LXChannelGroupCell *cell = [LXChannelGroupCell cellWithTableView:tableView];
            cell.channels = self.channels[indexPath.section-1];
            return cell;
        }
    } else {
        self.tableView.bounces = NO;
        LXGiftCell *cell = [LXGiftCell cellWithTableView:tableView];
        cell.categorys= self.categorys;
        cell.subCategorys = self.subCategorys;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isGuide) {
        if (indexPath.section) {
            NSInteger row = [self numberOfRowsInCollectionViewWithChannelsCount:[self.channels[indexPath.section-1] count]];
            return row*channelCell_HEIGHT;
        } else {
            return collectionCell_HEIGHT;
        }
    } else {
        return screenHEIGHT-navigationBarH-tabBarH-toolbarH;
    }
}
// 计算collectionView的行数
- (NSInteger)numberOfRowsInCollectionViewWithChannelsCount:(NSInteger)count {
    if (count%4) {
        return count/4+1;
    } else {
        return count/4;
    }
}
// 段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return toolbarH;
}
// 段尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return minimumSpacing;
}
// 段头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isGuide) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        LXGuideHeaderView *guideHeaderView = [LXGuideHeaderView viewWithSection:section channelGroups:self.channelGroups];
        return guideHeaderView;
    } else {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        LXGiftHeaderView *giftHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LXGiftHeaderView" owner:self options:nil] lastObject];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [giftHeaderView addGestureRecognizer:tapGesture];
        return giftHeaderView;
    }
}
// 点击手势
- (void)onTap:(UITapGestureRecognizer *)recognizer {
    LXSelectGiftViewController *selectGiftCtl = [[LXSelectGiftViewController alloc] initWithNibName:@"LXSelectGiftViewController" bundle:nil];
    [self.navigationController pushViewController:selectGiftCtl animated:YES];
}
// 段尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, minimumSpacing)];
    if (self.isGuide) {
        if (section != 4) {
            footerView.backgroundColor = bgColor;
        }
    }
    return footerView;
}

#pragma mark - IBAction
// 攻略\礼物
- (IBAction)guideValueChange:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.isGuide = YES;
            break;
        case 1:
            self.isGuide = NO;
            break;
    }
    [self.tableView reloadData];
}
// 搜索
- (IBAction)easySearch:(UIBarButtonItem *)sender {
    SearchViewController *searchViewCtl = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewCtl animated:YES];
}

@end
