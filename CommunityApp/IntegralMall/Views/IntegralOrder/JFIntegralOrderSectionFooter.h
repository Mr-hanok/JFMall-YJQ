//
//  JFIntegralOrderSectionFooter.h
//  CommunityApp
//
//  Created by yuntai on 16/5/3.
//  Copyright © 2016年 iss. All rights reserved.
//
@class JFIntegralOrderSectionFooter;
@protocol IntegralOrderSectionoFooterDelegate <NSObject>

- (void)integralOrderSectionoFooterFollowOrderBtn:(JFIntegralOrderSectionFooter *)footer  section:(NSInteger)section;
- (void)integralOrderSectionoFooterCancalOrderBtn:(JFIntegralOrderSectionFooter *)footer  section:(NSInteger)section button:(UIButton *)btn;
- (void)integralOrderSectionoFooterSureReceiveBtn:(JFIntegralOrderSectionFooter *)footer  section:(NSInteger)section button:(UIButton *)btn;

@end
#import <UIKit/UIKit.h>
#import "JFIntegralOrderViewController.h"
@interface JFIntegralOrderSectionFooter : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *totalIntegralLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
- (void)configSectionFooterViewWithOrderSlideType:(OrderSlideType)type section:(NSInteger)section;
@property (nonatomic, weak)id<IntegralOrderSectionoFooterDelegate> delegate;
@end
