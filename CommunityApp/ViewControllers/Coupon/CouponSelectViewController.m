//
//  CouponSelectViewController.m
//  CommunityApp
//
//  Created by issuser on 15/8/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "CouponSelectViewController.h"
#import "CouponTableViewCell.h"

#define CouponTableViewCellNibName @"CouponTableViewCell"


@interface CouponSelectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic)NSMutableArray *couponDataArray;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic, strong) NSMutableArray *selectCoupons;    /**< 已选择的优惠券 */
@property(nonatomic,assign)BOOL checkBtn;
@end

@implementation CouponSelectViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Str_Select_Coupon_Title;
    self.couponDataArray = [[NSMutableArray alloc]init];
    [self setNavBarLeftItemAsBackArrow];
    
    // 注册cell
    UINib *nibForCouponSelectViewService = [UINib nibWithNibName:CouponTableViewCellNibName bundle:[NSBundle mainBundle]];
//    self.tableView.allowsMultipleSelection = YES;
    [self.tableView registerNib:nibForCouponSelectViewService forCellReuseIdentifier:CouponTableViewCellNibName];
    [self getCouponDataFromServer];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.couponDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CouponTableViewCellNibName forIndexPath:indexPath ];
    Coupon *coupon = [self.couponDataArray objectAtIndex:indexPath.row];
    [cell loadCellData:coupon withIsSelectCoupon:YES];
    cell.checkBoxBtn.selected = coupon.isSelected;
#pragma mark-2015.11.10
    //
    if ([self.selectCoupons containsObject:coupon]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}
#pragma mark-cell中的按钮选中设置
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Coupon *coupon = [self.couponDataArray objectAtIndex:indexPath.row];
    if ([coupon.ticketstype isEqualToString:@"5"]) {
        CouponTableViewCell *cell = (CouponTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];       
        [cell.checkBoxBtn setSelected:!cell.checkBoxBtn.selected];
        coupon.isSelected = cell.checkBoxBtn.selected;
        if (coupon.isSelected) {
            if (![self.selectCoupons containsObject:coupon]) {
                [self.selectCoupons addObject:coupon];
            }
        }
        else {
            if ([self.selectCoupons containsObject:coupon]) {
                [self.selectCoupons removeObject:coupon];
            }
        }
    }else {
        if (coupon.isSelected) {
            if ([self.selectCoupons containsObject:coupon]) {
                coupon.isSelected = NO;
                [self.selectCoupons removeObject:coupon];
            }
        }
        else {
            NSMutableArray *delArray = [NSMutableArray array];
            for (Coupon *selectCoupon in self.selectCoupons) {
                if (![selectCoupon.ticketstype isEqualToString:@"5"]) {
                    selectCoupon.isSelected = NO;
                    [delArray addObject:selectCoupon];
                }
            }
            [self.selectCoupons removeObjectsInArray:delArray];
            
            if (![self.selectCoupons containsObject:coupon]) {
                coupon.isSelected = YES;
                [self.selectCoupons addObject:coupon];
            }
        }
    }
    [tableView reloadData];
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self.selectCoupons removeObject:self.couponDataArray[indexPath.row]];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 从服务器取得 优惠券列表 数据
- (void)getCouponDataFromServer {
    if (![self isGoToLogin]) {
        return;
    }
    
    NSString *userId = [[LoginConfig Instance] userID];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    
    if (self.goodsId == nil || [self.goodsId isEqualToString:@""]) {
        return;
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[projectId, self.goodsId, userId] forKeys:@[@"projectId", @"goodsId",@"userId"]];
    
    [self getArrayFromServer:GetCouponsInfo_Url path:GetCouponsInfo_Path method:@"GET" parameters:dic xmlParentNode:@"coupons" success:^(NSMutableArray *result) {
        [self.couponDataArray removeAllObjects];
        for (NSDictionary *dic in result) {
            Coupon *coupon = [[Coupon alloc] initWithDictionary:dic];
            if (![self.otherSelectCouponIds containsObject:coupon.cpId]) {
                [self.couponDataArray addObject:coupon];
            }
            if ([self.selectCouponIds containsObject:coupon.cpId]) {
                [self.selectCoupons addObject:coupon];
                coupon.isSelected = YES;
            }
        }
        [self.tableView reloadData];
        if (_couponDataArray.count == 0) {
            [Common showBottomToast:@"暂无数据"];
        }

    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
    
    
//    NSString *userId = [[LoginConfig Instance] userID];
//    
//    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[@"1", self.goodsId, userId] forKeys:@[@"type", @"goodsId", @"userId"]];
//    
//    [self getArrayFromServer:CouponList_Url path:CouponList_Path method:@"GET" parameters:dic xmlParentNode:@"result" success:^(NSMutableArray *result) {
//        [self.couponDataArray removeAllObjects];
//        for (NSDictionary *dic in result) {
//            [self.couponDataArray addObject:[[Coupon alloc] initWithDictionary:dic]];
//        }
//        [self.tableView reloadData];
//        if (_couponDataArray.count == 0) {
//            [Common showBottomToast:@"暂无数据"];
//        }
//    } failure:^(NSError *error) {
//        [Common showBottomToast:Str_Comm_RequestTimeout];
//    }];
}

#pragma mark - 确定按钮事件处理函数
- (IBAction)confirmBtnClickHandler:(id)sender
{
    if (self.selectCoupons.count > 1) {
        Coupon *coupon = [self.selectCoupons firstObject];
        BOOL doHaveDifCoupon = NO;
        for (NSInteger i = 1; i < self.selectCoupons.count; i ++) {
            Coupon *currentCoupon = self.selectCoupons[i];
            if (![currentCoupon.ticketstype isEqualToString:coupon.ticketstype]) {
                doHaveDifCoupon = YES;
                break;
            }
        }
        if (doHaveDifCoupon) {
            [Common showBottomToast:@"亲，福利券和代金券不能同时使用哦！"];
            return;
        }
    }
    if (self.selectCouponsBlock) {
        self.selectCouponsBlock(self.selectCoupons);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)selectCoupons
{
    if (!_selectCoupons) {
        _selectCoupons = [[NSMutableArray alloc] init];
    }
    return _selectCoupons;
}

@end