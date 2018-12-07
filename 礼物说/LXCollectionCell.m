//
//  LXCollectionCell.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/11.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXCollectionCell.h"
#import "LXCollection.h"
#import "UIImageView+WebCache.h"

@interface LXCollectionCell ()
@property (nonatomic, weak) UIScrollView *topicScrollView;
@end

@implementation LXCollectionCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    return [[[self class] alloc] initWithTableView:tableView];
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    LXCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CollectionCell_ID];
    if (cell == nil) {
        cell = [[LXCollectionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CollectionCell_ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 初始化专题栏
        [self setupScrollView];
    }
    return self;
}
// 初始化专题栏
- (void)setupScrollView {
    // scrollView
    UIScrollView *topicScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWIDTH, topicScrollView_HEIGHT)];
    topicScrollView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:topicScrollView];
    self.topicScrollView = topicScrollView;
}

- (void)setCollections:(NSArray *)collections {
    _collections = collections;
    if (!self.topicScrollView.contentSize.width) {
        if (collections) {
            // imageView
            CGFloat imageViewY = 0.5*minimumSpacing;
            CGFloat imageViewH = collectionCell_HEIGHT-2*minimumSpacing;
            CGFloat imageViewW = 2*imageViewH;
            for (int i = 0; i < collections.count; i++) {
                CGFloat imageViewX = i*(imageViewW+minimumSpacing)+minimumSpacing;
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH)];
                LXCollection *collection = collections[i];
                [imageView setImageWithURL:[NSURL URLWithString:collection.banner_image_url]];
                imageView.layer.cornerRadius = 5;
                imageView.clipsToBounds = YES;
                [self.topicScrollView addSubview:imageView];
            }
            self.topicScrollView.contentSize = CGSizeMake(self.collections.count*(imageViewW+minimumSpacing)+minimumSpacing, topicScrollView_HEIGHT);
        }
    }
}

@end
