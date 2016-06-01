//
//  LimitBuyCollectionViewCell.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaresList.h"

@interface LimitBuyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *limitBuyIcon;
@property (weak, nonatomic) IBOutlet UIButton *goodsImgBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsTimer;

@property (nonatomic, retain) NSTimer   *timer;

@property (nonatomic, copy) void(^cartBtnClickBlock)(void);

// 加载Cell数据
- (void)loadCellData:(WaresList *)wares;
@property (copy,nonatomic) void (^clearTimer)(NSTimer* timer);

@end
