//
//  EasyLiveCollectionViewCell.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"
#import "SurroundBusinessModel.h"

@interface EasyLiveCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet TQStarRatingView *starView;

/**
 * 拨号到商店Block
 */
@property (nonatomic, copy) void (^dialToStoreBlock)(void);

/**
 * 装载Cell数据
 */
- (void)loadCellData;

- (void)loadCellData:(SurroundBusinessModel *)model hideSplitLine:(BOOL)isHide;

@end
