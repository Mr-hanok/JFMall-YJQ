//
//  JFIntegralOrderSectionFooter.m
//  CommunityApp
//
//  Created by yuntai on 16/5/3.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFIntegralOrderSectionFooter.h"

@interface JFIntegralOrderSectionFooter ()
@property (nonatomic,assign)NSInteger *section;
@end
@implementation JFIntegralOrderSectionFooter
- (void)configSectionFooterViewWithOrderSlideType:(OrderSlideType)type section:(NSInteger)section{
    switch (type) {
        case OrderSlideTypeAll://全部记录
            self.followBtn.hidden = NO;
            self.orderBtn.hidden = NO;
            [self.orderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            break;
            
        case OrderSlideTypeSend://待发货
            self.followBtn.hidden = YES;
            self.orderBtn.hidden = NO;
            [self.orderBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            break;
            
        case OrderSlideTypeReceive://待收货
            self.followBtn.hidden = NO;
            self.orderBtn.hidden = NO;
            [self.orderBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            break;
            
        case OrderSlideTypeComplete://完成
            self.followBtn.hidden = YES;
            self.orderBtn.hidden = YES;
            break;
    }
    self.section = section;
    self.totalIntegralLabel.text = [NSString stringWithFormat:@"总计:%@积分",@"2000"];
}
- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 101://物流跟踪
            if ([_delegate respondsToSelector:@selector(integralOrderSectionoFooterFollowOrderBtn:section:)]) {
                [_delegate integralOrderSectionoFooterFollowOrderBtn:self section:self.section];
            }
            break;
            
        case 102://订单
            if ([sender.titleLabel.text isEqualToString:@"取消订单"]) {
                [_delegate integralOrderSectionoFooterCancalOrderBtn:self section:self.section button:sender];
            }else{
                [_delegate integralOrderSectionoFooterSureReceiveBtn:sender section:self.section button:sender];
            }
            break;
    }
}


@end
