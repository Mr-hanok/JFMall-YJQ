//
//  BenefitPeopleCollectionViewCell.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdImgSlideInfo.h"

#define BTN_TAG_BENEFIT         1
#define BTN_TAG_GROUPBUY        2
#define BTN_TAG_FLEAMARKET      3
#define BTN_TAG_LIMITBUY        4

@interface BenefitPeopleCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;

@property (weak, nonatomic) IBOutlet UIImageView *topLine;

@property (weak, nonatomic) IBOutlet UIButton *grouponBtn;
@property (weak, nonatomic) IBOutlet UIButton *limitBuyBtn;

/**
 * 惠民区域功能选择(点击事件)Block函数
 */
@property (nonatomic, copy)void(^selectFunctionAreaBlock)(NSInteger);


// 加载Cell数据
- (void)loadCellDataForGroupon:(AdImgSlideInfo *)groupon andLimitBuy:(AdImgSlideInfo *)limitBuy;

@end
