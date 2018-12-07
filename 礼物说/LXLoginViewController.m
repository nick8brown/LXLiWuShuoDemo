//
//  LXLoginViewController.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/21.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXLoginViewController.h"
#import "LXDailySignInViewController.h"
#import "LXLoginStatus.h"
#import "User.h"
#import "UserDB.h"
#import "MBProgressHUD+MJ.h"

@interface LXLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) UserDB *userDB;

- (IBAction)cancelBtnClick:(UIButton *)sender;
- (IBAction)registerBtnClick:(UIButton *)sender;
- (IBAction)loginBtnClick:(UIButton *)sender;
- (IBAction)loginByMessage:(UIButton *)sender;
- (IBAction)forgotPassword:(UIButton *)sender;
- (IBAction)loginByWeibo:(UIButton *)sender;
- (IBAction)loginByWeixin:(UIButton *)sender;
- (IBAction)loginByQQ:(UIButton *)sender;
@end

@implementation LXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userDB = [[UserDB alloc] init];
    // 创建数据库表
    [self.userDB createTable];
}

#pragma mark - 数据插入
- (void)insertData {
    NSArray *insertArray = [NSArray array];
    NSString *phoneNumber = [NSString stringWithFormat:@"%@", self.phoneNumberTextField.text];
    NSString *password = [NSString stringWithFormat:@"%@", self.passwordTextField.text];
    insertArray = @[phoneNumber, password];
    [self.userDB addUserWithParams:insertArray];
}

#pragma mark - 数据删除
- (void)deleteData {
//    NSMutableArray *deleteArray = [NSMutableArray array];
//    for (int i = 0; i < 10; i = i+2) {
//        NSString *name = [NSString stringWithFormat:@"zlx_%d", i];
//        [deleteArray addObject:name];
//    }
//    [self.userDB deleteUsers:deleteArray];
//    // 删除全部
//    //    [self.userDB deleteUsers:nil];
}

#pragma mark - 数据查询
- (NSArray *)findData {
    NSMutableArray *selectArray = [NSMutableArray array];
    [selectArray addObject:self.phoneNumberTextField.text];
    NSArray *modelArray = [self.userDB selectUser:selectArray];
    NSMutableArray *infoArray = [NSMutableArray array];
    for (User *user in modelArray) {
        [infoArray addObject:user.password];
    }
    return infoArray;
    // 查询全部
    //    NSArray *modelArray = [self.userDB selectUser:nil];
    //    for (User *user in modelArray) {
    //        NSLog(@"ID:%@, name:%@, password:%@, age:%@", user.ID, user.name, user.password, user.age);
    //    }
}

#pragma mark - IBAction
// 取消
- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 注册
- (IBAction)registerBtnClick:(UIButton *)sender {
    if (self.phoneNumberTextField.text.length == 11) {
        if (![self.passwordTextField.text isEqualToString:@""]) {
            // 数据插入
            [self insertData];
        } else {
            [self alertViewShow:@"密码不能为空"];
        }
    } else {
        [self alertViewShow:@"请输入11位手机号码"];
    }
}
// 登录
- (IBAction)loginBtnClick:(UIButton *)sender {
    if (self.phoneNumberTextField.text.length == 11) {
        if (![self.passwordTextField.text isEqualToString:@""]) {
            if ([[self findData] count]) {
                if ([self.passwordTextField.text isEqualToString:[[self findData] lastObject]]) {
                    [MBProgressHUD showSuccess:@"登录成功"];
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    LXLoginStatus *loginStatus = [LXLoginStatus shareLoginStatus];
                    loginStatus.isLogin = YES;
                    [user setBool:loginStatus.isLogin forKey:loginStatus_isLogin];
                    LXDailySignInViewController *dailySignInCtl = [[LXDailySignInViewController alloc] initWithNibName:@"LXDailySignInViewController" bundle:nil];
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self.preCtl.navigationController pushViewController:dailySignInCtl animated:YES];
                    }];
                } else {
                    [MBProgressHUD showError:@"账号不存在或密码错误"];
                }
            }
        } else {
            [self alertViewShow:@"请输入密码"];
        }
    } else {
        // 弹框提示
        [MBProgressHUD showMessage:@"这样的手机号码不存在呢..."];
        // 几秒后消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 移除HUD
            [MBProgressHUD hideHUD];
        });
    }
}
// 手机验证码登录
- (IBAction)loginByMessage:(UIButton *)sender {
}
// 忘记密码
- (IBAction)forgotPassword:(UIButton *)sender {
    // 数据查询
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请牢记您的密码!" message:[[self findData] lastObject]  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}
// 微博登录
- (IBAction)loginByWeibo:(UIButton *)sender {
}
// 微信登录
- (IBAction)loginByWeixin:(UIButton *)sender {
}
// QQ登录
- (IBAction)loginByQQ:(UIButton *)sender {
}

#pragma mark - 弹框
- (void)alertViewShow:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - 键盘\触摸屏
// 键盘
- (void)kbClose:(NSNotification *)notification {
    CGRect kbRect = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat kbY = kbRect.origin.y;
    CGFloat textFieldY = 0;
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            if (view.isFirstResponder) {
                textFieldY = CGRectGetMaxY(view.frame);
            }
        }
    }
    if (textFieldY > kbY) {
        [UIView animateWithDuration:0.1 animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, kbY-textFieldY-10);
        }];
    }
}
// return(enter)键
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}
// 触摸屏
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
    [self.view endEditing:YES];
}

@end
