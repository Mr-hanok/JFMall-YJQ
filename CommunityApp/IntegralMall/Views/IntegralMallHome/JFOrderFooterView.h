//
//  JFOrderFooterView.h
//  CommunityApp
//
//  Created by yuntai on 16/4/25.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFStoreInfoMode.h"
#import "JFGoodsInfoModel.h"
#import "JFOrderDetailModel.h"
@interface JFOrderFooterView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *orderNumTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIntegralTotalLabel;

- (void)configSectionFooterViewWithStoreModel:(JFStoreInfoMode *)store;
- (void)configSectionFooterViewWithOrderDetaliModel:(JFOrderDetailModel *)model;
@end
