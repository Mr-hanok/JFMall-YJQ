//
//  EverydayDiscountTableViewCell.m
//  CommunityApp
//
//  Created by iss on 15/6/30.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "EverydayDiscountTableViewCell.h"
#import "UIImageView+AFNetworking.h"


@interface EverydayDiscountTableViewCell()

@property (retain, nonatomic) IBOutlet UIView *goodsView;
@property (retain, nonatomic) IBOutlet UIImageView *goodsIcon;
@property (retain, nonatomic) IBOutlet UILabel *goodsName;
@property (retain, nonatomic) IBOutlet UILabel *goodsDescription;
@property (retain, nonatomic) IBOutlet UILabel *goodsPrice;
@property (retain, nonatomic) IBOutlet UIButton *buyNow;

@end

@implementation EverydayDiscountTableViewCell

- (void)awakeFromNib {
    [self initWidgetStyle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadCellData:(WaresDetail *)model setBtnTag:(NSInteger)tag{
    // 传入展示参数
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:model.goodsUrl]];
    [self.goodsIcon setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    [self.goodsName setText:model.goodsName];
    [self.goodsDescription setText:model.goodsDescription];
    [self.goodsPrice setText:[NSString stringWithFormat:@"￥%@",model.goodsActualPrice]];
    
    // 设置按钮标签
    self.buyNow.tag = tag;
}

- (void)loadCellData:(WaresList *)wares
{
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:wares.goodsUrl]];
    [self.goodsIcon setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    
    [self.goodsName setText:wares.goodsName];
    [self.goodsDescription setText:wares.goodsDescription];
    [self.goodsPrice setText:[NSString stringWithFormat:@"￥%@",wares.goodsPrice]];
}

- (void)initWidgetStyle {
    // View边框样式
    self.goodsView.layer.borderWidth = 1;
    self.goodsView.layer.cornerRadius = 8;
    self.goodsView.layer.masksToBounds = YES;
    self.goodsView.layer.borderColor = [[UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1] CGColor];
    // button样式
    self.buyNow.layer.borderWidth = 0.5;
    self.buyNow.layer.cornerRadius = 4;
    self.buyNow.layer.borderColor = [UIColor colorWithRed:236/255.0 green:68/255.0 blue:17/255.0 alpha:1].CGColor;
    self.buyNow.layer.backgroundColor =[UIColor whiteColor].CGColor;
    [self.buyNow setTitle:@"立即抢购" forState:UIControlStateNormal];
}

#pragma mark - 立即抢购按钮点击事件处理函数
- (IBAction)buyNowBtnClickHandler:(id)sender
{
    if (self.buyNowBtnClickBlock) {
        self.buyNowBtnClickBlock();
    }
}


@end
