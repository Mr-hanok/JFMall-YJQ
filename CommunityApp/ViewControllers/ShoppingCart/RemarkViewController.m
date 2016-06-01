//
//  RemarkViewController.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/12.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "RemarkViewController.h"

@interface RemarkViewController ()
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkTextViewHeight;

@end

@implementation RemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = @"备注";
    [self setNavBarLeftItemAsBackArrow];
    
    _remarkTextView.layer.borderColor = COLOR_RGB(220, 220, 220).CGColor;
    _remarkTextView.layer.borderWidth = 0.5;
    _remarkTextView.layer.cornerRadius = 4.0;
    
    [_remarkTextView setText:self.strRemark];
    
    // 添加手势隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}


#pragma mark - 确定按钮点击事件处理函数
- (IBAction)confirmBtnClickHandler:(id)sender
{
    if (self.writeRemarkBlock) {
        self.writeRemarkBlock(self.remarkTextView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - 手势隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}



#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
