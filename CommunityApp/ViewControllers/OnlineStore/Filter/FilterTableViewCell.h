//
//  FilterTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableViewCell : UITableViewCell

/* 加载Cell数据
 * @parameter:type 过滤条件
 */
- (void)loadCellData:(NSString *)type;

@end
