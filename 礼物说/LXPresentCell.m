//
//  LXPresentCell.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/10.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXPresentCell.h"
#import "LXPopItem.h"

@interface LXPresentCell ()
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;
@end

@implementation LXPresentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView item:(LXPopItem *)item {
    return [[[self class] alloc] initWithTableView:tableView item:item];
}

- (instancetype)initWithTableView:(UITableView *)tableView item:(LXPopItem *)item {
    if (self = [super init]) {
        self = [tableView dequeueReusableCellWithIdentifier:PresentCell_ID];
        [self.detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:item.url]]];
    }
    return self;
}

@end
