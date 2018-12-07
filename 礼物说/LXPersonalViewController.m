//
//  LXPersonalViewController.m
//  礼物说
//
//  Created by 曾令轩 on 15/12/18.
//  Copyright © 2015年 曾令轩. All rights reserved.
//

#import "LXPersonalViewController.h"
#import "LXSettingViewController.h"
#import "LXFunctionCell.h"
#import "LXEmptyCell.h"
#import "UIColor+HtmlColor.h"

@interface LXPersonalViewController () <UIImagePickerControllerDelegate>
@property (nonatomic, weak) UIImageView *bgImgView;
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, assign) BOOL isGift;
@property (nonatomic, assign) BOOL isSelectedGiftHidden;
@property (nonatomic, assign) BOOL isSelectedGuideHidden;
@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, strong) NSMutableArray *guides;
@end

@implementation LXPersonalViewController

- (NSArray *)lists {
    if (_lists == nil) {
        _lists = [NSMutableArray arrayWithObjects:@1, nil];
    }
    return _lists;
}

- (NSArray *)guides {
    if (_guides == nil) {
        _guides = [NSMutableArray array];
    }
    return _guides;
}

- (void)viewWillAppear:(BOOL)animated {
//    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // tableView内边距
    self.tableView.contentInset = UIEdgeInsetsMake(edgeInset_Top, 0, 0, 0);
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"LXFunctionCell" bundle:nil] forCellReuseIdentifier:FunctionCell_ID];
    [self.tableView registerNib:[UINib nibWithNibName:@"LXEmptyCell" bundle:nil] forCellReuseIdentifier:EmptyCell_ID];
    // 初始化背景
    [self setupBGImgView];
    // 默认展示礼物页
    [self setupGiftView];
}

#pragma mark - 背景
- (void)setupBGImgView {
    // 背景
    CGFloat bgImgViewW = screenWIDTH;
    CGFloat bgImgViewH = profileBackground_HEIGHT;
    CGFloat bgImgViewX = 0;
    CGFloat bgImgViewY = -bgImgViewH;
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(bgImgViewX, bgImgViewY, bgImgViewW, bgImgViewH)];
    bgImgView.image = [UIImage imageNamed:profileBackground_IMG];
    bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.tableView insertSubview:bgImgView atIndex:0];
    self.bgImgView = bgImgView;
    // 透明容器
    CGFloat bgViewW = bgImgViewW;
    CGFloat bgViewH = bgImgViewH;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgViewW, bgViewH)];
    [bgImgView addSubview:bgView];
    self.bgView = bgView;
    // 头像
    CGFloat iconImgViewX = (screenWIDTH-profileIcon_WIDTH)*0.5;
    CGFloat iconImgViewY = edgeInset_Top+navigationBarH;
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(iconImgViewX, iconImgViewY, profileIcon_WIDTH, profileIcon_HEIGHT)];
    iconImgView.image = [UIImage imageNamed:profileIcon_IMG];
    iconImgView.layer.cornerRadius = 0.5*profileIcon_WIDTH;
    iconImgView.clipsToBounds = YES;
    [bgView addSubview:iconImgView];
    // 昵称
    CGFloat nameLabelX = 0;
    CGFloat nameLabelY = CGRectGetMaxY(iconImgView.frame);
    CGFloat nameLabelW = screenWIDTH;
    CGFloat nameLabelH = 25;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH)];
    nameLabel.text = @"Cacao8Woad";
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:nameLabel];
    // 积分
    CGFloat scoreLabelX = 0;
    CGFloat scoreLabelY = CGRectGetMaxY(nameLabel.frame);
    CGFloat scoreLabelW = screenWIDTH;
    CGFloat scoreLabelH = 15;
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(scoreLabelX, scoreLabelY, scoreLabelW, scoreLabelH)];
    scoreLabel.text = @"积分:0";
    scoreLabel.font = [UIFont systemFontOfSize:13];
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:scoreLabel];
}

#pragma mark - 礼物页
- (void)setupGiftView {
    self.isSelectedGiftHidden = NO;
    self.isSelectedGuideHidden = YES;
    self.isGift = YES;
}

#pragma mark - UITableViewDataSource
// 段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section) {
        if (self.isGift) {
            if (self.lists.count) {
                return self.lists.count;
            } else {
                return 1;
            }
        } else {
            if (self.guides.count) {
                return self.guides.count;
            } else {
                return 1;
            }
        }
    }
    return 1;
}
// cell样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"Cell";
    if (indexPath.section) {
        if (self.isGift) {
            if (!self.lists.count) {
                LXEmptyCell *cell = [LXEmptyCell cellWithTableView:tableView];
                cell.placeholderLabel.text = @"喜欢的礼物将躺在这里哦";
                return cell;
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.imageView.image = [UIImage imageNamed:favoriteGift_IMG];
                    cell.textLabel.text = @"我喜欢的礼物";
                    cell.textLabel.textColor = [UIColor darkGrayColor];
#warning todo 数据待改
                    cell.detailTextLabel.text = @"0个";
                    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                }
                return cell;
            }
        } else {
            if (!self.guides.count) {
                LXEmptyCell *cell = [LXEmptyCell cellWithTableView:tableView];
                cell.placeholderLabel.text = @"喜欢的攻略将躺在这里哦";
                return cell;
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
                    cell.backgroundColor = [UIColor cyanColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                return cell;
            }
        }
    }
    LXFunctionCell *cell = [LXFunctionCell cellWithTableView:tableView];
    return cell;
}

#pragma mark - UITableViewDelegate
// 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        if (self.isGift) {
            return 80;
        } else {
            return 115;
        }
    }
    return 80;
}
// 段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section) {
        return sectionHeaderView_HEIGHT;
    }
    return CGFLOAT_MIN;
}
// 段尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return minimumSpacing;
}
// 段头视图
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section) {
        UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, sectionHeaderView_HEIGHT)];
        sectionHeaderView.backgroundColor = lineColor_LX;
        // 喜欢的礼物
        UIButton *giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat giftBtnX = 0;
        CGFloat giftBtnY = 1;// 距离tableHeaderView:10
        CGFloat giftBtnW = (screenWIDTH-1)*0.5;// 中间分割线:1
        CGFloat giftBtnH = sectionHeaderView_HEIGHT-giftBtnY-1;// 底部分割线:1
        giftBtn.frame = CGRectMake(giftBtnX, giftBtnY, giftBtnW, giftBtnH);
        giftBtn.backgroundColor = [UIColor whiteColor];
        [giftBtn setTitle:@"喜欢的礼物" forState:UIControlStateNormal];
        [giftBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [giftBtn addTarget:self action:@selector(showGift:) forControlEvents:UIControlEventTouchUpInside];
        [sectionHeaderView addSubview:giftBtn];
        // 选中标记
        CGFloat selectedGiftW = giftBtnW+1;
        CGFloat selectedGiftH = 3;
        CGFloat selectedGiftX = 0;
        CGFloat selectedGiftY = sectionHeaderView_HEIGHT-selectedGiftH;
        UIView *selectedGift = [[UIView alloc] initWithFrame:CGRectMake(selectedGiftX, selectedGiftY, selectedGiftW, selectedGiftH)];
        selectedGift.backgroundColor = [UIColor colorWithHexString:mainThemeHtmlColor];
        selectedGift.hidden = self.isSelectedGiftHidden;
        [sectionHeaderView addSubview:selectedGift];
        // 喜欢的攻略
        CGFloat guideBtnX = giftBtnW+1;
        CGFloat guideBtnY = giftBtnY;
        CGFloat guideBtnW = giftBtnW;
        CGFloat guideBtnH = giftBtnH;
        UIButton *guideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        guideBtn.frame = CGRectMake(guideBtnX, guideBtnY, guideBtnW, guideBtnH);
        guideBtn.backgroundColor = [UIColor whiteColor];
        [guideBtn setTitle:@"喜欢的攻略" forState:UIControlStateNormal];
        [guideBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [guideBtn addTarget:self action:@selector(showGuide:) forControlEvents:UIControlEventTouchUpInside];
        [sectionHeaderView addSubview:guideBtn];
        // 选中标记
        CGFloat selectedGuideX = guideBtnW;
        CGFloat selectedGuideY = selectedGiftY;
        CGFloat selectedGuideW = selectedGiftW;
        CGFloat selectedGuideH = selectedGiftH;
        UIView *selectedGuide = [[UIView alloc] initWithFrame:CGRectMake(selectedGuideX, selectedGuideY, selectedGuideW, selectedGuideH)];
        selectedGuide.backgroundColor = [UIColor colorWithHexString:mainThemeHtmlColor];
        selectedGuide.hidden = self.isSelectedGuideHidden;
        [sectionHeaderView addSubview:selectedGuide];
        return sectionHeaderView;
    }
    return [[UIView alloc] init];
}
// 喜欢的礼物
- (void)showGift:(UIButton *)sender {
    if (!self.isGift) {
        self.isSelectedGuideHidden = !self.isSelectedGuideHidden;
        self.isSelectedGiftHidden = !self.isSelectedGiftHidden;
        self.isGift = YES;
        [self.tableView reloadData];
    }
}
// 喜欢的攻略
- (void)showGuide:(UIButton *)sender {
    if (self.isGift) {
        self.isSelectedGiftHidden = !self.isSelectedGiftHidden;
        self.isSelectedGuideHidden = !self.isSelectedGuideHidden;
        self.isGift = NO;
        [self.tableView reloadData];
    }
}
// 段尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, minimumSpacing)];
    if (section) {
        footerView.backgroundColor = [UIColor whiteColor];
    } else {
        footerView.backgroundColor = bgColor;
    }
    return footerView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pulledH = -edgeInset_Top-scrollView.contentOffset.y;
    CGFloat scale = (profileBackground_HEIGHT+2*pulledH)/profileBackground_HEIGHT;
    if (fabs(pulledH) <= 40) {
        if (pulledH < 0) {
            self.bgView.transform = CGAffineTransformMakeScale(scale, scale);
        } else {
            self.bgImgView.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
}

#pragma mark - IBAction
// 扫描二维码
- (IBAction)scan2DBarCode:(UIBarButtonItem *)sender {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *imgPickerCtl = [[UIImagePickerController alloc] init];
    imgPickerCtl.sourceType = sourceType;
    imgPickerCtl.allowsEditing = YES;
    imgPickerCtl.delegate = self;
    [self.navigationController presentViewController:imgPickerCtl animated:YES completion:nil];
}
// 设置
- (IBAction)setting:(UIBarButtonItem *)sender {
    LXSettingViewController *moreCtl = [[LXSettingViewController alloc] init];
    [self.navigationController pushViewController:moreCtl animated:YES];
}

#pragma mark - UIImagePickerControllerDelegate
// 点击相册中的图片或照相机照完后点击use后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
#warning todo 识别图片中的二维码
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 点击cancel调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
