//
//  JFGoodsImageTextDetailController.m
//  CommunityApp
//
//  Created by yuntai on 16/5/3.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFGoodsImageTextDetailController.h"

@interface JFGoodsImageTextDetailController ()


@end

@implementation JFGoodsImageTextDetailController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    
}

#pragma mark - 协议名

#pragma mark - event response
/**购物车按钮*/
- (IBAction)shopCarBtnClick:(UIButton *)sender {
    [self pushWithVCClassName:@"JFShoppingCarViewController" properties:@{@"title":@"购物车"}];
}
/**加入购物车*/
- (IBAction)joinShopCarBtnClick:(UIButton *)sender {
}
/**立即兑换*/
- (IBAction)convertBtnClick:(UIButton *)sender {
    [self pushWithVCClassName:@"JFCommitOrderViewController" properties:@{@"title":@"提交订单"}];
}
#pragma mark - private methods
@end
