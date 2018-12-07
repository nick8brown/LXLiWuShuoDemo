//
//  WebViewController.m
//  礼物说
//
//  Created by 曾令轩 on 15/11/29.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.titleStr) {
        self.title = self.titleStr;
    } else {
        self.title = @"攻略详情";
    }
    self.navigationController.navigationBar.translucent = NO;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
}

@end
