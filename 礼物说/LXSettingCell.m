//
//  LXSettingCell.m
//  网易彩票
//
//  Created by 曾令轩 on 15/12/7.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXSettingCell.h"
#import "LXSettingItem.h"
#import "LXSettingArrowItem.h"
#import "LXSettingSwitchItem.h"
#import "LXSettingLabelItem.h"

@interface LXSettingCell ()
// 箭头
@property (nonatomic, strong) UIImageView *arrowView;
// 开关
@property (nonatomic, strong) UISwitch *switchView;
// 标签
@property (nonatomic, strong) UILabel *labelView;
@end

@implementation LXSettingCell

- (UIImageView *)arrowView {
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    }
    return _arrowView;
}

- (UISwitch *)switchView {
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        [_switchView addTarget:self action:@selector(switchStateChange) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}
// 监听开关状态改变
- (void)switchStateChange {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setBool:self.switchView.isOn forKey:self.item.title];
    [user synchronize];
}

- (UILabel *)labelView {
    if (_labelView == nil) {
        _labelView = [[UILabel alloc] init];
        _labelView.bounds = CGRectMake(0, 0, 100, 30);
        _labelView.backgroundColor = [UIColor redColor];
    }
    return _labelView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    LXSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:SettingCell_ID];
    if (cell == nil) {
        cell = [[LXSettingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SettingCell_ID];
    }
    return cell;
}

- (void)setItem:(LXSettingItem *)item {
    _item = item;
    // 1.设置数据
    [self setupData];
    // 2.设置右边的内容
    [self setupRightContent];
}
// 1.设置数据
- (void)setupData {
    if (self.item.icon ) {
        self.imageView.image = [UIImage imageNamed:self.item.icon];
    }
    self.textLabel.text = self.item.title;
}
// 2.设置右边的内容
- (void)setupRightContent {
    if ([self.item isKindOfClass:[LXSettingArrowItem class]]) {// 箭头
        self.accessoryView = self.arrowView;
    } else if ([self.item isKindOfClass:[LXSettingSwitchItem class]]) {// 开关
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryView = self.switchView;
        // 设置开关的状态
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        self.switchView.on = [user boolForKey:self.item.title];
    } else if ([self.item isKindOfClass:[LXSettingLabelItem class]]) {// 标签
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryView = self.labelView;
    } else {
        self.accessoryView = nil;
    }
}

@end
