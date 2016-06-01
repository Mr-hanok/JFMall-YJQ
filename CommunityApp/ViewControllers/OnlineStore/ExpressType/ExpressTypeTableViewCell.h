//
//  ExpressTypeTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressTypeModel.h"

@interface ExpressTypeTableViewCell : UITableViewCell
- (void)loadCellData:(ExpressTypeModel *)model;
@end
