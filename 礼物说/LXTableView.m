//
//  LXTableView.m
//  礼物说
//
//  Created by 曾令轩 on 15/11/27.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXTableView.h"
#import "ChannelCell.h"
#import "Channel.h"

@interface LXTableView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation LXTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.rowHeight = 170;
        self.dataSource = self;
        self.delegate = self;
        // 注册cell
        UINib *nib = [UINib nibWithNibName:@"ChannelCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:cell_ID];
    }
    return self;
}

#pragma mark - UITableViewDataSource
// 段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.channelsItems.count;
}
// cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChannelCell *cell = [ChannelCell cellWithTableView:tableView];
    cell.channel = self.channelsItems[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Channel *channel = self.channelsItems[indexPath.row];
    NSDictionary *urlDict = @{@"url":channel.url};
    [[NSNotificationCenter defaultCenter] postNotificationName:WEBVIEW object:nil userInfo:urlDict];
}

@end
