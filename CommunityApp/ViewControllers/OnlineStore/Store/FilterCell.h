//
//  FilterCell.h
//  CommunityApp
//
//  Created by issuser on 15/8/21.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCell : UITableViewCell
- (void)loadCellData:(NSString *)filterName isSelected:(BOOL)isSel;
@end
