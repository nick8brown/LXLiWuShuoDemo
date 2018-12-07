//
//  LXPopViewController.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/8.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXPopViewController.h"
#import "LXGiftDetailsViewController.h"
#import "LXPopPage.h"
#import "LXPopItem.h"
#import "LXPopItemCell.h"
#import "SearchViewController.h"

@interface LXPopViewController ()
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSArray *popPages;
@property (nonatomic, strong) NSArray *popItems;
@end

@implementation LXPopViewController

- (NSArray *)popPages {
    if (_popPages == nil) {
        NSURL *url = [NSURL URLWithString:PopItem_URL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        LXPopPage *page = [LXPopPage pageWithDictionary:tempDict[@"data"]];
        NSMutableArray *pagesArray = [NSMutableArray array];
        [pagesArray addObject:page];
        _popPages = pagesArray;
    }
    return _popPages;
}

- (NSArray *)popItems {
    if (_popItems == nil) {
        LXPopPage *page = [self.popPages lastObject];
        NSMutableArray *itemsArray = [NSMutableArray array];
        for (NSDictionary *dict in page.items) {
            LXPopItem *item = [LXPopItem itemWithDictionary:dict[@"data"]];
            [itemsArray addObject:item];
        }
        _popItems = itemsArray;
    }
    return _popItems;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    // 设置layout
    [self setupLayout];
    // 注册cell
    UINib *nib = [UINib nibWithNibName:@"LXPopItemCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:PopItemCell_ID];
}
// 设置layout
- (void)setupLayout {
    CGFloat itemW = (screenWIDTH-3*minimumSpacing)*0.5;
    CGFloat itemH = 235;
    self.layout.itemSize = CGSizeMake(itemW, itemH);
    self.layout.minimumInteritemSpacing = minimumSpacing;
    self.layout.minimumLineSpacing = minimumSpacing;
    self.layout.sectionInset = UIEdgeInsetsMake(minimumSpacing, minimumSpacing, 0, minimumSpacing);
}

#pragma mark UICollectionViewDataSource
// 组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.popPages.count;
}
// 项数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.popItems.count;
}
// cell样式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LXPopItemCell *cell = [LXPopItemCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.item = self.popItems[indexPath.item];
    return cell;
}
// 选中某项
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LXGiftDetailsViewController *detailsCtl = [[LXGiftDetailsViewController alloc] initWithStyle:UITableViewStylePlain];
    detailsCtl.item = self.popItems[indexPath.item];
    [self.navigationController pushViewController:detailsCtl animated:YES];
}

#pragma mark - IBAction
// 搜索
- (IBAction)easySearch:(UIBarButtonItem *)sender {
    SearchViewController *searchViewCtl = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewCtl animated:YES];
}

@end
