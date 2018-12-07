//
//  LXSettingViewController.m
//  网易彩票
//
//  Created by 曾令轩 on 15/12/7.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXSettingViewController.h"
//#import "LXPushNoticeViewController.h"
//#import "LXHelpViewController.h"
//#import "LXProductViewController.h"
#import "LXSettingGroup.h"
#import "LXSettingItem.h"
#import "LXSettingArrowItem.h"
#import "LXSettingSwitchItem.h"
#import "MBProgressHUD+MJ.h"
#import "testViewController.h"

@interface LXSettingViewController ()

@end

@implementation LXSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navBar_0"] forBarMetrics:UIBarMetricsDefault];
    self.title = @"更多";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToGuideCtl)];
    self.tableView.backgroundColor = bgColor;
    // 添加数据
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
}
// 返回键
- (void)backToGuideCtl {
    [self.navigationController popViewControllerAnimated:YES];
}
// 第0组数据
- (void)setupGroup0 {
    LXSettingItem *item1 = [LXSettingItem itemWithIcon:settingItemIcon title:@"邀请好友使用礼物说"];
    LXSettingItem *item2 = [LXSettingItem itemWithIcon:settingItemIcon title:@"给我们评分吧"];
    LXSettingItem *item3 = [LXSettingArrowItem itemWithIcon:settingItemIcon title:@"意见反馈" destCtl:[testViewController class]];
    LXSettingGroup *group = [[LXSettingGroup alloc] init];
    group.items = @[item1, item2, item3];
    [self.data addObject:group];
}
// 第1组数据
- (void)setupGroup1 {
    LXSettingItem *item1 = [LXSettingArrowItem itemWithIcon:settingItemIcon title:@"我的身份" destCtl:[testViewController class]];
    LXSettingItem *item2 = [LXSettingSwitchItem itemWithIcon:settingItemIcon title:@"接收消息提醒"];
    LXSettingItem *item3 = [LXSettingSwitchItem itemWithIcon:settingItemIcon title:@"深夜显示夜间模式开关"];
    LXSettingItem *item4 = [LXSettingArrowItem itemWithIcon:settingItemIcon title:@"清除缓存"];
    item4.option = ^{
        // 弹框提示
        [MBProgressHUD showMessage:@"清除缓存中..."];
        // 几秒后消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 移除HUD
            [MBProgressHUD hideHUD];
            // 提醒清除结果
            [MBProgressHUD showSuccess:@"清除缓存成功"];
        });
    };
    LXSettingGroup *group = [[LXSettingGroup alloc] init];
    group.items = @[item1, item2, item3, item4];
    [self.data addObject:group];
}
// 第2组数据
- (void)setupGroup2 {
    LXSettingItem *item1 = [LXSettingArrowItem itemWithIcon:settingItemIcon title:@"关于礼物说" destCtl:[testViewController class]];
    LXSettingGroup *group = [[LXSettingGroup alloc] init];
    group.items = @[item1];
    [self.data addObject:group];
}
// 第3组数据
- (void)setupGroup3 {
    LXSettingItem *item1 = [LXSettingArrowItem itemWithIcon:settingItemIcon title:@"查看更多推荐应用" destCtl:[testViewController class]];
    LXSettingGroup *group = [[LXSettingGroup alloc] init];
    group.header = @"小礼菌推荐应用";
    group.items = @[item1];
    [self.data addObject:group];
}

#pragma mark - UITableViewDelegate
// 段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return 5*minimumSpacing;
    }
    return minimumSpacing;
}
// 段尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

@end
