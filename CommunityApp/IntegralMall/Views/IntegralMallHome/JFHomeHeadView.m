//
//  JFIntegralHomeHeadView.m
//  CommunityApp
//
//  Created by yuntai on 16/4/19.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFHomeHeadView.h"
#import <UIImageView+WebCache.h>

@interface JFHomeHeadView()

@end
@implementation JFHomeHeadView

- (void)awakeFromNib {

    //设置头像圆形 签到按钮圆角
    self.headImageView.layer.cornerRadius = self.headImageView.bounds.size.width/2;
    self.headImageView.layer.masksToBounds = YES;
    self.signBtn.layer.cornerRadius = 5;
    self.signBtn.layer.masksToBounds = YES;
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)loadAdDateWithImageUrlArray:(NSMutableArray *)array signDays:(NSString *)signDays signIntegral:(NSString *)signIntegral integral:(NSString *)integral sectionTitle:(NSString *)title{
    ad = [AdView adScrollViewWithFrame:CGRectMake(0, 0.5, APP_SCREEN_WIDTH, self.adView.height-1) imageLinkURL:array placeHoderImageName:@"AdSlideDefaultImg" pageControlShowStyle:UIPageControlShowStyleCenter];
    ad.adMoveTime = 2.5f;
    __weak typeof(self) weakself = self;
    ad.callBack = ^(NSInteger index,NSString * imageURL)
    {
        weakself.adImagecallBack(index,imageURL);
    };
    ;
    [self.adView addSubview:ad];
    
    [self.signBtn setTitle:[NSString stringWithFormat:@"今日签到+%@",signIntegral] forState:UIControlStateNormal];
    self.signLabel.text = [NSString stringWithFormat:@"您已连续签到%@天",signDays];
    self.integralLabel.text = [NSString stringWithFormat:@"%@积分",integral];
    [self.sectionTitleBtn setTitle:title forState:UIControlStateNormal];
    
    LoginConfig *login = [LoginConfig Instance];
    self.nameLabel.text = [login userName];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[login userIcon]] placeholderImage:[UIImage imageNamed:@"ShopCartWaresDefaultImg"]];

}


#pragma mark - eventclick
- (IBAction)butionClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(jfHomeHeadView:buttonType:)]) {
        [self.delegate jfHomeHeadView:self buttonType:sender];
    }
}
@end
