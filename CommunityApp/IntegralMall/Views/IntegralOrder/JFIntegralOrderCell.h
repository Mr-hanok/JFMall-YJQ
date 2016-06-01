//
//  JFIntegralOrderCell.h
//  CommunityApp
//
//  Created by yuntai on 16/5/3.
//  Copyright © 2016年 iss. All rights reserved.
//
@class JFIntegralOrderCell;
@protocol JFIntegralOrderCellDelegate <NSObject>

- (void)integralOrderCell:(JFIntegralOrderCell *)cell numberOfItemsInTableViewIndexPath:(NSIndexPath *)indexpath;

- (void)integralOrderCell:(JFIntegralOrderCell *)cell OrderFollowIndexPath:(NSIndexPath *)indexpath;
- (void)integralOrderCell:(JFIntegralOrderCell *)cell cancalOrderIndexPath:(NSIndexPath *)indexpath;
- (void)integralOrderCell:(JFIntegralOrderCell *)cell confirmOrderIndexPath:(NSIndexPath *)indexpath;
- (void)integralOrderCell:(JFIntegralOrderCell *)cell delOrderIndexPath:(NSIndexPath *)indexpath;
@end
#import <UIKit/UIKit.h>
#import "JFOrderModel.h"

@interface JFIntegralOrderCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageIV;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *specLabel;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancalBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancalBtnWith;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *followBtnWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmBtnWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bTob;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bTob2;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *delBtnWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bTob3;

@property (nonatomic, strong) UICollectionView *collectview;
@property (strong, nonatomic) NSIndexPath *tableViewIndexPath;
@property (nonatomic, weak)id<JFIntegralOrderCellDelegate> delegate;

+ (JFIntegralOrderCell *)tableView:(UITableView *)tableView cellForRowInTableViewIndexPath:(NSIndexPath *)tableViewIndexPath  delegate:(id)object;
- (void)configCellWithOrderModel:(JFOrderModel *)model;
@end
