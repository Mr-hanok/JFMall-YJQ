//
//  StoreCollectionViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/6/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaresList.h"


@interface StoreCollectionViewCell : UICollectionViewCell

/* 装载Cell数据
 * @parameter:
 */
- (void)loadCellData:(WaresList *)model byIsHomeView:(BOOL)isHome forCellId:(NSInteger)cellId andTotalCount:(NSInteger)count;

@end
