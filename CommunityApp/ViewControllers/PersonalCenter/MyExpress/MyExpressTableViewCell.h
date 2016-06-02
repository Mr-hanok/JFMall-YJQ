//
//  MyExpressTableViewCell.h
//  CommunityApp
//
//  Created by 酒剑 笛箫 on 15/9/21.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressOrderModel.h"

@interface MyExpressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UIButton *orderTrackBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *expressInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (nonatomic, assign) NSInteger  statusId;  // 订单状态

@property (nonatomic, copy) void(^orderTrackBlock)(void);
@property (nonatomic, copy) void(^barcodeBlock)(void);
@property (nonatomic, copy) void(^expressSearchBlock)(void);


// 加载Cell数据
- (void)LoadCellData:(ExpressOrderModel *)model;

@end
