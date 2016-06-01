//
//  GoodsCollectionViewCell.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/6.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaresList.h"

@interface GoodsCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *goodsImgBtn;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;//商品特价
@property (weak, nonatomic) IBOutlet UILabel *beforePrice;//商品原价

@property (nonatomic, copy) void(^goodsImgBtnClickBlock)(void);
@property (nonatomic, copy) void(^cartBtnClickBlock)(void);
 

/**
 * 加载Cell数据
 */
- (void)loadCellData:(WaresList *)wares;

@end
