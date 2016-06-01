//
//  SurroundBusinessTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/6/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SurroundBusinessTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "TQStarRatingView.h"

@interface SurroundBusinessTableViewCell()

@property (retain, nonatomic) IBOutlet UIImageView *icon;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *telno;
@property (retain, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet TQStarRatingView *starView;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storeNameWidth;

@end

@implementation SurroundBusinessTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

// 装载Cell数据
- (void)loadCellData:(SurroundBusinessModel *)model
{
    [self.telno setText:model.phone];
    [self.distance setText:model.distance];
    
    _starView.isEdit = FALSE;
    
    NSArray* imgsArray =  [model.businessPicUrl componentsSeparatedByString:@","];
    if(imgsArray != nil && imgsArray.count > 0)
    {
        NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:[imgsArray objectAtIndex:0]]];
        [self.icon setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"BusinessDefaultImg"]];
    }
    
    
    CGFloat width = [Common labelDemandWidthWithText:model.businessName font:[UIFont systemFontOfSize:15.0] size:CGSizeMake(Screen_Width-187, 21)];
    self.storeNameWidth.constant = width;
    [self.name setText:model.businessName];
    [self.addrLabel setText:model.address];
    [self setDialToStoreBlock:^{
        NSString *dialTel = [NSString stringWithFormat:@"tel://%@", model.phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialTel]];
    }];
    
    [self.distance setText:model.distance];
    
    [_starView setScore:[model.score floatValue]/kNUMBER_OF_STAR withAnimation:NO];
    
    // 插入标签
//    NSArray *strings = @[@"西餐", @"澳洲牛排", @"一品香锅", @"澳洲牛排", @"一品香锅"];
    NSArray *strings = [model.label componentsSeparatedByString:@"|"];
    [self insertLabelForStrings:strings toView:self.labelView andMaxWidth:Screen_Width-207];
    
}

// 为指定字符串数组添加标签 For吃喝玩乐列表
-(void)insertLabelForStrings:(NSArray *)strings toView:(UIView *)view andMaxWidth:(CGFloat)maxWidth
{
    CGFloat labelHeight = 18.0;                 // 标签高度
    CGFloat labelMargin = 3.0;                  // 标签之间的Margin
    CGFloat additionalWidth = 4.0;              // label附加宽度
    UIFont  *font = [UIFont systemFontOfSize:12.0];  // 字体大小
    
    [Common insertLabelForStrings:strings toView:view andViewHeight:27.0 andMaxWidth:maxWidth andLabelHeight:labelHeight andLabelMargin:labelMargin andAddtionalWidth:additionalWidth andFont:font andBorderColor:Color_Comm_LabelBorder andTextColor:COLOR_RGB(120, 120, 120)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
