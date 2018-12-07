//
//  LXSelectGiftViewController.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/16.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXSelectGiftViewController.h"
#import "LXFilter.h"
#import "LXFilterChannel.h"
#import "LXFilterItem.h"
#import "LXFlowLayout.h"
#import "LXFilterItemCell.h"
#import "NSString+Frame.h"
#import "UIColor+HtmlColor.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "MJRefresh.h"

@interface LXSelectGiftViewController () <LXFlowLayoutDelegate, UICollectionViewDataSource>
{
    NSInteger _offset;
}
@property (weak, nonatomic) IBOutlet UIButton *targetBtn;
@property (weak, nonatomic) IBOutlet UIButton *sceneBtn;
@property (weak, nonatomic) IBOutlet UIButton *personalityBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet LXFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *filters;
@property (nonatomic, strong) NSArray *filterChannels;
@property (nonatomic, strong) NSMutableArray *filterItems;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, weak) UIView *coverView;
@property (nonatomic, weak) UIView *filterView;
@property (nonatomic, assign) BOOL isBtnSelected;
@end

@implementation LXSelectGiftViewController

- (NSMutableArray *)filterItems {
    if (_filterItems == nil) {
        _filterItems = [NSMutableArray array];
    }
    return _filterItems;
}

- (NSMutableArray *)btnArray {
    if (_btnArray == nil) {
        _btnArray = [NSMutableArray arrayWithObjects:self.targetBtn, self.sceneBtn, self.personalityBtn, self.priceBtn, nil];
    }
    return _btnArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"选礼神器";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToGuideCtl)];
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"LXFilterItemCell" bundle:nil] forCellWithReuseIdentifier:FilterItemCell_ID];
    // 首页
    _offset = 0;
    // 加载过滤器数据
    [self setupFilterChannelDatas];
    // 加载选礼神器数据
    [self setupFilterItemDatas];
    // 设置layout
    [self setupLayout];
    // 初始化瀑布流
    [self setupCollectionView];
}
// 返回键
- (void)backToGuideCtl {
    [self.navigationController popViewControllerAnimated:YES];
}
// 设置layout
- (void)setupLayout {
    self.layout.colCount = 2;
    self.layout.delegate = self;
}

#pragma mark - 加载过滤器数据
- (void)setupFilterChannelDatas {
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 2.发送请求
    [manager GET:FilterChannel_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"-----【分类】-----【加载过滤器数据】-----【成功】-----");
        // 将字典数组转为模型数组（里面放的就是LXFilter模型）
        self.filters = [LXFilter objectArrayWithKeyValuesArray:responseObject[@"data"][@"filters"]];
        // 将字典数组转为模型数组（里面放的就是LXFilterChannel模型）
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"data"][@"filters"]) {
            [tempArray addObject:[LXFilterChannel objectArrayWithKeyValuesArray:dict[@"channels"]]];
        }
        self.filterChannels = tempArray;
        // 设置过滤器筛选按钮标题
        for (int i = 0; i < self.filters.count; i++) {
            UIButton *btn = self.btnArray[i];
            LXFilter *filter = self.filters[i];
            [btn setTitle:filter.name forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
        self.isBtnSelected = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-----【分类】-----【加载过滤器数据】-----【失败】-----");
    }];
}

#pragma mark - 加载选礼神器数据
- (void)setupFilterItemDatas {
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 2.创建URL
    NSMutableString *urlStr = [NSMutableString stringWithString:FilterItem_URL];
    [urlStr replaceOccurrencesOfString:@"%d" withString:[NSString stringWithFormat:@"%ld", _offset] options:NSLiteralSearch range:NSMakeRange(0, urlStr.length)];
    // 3.发送请求
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"-----【分类】-----【加载选礼神器数据】-----【成功】-----");
        if (_offset == 0) {
            [self.filterItems removeAllObjects];
        }
        // 将字典数组转为模型数组（里面放的就是LXFilterItem模型）
        NSMutableArray *itemsArray = [NSMutableArray array];
        for (NSDictionary *dict in responseObject[@"data"][@"items"]) {
            LXFilterItem *item = [LXFilterItem itemWithDictionary:dict];
            [itemsArray addObject:item];
        }
        [self.filterItems addObjectsFromArray:itemsArray];
        self.layout.models = self.filterItems;
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-----【分类】-----【加载选礼神器数据】-----【失败】-----");
    }];
}

#pragma mark - 过滤器
- (void)setupFilterViewWithChannels:(NSArray *)filterChannels {
    // 1.遮盖视图
    CGFloat coverViewX = 0;
    CGFloat coverViewY = toolbarH;
    CGFloat coverViewW = self.collectionView.frame.size.width;
    CGFloat coverViewH = self.collectionView.frame.size.height;
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(coverViewX, coverViewY, coverViewW, coverViewH)];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.5;
    [self.view addSubview:coverView];
    self.coverView = coverView;
    // 2.筛选视图
    UIView *filterView = [[UIView alloc] init];
    filterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:filterView];
    // 2.1背景视图
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = bgColor;
    [filterView addSubview:bgView];
    // 2.2按钮视图
    NSInteger totalRow = [self numberOfRowsInFilterViewWithChannelsCount:filterChannels.count+1];
    int index = 0;
    for (int i = 0; i < totalRow; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            CGFloat btnW = (screenWIDTH-(3+1)*minimumSpacing)/3;
            CGFloat btnH = 35;
            CGFloat btnX = minimumSpacing+j*(btnW+minimumSpacing);
            CGFloat btnY = minimumSpacing+i*(btnH+minimumSpacing);
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            if (i == 0 && j == 0) {
                btn.backgroundColor = [UIColor colorWithHexString:mainThemeHtmlColor];
                btn.layer.cornerRadius = 5;
                btn.clipsToBounds = YES;
                [btn setTitle:@"全部" forState:UIControlStateNormal];
            } else {
                btn.backgroundColor = [UIColor whiteColor];
                btn.layer.borderWidth = 1;
                btn.layer.borderColor = lineColor_LX.CGColor;
                btn.layer.cornerRadius = 5;
                btn.clipsToBounds = YES;
                LXFilterChannel *channel = filterChannels[index];
                [btn setTitle:channel.name forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                index++;
            }
            [bgView addSubview:btn];
            if ((i == totalRow-1) && (i*3+j == filterChannels.count)) {
                //背景视图frame
                bgView.frame = CGRectMake(0, 0, screenWIDTH, CGRectGetMaxY(btn.frame)+minimumSpacing);
                break;
            }
        }
    }
    // 2.3分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), screenWIDTH, 1)];
    lineView.backgroundColor = lineColor_LX;
    [filterView addSubview:lineView];
    // 筛选视图frame
    filterView.frame = CGRectMake(0, toolbarH, screenWIDTH, CGRectGetMaxY(lineView.frame)+2*minimumSpacing);
    self.filterView = filterView;
}
// 计算filterView的行数
- (NSInteger)numberOfRowsInFilterViewWithChannelsCount:(NSInteger)count {
    if (count%3) {
        return count/3+1;
    } else {
        return count/3;
    }
}

#pragma mark - 瀑布流
- (void)setupCollectionView {
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    [header setTitle:self.title forState:MJRefreshStatePulling];
    [header beginRefreshing];
    self.collectionView.header = header;
    // 上拉刷新
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _offset += 20;
        [self setupFilterItemDatas];
    }];
}
// 首页
- (void)refreshData {
    _offset = 0;
    [self setupFilterItemDatas];
}

#pragma mark - LXFlowLayoutDelegate
- (CGFloat)flowLayout:(LXFlowLayout *)layout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath {
    LXFilterItem *item = self.filterItems[indexPath.item];
    // 文字长度约束
    NSString *describe = nil;
    if (item.describe.length > 80) {
        describe = [NSString stringWithFormat:@"%@...", [item.describe substringToIndex:80]];
    } else {
        describe = item.describe;
    }
    CGFloat descH  = [describe heightWithFont:[UIFont systemFontOfSize:15] withinWidth:width-2*8];// xib边界值:8
    CGFloat height = descH + 145 + 30;// imageView高度:145，priceLabel高度:30
    return height;
}

#pragma mark UICollectionViewDataSource
// 项数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filterItems.count;
}
// cell样式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LXFilterItemCell *cell = [LXFilterItemCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.item = self.filterItems[indexPath.item];
    return cell;
}

#pragma mark - IBAction
// 对象
- (IBAction)targetBtnClick:(UIButton *)sender {
    [self loadBtnViewWithTag:sender.tag];
}
// 场合
- (IBAction)sceneBtnClick:(UIButton *)sender {
    [self loadBtnViewWithTag:sender.tag];
}
// 个性
- (IBAction)personalityBtnClick:(UIButton *)sender {
    [self loadBtnViewWithTag:sender.tag];
}
// 价格
- (IBAction)priceBtnClick:(UIButton *)sender {
    [self loadBtnViewWithTag:sender.tag];
}
// 展开过滤器视图
- (void)loadBtnViewWithTag:(NSInteger)tag {
    self.isBtnSelected = !self.isBtnSelected;
    if (self.isBtnSelected) {
        [self setupFilterViewWithChannels:self.filterChannels[tag-100]];
        self.isBtnSelected = YES;
    } else {
        [self.coverView removeFromSuperview];
        [self.filterView removeFromSuperview];
    }
}

@end
