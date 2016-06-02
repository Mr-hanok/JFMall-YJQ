//
//  MyGrouponHeaderView.m
//  CommunityApp
//
//  Created by iss on 7/20/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "MyCouponsHeaderView.h"
@interface MyCouponsHeaderView()
@property (strong,nonatomic) IBOutlet UILabel* title;
@property (strong,nonatomic) IBOutlet UILabel* validate;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *orderState;
@end
@implementation MyCouponsHeaderView


- (void)awakeFromNib {
    // Initialization code
    self.layer.borderColor = Color_Gray_RGB.CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 0.5;
    self.clipsToBounds = YES;
}

-(void)loadCellData:(NSString *)title andValidity:(NSString *)validity andOrderNo:(NSString *)orderNo andOrderState:(NSString *)orderState
{
    [_title setText:title];
    [_validate setText:[NSString stringWithFormat:@"有效期至%@",validity]];
    [_orderNo setText:orderNo];
    
    NSInteger state = [orderState integerValue];
    switch (state) {
        case 1:
            [_orderState setText:@"待处理"];
            break;
        case 2:
            [_orderState setText:@"处理中"];
            break;
        case 3:
            [_orderState setText:@"已完成"];
            break;
        case 4:
            [_orderState setText:@"已取消"];
            break;
        case 5:
            [_orderState setText:@"待付款"];
            break;
        case 6:
            [_orderState setText:@"待发货"];
            break;
        case 7:
            [_orderState setText:@"待收货"];
            break;
        case 8:
            [_orderState setText:@"待收款"];
            break;
        default:
            break;
    }
}

#pragma mark - SectionHeader点击事件处理函数
- (IBAction)sectionHeaderClickHandler:(id)sender
{
    if (self.sectionHeaderClickBlock) {
        self.sectionHeaderClickBlock();
    }
}



@end
