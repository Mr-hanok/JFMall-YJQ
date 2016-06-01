//
//  DetailServiceTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/6/17.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailServiceTableViewCell : UITableViewCell


/* 装载Cell数据
 * @parameter:title 服务名称
 */
- (void)loadCellData:(NSString *)title;

@end
