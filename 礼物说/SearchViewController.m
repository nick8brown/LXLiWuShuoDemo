//
//  SearchViewController.m
//  礼物说
//
//  Created by 曾令轩 on 15/11/29.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 搜索框
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screenWIDTH-80, 30)];
    searchBar.placeholder = @"送份礼物给最爱的人";
    [searchBar becomeFirstResponder];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    // 取消键
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
}
// 返回主界面
- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
