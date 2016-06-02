//
//  GroupBuyCollectionViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/6/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaresList.h"
#import "GrouponList.h"

// 便民购物清Timer通知
#define ClearTimerNotification  @"ClearTimerNotification"

@interface GroupBuyCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy)void(^groupBuyTimeOutBlock)(void);

- (void)loadCellData:(WaresList *)wares;

- (void)loadCellDataForGroupon:(GrouponList *)wares;

@end
