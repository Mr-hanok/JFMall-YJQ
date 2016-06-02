//
//  ConvenienceDefaultCollectionViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/7/1.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConvenienceDefaultCollectionViewCell : UICollectionViewCell

/* 装载Cell数据
 * @parameter:array 需要包含三个数据，第一个为背景色，第二个为图像名，第三个为Title
 */
- (void)loadCellData:(NSArray *)array;

@end
