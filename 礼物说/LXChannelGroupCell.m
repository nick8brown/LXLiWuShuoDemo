//
//  LXChannelGroupCell.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/13.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXChannelGroupCell.h"
#import "LXChannelCell.h"

@interface LXChannelGroupCell () <UICollectionViewDataSource>
@property (nonatomic, weak) UICollectionView *collectionView;
@end

@implementation LXChannelGroupCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    return [[[self class] alloc] initWithTableView:tableView];
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    LXChannelGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:ChannelGroupCell_ID];
    if (cell == nil) {
        cell = [[LXChannelGroupCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ChannelGroupCell_ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setChannels:(NSArray *)channels {
    _channels = channels;
    if (channels) {
        // 初始化分类栏
        [self setupGroupCollectionView];
    }
}

#pragma mark - 分类栏
- (void)setupGroupCollectionView {
    [self.collectionView removeFromSuperview];
    NSInteger row = [self numberOfRowsInCollectionViewWithChannelsCount:self.channels.count];
    CGFloat groupCollectionViewH = row*channelCell_HEIGHT;
    UICollectionView *groupCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWIDTH, groupCollectionViewH) collectionViewLayout:[self setupFlowLayout]];
    groupCollectionView.backgroundColor = [UIColor whiteColor];
    [groupCollectionView registerNib:[UINib nibWithNibName:@"LXChannelCell" bundle:nil] forCellWithReuseIdentifier:ChannelCell_ID];
    groupCollectionView.scrollEnabled = NO;
    groupCollectionView.dataSource = self;
    [self.contentView addSubview:groupCollectionView];
    self.collectionView = groupCollectionView;
}
// 计算collectionView的行数
- (NSInteger)numberOfRowsInCollectionViewWithChannelsCount:(NSInteger)count {
    if (count%4) {
        return count/4+1;
    } else {
        return count/4;
    }
}
// 设置流水布局
- (UICollectionViewFlowLayout *)setupFlowLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(channelCell_WIDTH, channelCell_HEIGHT);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    return layout;
}

#pragma mark - UICollectionViewDataSource
// 项数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.channels.count;
}
// cell样式
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LXChannelCell *cell = [LXChannelCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.channel = self.channels[indexPath.item];
    return cell;
}

@end
