//
//  LXGiftDetailsViewController.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/9.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXGiftDetailsViewController.h"
#import "LXPopItem.h"
#import "LXComment.h"
#import "LXCommentUser.h"
#import "LXCommentFrame.h"
#import "LXGiftView.h"
#import "LXPresentCell.h"
#import "LXCommentCell.h"
#import "UIColor+HtmlColor.h"
#import "AFNetworking.h"
#import "MJExtension.h"

@interface LXGiftDetailsViewController ()
@property (nonatomic, assign) BOOL isPresent;
@property (nonatomic, assign) BOOL isSelectedPresentHidden;
@property (nonatomic, assign) BOOL isSelectedCommentHidden;
@property (nonatomic, strong) NSArray *commentFrames;
@end

@implementation LXGiftDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"礼物详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareGift)];
    // 初始化工具栏
    [self setupToolbarView];
    // 设置tableHeaderView
    self.tableView.tableHeaderView = [LXGiftView viewWithItem:self.item];
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"LXPresentCell" bundle:nil] forCellReuseIdentifier:PresentCell_ID];
    // 默认展示图文介绍页
    [self setupProductView];
    // 加载评论数据
    [self setupCommentsData];
}
// 分享
- (void)shareGift {
#warning todo 分享到：微信朋友圈...
}

#pragma mark - 工具栏
- (void)setupToolbarView {
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.backgroundColor = [UIColor whiteColor];
    // 设置toolbarItems
    self.toolbarItems = [self setupToolbarItems];
}
// 获得barButtonItems
- (NSArray *)setupToolbarItems {
    // 1.favoriteView（喜欢）
    CGFloat favoriteViewX = 0;
    CGFloat favoriteViewY = 0;
    CGFloat favoriteViewW = 111;
    CGFloat favoriteViewH = 32;
    UIView *favoriteView = [[UIView alloc] initWithFrame:CGRectMake(favoriteViewX, favoriteViewY, favoriteViewW, favoriteViewH)];
    favoriteView.layer.borderWidth = 1.5;
    favoriteView.layer.borderColor = [UIColor colorWithHexString:mainThemeHtmlColor].CGColor;
    favoriteView.layer.cornerRadius = 16;
    favoriteView.clipsToBounds = YES;
    // imageView
    CGFloat verticalMargin = 8;
    CGFloat horizontalMargin = 25;
    CGFloat imageViewW = 18;
    CGFloat imageViewH = 18;
    CGFloat imageViewX = horizontalMargin;
    CGFloat imageViewY = (favoriteViewH-imageViewH)*0.5;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
    imageView.image = [UIImage imageNamed:@"icon_wannasee_unmark"];
    [favoriteView addSubview:imageView];
    // label
    CGFloat label1X = CGRectGetMaxX(imageView.frame)+verticalMargin;
    CGFloat label1Y = imageViewY;
    CGFloat label1W = favoriteViewW-label1X-imageViewX;
    CGFloat label1H = imageViewH;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(label1X, label1Y, label1W, label1H)];
    label1.text = @"喜欢";
    label1.textColor = [UIColor colorWithHexString:mainThemeHtmlColor];
    [favoriteView addSubview:label1];
    // 2.purchaseView（去天猫购买）
    CGFloat purchaseViewX = 0;
    CGFloat purchaseViewY = 0;
    CGFloat purchaseViewW = 1.5*favoriteViewW;
    CGFloat purchaseViewH = 32;
    UIView *purchaseView = [[UIView alloc] initWithFrame:CGRectMake(purchaseViewX, purchaseViewY, purchaseViewW, purchaseViewH)];
    purchaseView.backgroundColor = [UIColor colorWithHexString:mainThemeHtmlColor];
    purchaseView.layer.cornerRadius = 16;
    purchaseView.clipsToBounds = YES;
    // label
    CGFloat label2X = horizontalMargin;
    CGFloat label2Y = verticalMargin;
    CGFloat label2W = purchaseViewW-2*horizontalMargin;
    CGFloat label2H = label1H;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label2X, label2Y, label2W, label2H)];
    label2.text = @"去天猫购买";
    label2.textColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentCenter;
    [purchaseView addSubview:label2];
    // 创建barButtonItem
    UIBarButtonItem *favoriteBarBtn = [[UIBarButtonItem alloc] initWithCustomView:favoriteView];
    UIBarButtonItem *purchaseBarBtn = [[UIBarButtonItem alloc] initWithCustomView:purchaseView];
    return @[favoriteBarBtn, purchaseBarBtn];
}

#pragma mark - 图文介绍页
- (void)setupProductView {
    self.isSelectedPresentHidden = NO;
    self.isSelectedCommentHidden = YES;
    self.isPresent = YES;
}

#pragma mark - 加载评论数据
- (void)setupCommentsData {
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 2.创建URL
    NSMutableString *urlStr = [NSMutableString stringWithString:ItemComment_URL];
    [urlStr replaceOccurrencesOfString:@"id" withString:[NSString stringWithFormat:@"%@", self.item.ID] options:NSLiteralSearch range:NSMakeRange(0, urlStr.length)];
    // 3.发送请求
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"-----【热门】-----【加载评论数据】-----【成功】-----");
        // 将字典数组转为模型数组（里面放的就是LXComment模型）
        NSArray *commentsArray = [LXComment objectArrayWithKeyValuesArray:responseObject[@"data"][@"comments"]];
        // 创建frame模型对象
        NSMutableArray *commentFramesArray = [NSMutableArray array];
        for (LXComment *comment in commentsArray) {
            LXCommentFrame *commentFrame = [[LXCommentFrame alloc] init];
            commentFrame.comment = comment;
            [commentFramesArray addObject:commentFrame];
        }
        self.commentFrames = commentFramesArray;
        // 刷新表格
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-----【热门】-----【加载评论数据】-----【失败】-----");
    }];
}

#pragma mark - UITableViewDataSource
// 段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isPresent) {
        return 1;
    }
    return self.commentFrames.count;
}
// cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isPresent) {
        LXPresentCell *cell = [LXPresentCell cellWithTableView:tableView item:self.item];
        return cell;
    } else {
        LXCommentCell *cell = [LXCommentCell cellWithTableView:tableView];
        cell.commentFrame = self.commentFrames[indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isPresent) {
        return 510;
    }
    LXCommentFrame *commentFrame = self.commentFrames[indexPath.row];
    return commentFrame.cellHeight;
}
// 段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return sectionHeaderView_HEIGHT;
}
// 段头视图
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, sectionHeaderView_HEIGHT)];
    sectionHeaderView.backgroundColor = lineColor_LX;
    // 图文介绍
    UIButton *presentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat presentBtnX = 0;
    CGFloat presentBtnY = 1;// 距离tableHeaderView:10
    CGFloat presentBtnW = (screenWIDTH-1)*0.5;// 中间分割线:1
    CGFloat presentBtnH = sectionHeaderView_HEIGHT-presentBtnY-1;// 底部分割线:1
    presentBtn.frame = CGRectMake(presentBtnX, presentBtnY, presentBtnW, presentBtnH);
    presentBtn.backgroundColor = [UIColor whiteColor];
    [presentBtn setTitle:@"图文介绍" forState:UIControlStateNormal];
    [presentBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [presentBtn addTarget:self action:@selector(showProduct:) forControlEvents:UIControlEventTouchUpInside];
    [sectionHeaderView addSubview:presentBtn];
    // 选中标记
    CGFloat selectedPresentW = presentBtnW+1;
    CGFloat selectedPresentH = 3;
    CGFloat selectedPresentX = 0;
    CGFloat selectedPresentY = sectionHeaderView_HEIGHT-selectedPresentH;
    UIView *selectedPresent = [[UIView alloc] initWithFrame:CGRectMake(selectedPresentX, selectedPresentY, selectedPresentW, selectedPresentH)];
    selectedPresent.backgroundColor = [UIColor colorWithHexString:mainThemeHtmlColor];
    selectedPresent.hidden = self.isSelectedPresentHidden;
    [sectionHeaderView addSubview:selectedPresent];
    // 评论
    CGFloat commentBtnX = presentBtnW+1;
    CGFloat commentBtnY = presentBtnY;
    CGFloat commentBtnW = presentBtnW;
    CGFloat commentBtnH = presentBtnH;
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(commentBtnX, commentBtnY, commentBtnW, commentBtnH);
    commentBtn.backgroundColor = [UIColor whiteColor];
    [commentBtn setTitle:[NSString stringWithFormat:@"评论(%ld)", self.commentFrames.count] forState:UIControlStateNormal];
    [commentBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(showComment:) forControlEvents:UIControlEventTouchUpInside];
    [sectionHeaderView addSubview:commentBtn];
    // 选中标记
    CGFloat selectedCommentX = commentBtnW;
    CGFloat selectedCommentY = selectedPresentY;
    CGFloat selectedCommentW = selectedPresentW;
    CGFloat selectedCommentH = selectedPresentH;
    UIView *selectedComment = [[UIView alloc] initWithFrame:CGRectMake(selectedCommentX, selectedCommentY, selectedCommentW, selectedCommentH)];
    selectedComment.backgroundColor = [UIColor colorWithHexString:mainThemeHtmlColor];
    selectedComment.hidden = self.isSelectedCommentHidden;
    [sectionHeaderView addSubview:selectedComment];
    return sectionHeaderView;
}
// 图文介绍页
- (void)showProduct:(UIButton *)sender {
    if (!self.isPresent) {
        self.isSelectedCommentHidden = !self.isSelectedCommentHidden;
        self.isSelectedPresentHidden = !self.isSelectedPresentHidden;
        self.isPresent = YES;
        [self.tableView reloadData];
    }
}
// 评论页
- (void)showComment:(UIButton *)sender {
    if (self.isPresent) {
        self.isSelectedPresentHidden = !self.isSelectedPresentHidden;
        self.isSelectedCommentHidden = !self.isSelectedCommentHidden;
        self.isPresent = NO;
        [self.tableView reloadData];
    }
}

@end
