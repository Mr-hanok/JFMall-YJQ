//
//  StoreListCollectionViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/6/7.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreListCollectionViewCell : UICollectionViewCell

/* 装载Cell数据
 * @parameter:array 需要包含三个数据，第一个为商店图片名称，第二个为商店名，第三个为商店联系电话
 */
- (void)loadCellData:(NSArray *)array;

@end
