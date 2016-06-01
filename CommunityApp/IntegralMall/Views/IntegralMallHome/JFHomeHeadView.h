//
//  JFIntegralHomeHeadView.h
//  CommunityApp
//
//  Created by yuntai on 16/4/19.
//  Copyright © 2016年 iss. All rights reserved.
//
@class JFHomeHeadView;
@protocol JFHomeHeadViewDelegate <NSObject>

- (void)jfHomeHeadView:(JFHomeHeadView *)headView buttonType:(UIButton *)btn;

@end
#import <UIKit/UIKit.h>
#import "AdView.h"
/**
 *  首页headview
 */
@interface JFHomeHeadView : UICollectionReusableView{
    AdView *ad;
}
@property (nonatomic,weak)id<JFHomeHeadViewDelegate> delegate;
/**头像*/
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
/**name*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**积分label*/
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
/**签到label*/
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
/**签到按钮*/
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
/**轮播图view*/
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UIButton *sectionTitleBtn;

@property (nonatomic,strong) void (^adImagecallBack)(NSInteger index,NSString * imageURL);

- (void)loadAdDateWithImageUrlArray:(NSMutableArray *)array
                           signDays:(NSString *)signDays
                       signIntegral:(NSString *)signIntegral
                           integral:(NSString *)integral
                       sectionTitle:(NSString *)title;
@end
