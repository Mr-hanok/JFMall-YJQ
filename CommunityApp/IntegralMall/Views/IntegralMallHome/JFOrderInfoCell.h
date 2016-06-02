//
//  JFOrderInfoCell.h
//  CommunityApp
//
//  Created by yuntai on 16/4/25.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFGoodsInfoModel.h"
#import "JFOrderDetailModel.h"
/**提交订单cell*/
@interface JFOrderInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *orderImageIV;
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIntgralLabl;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;

@property (strong, nonatomic) NSIndexPath *indexPath;

+ (JFOrderInfoCell *)tableView:(UITableView *)tableView cellForRowInTableViewIndexPath:(NSIndexPath *)indexPath;

- (void)configCellWithGoodsInfoModel:(JFGoodsInfoModel *)model;
- (void)configCellWithOrderGoodsModel:(JFOrderDetailGoodsModel *)model;
@end
