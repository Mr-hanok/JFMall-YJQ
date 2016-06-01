//
//  CommonHeaderView.m
//  CommunityApp
//
//  Created by issuser on 15/6/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "CommonHeaderView.h"

@interface  CommonHeaderView()
@property (nonatomic, retain) IBOutlet UIButton *leftTitle;
@property (nonatomic, retain) IBOutlet UIButton *rightBtn;
@property (nonatomic, retain) IBOutlet UIButton *leftBtn;

@property (strong, nonatomic) SectionBtnClickBlock btnClickBlock;

@end

@implementation CommonHeaderView

- (void)awakeFromNib {
    // Initialization code
}

// 加载Header数据 设置SectionHeader的背景图片和文字
- (void)loadHeaderData:(NSArray *)array
{
//    [self.leftBtn setBackgroundColor:[array objectAtIndex:0]];
//    [self.leftTitle setTitle:[array objectAtIndex:1] forState:UIControlStateNormal];
}

// 注册右侧箭头按钮点击事件Block
- (void)registBtnClickCallBack:(SectionBtnClickBlock)block
{
    self.btnClickBlock = block;
}


// 右侧按钮点击Action函数
- (IBAction)rightBtnClick:(UIButton *)sender {
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
}

@end
