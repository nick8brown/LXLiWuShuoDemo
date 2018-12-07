//
//  LXBaseSettingViewController.m
//  网易彩票
//
//  Created by 曾令轩 on 15/12/7.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXBaseSettingViewController.h"
#import "LXSettingGroup.h"
#import "LXSettingItem.h"
#import "LXSettingArrowItem.h"
#import "LXSettingSwitchItem.h"
#import "LXSettingCell.h"

@interface LXBaseSettingViewController ()

@end

@implementation LXBaseSettingViewController

- (instancetype)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (NSMutableArray *)data {
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDataSource
// 段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}
// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LXSettingGroup *group = self.data[section];
    return group.items.count;
}
// cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.创建cell
    LXSettingCell *cell = [LXSettingCell cellWithTableView:tableView];
    // 2.给cell传递模型数据
    LXSettingGroup *group = self.data[indexPath.section];
    cell.item = group.items[indexPath.row];
    // 3.返回cell
    return cell;
}
// 头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    LXSettingGroup *group = self.data[section];
    return group.header;
}
// 尾部标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    LXSettingGroup *group = self.data[section];
    return group.footer;
}

#pragma mark - UITableViewDelegate
// 选中某行执行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.取消选中这行
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 2.模型数据
    LXSettingGroup *group = self.data[indexPath.section];
    LXSettingItem *item = group.items[indexPath.row];
    if (item.option) {// block有值（点击这个cell，有特定的操作需要执行）
        item.option();
    }
    if ([item isKindOfClass:[LXSettingArrowItem class]]) {// 箭头
        LXSettingArrowItem *arrowItem = (LXSettingArrowItem *)item;
        // 如果没有需要跳转的控制器
        if (arrowItem.destCtl == nil) return;
        UIViewController *vc = [[arrowItem.destCtl alloc] init];
        vc.title = arrowItem.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
