//
//  FleaMarketListTableViewCell.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/7.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FleaCommodityModel.h"
@interface FleaMarketListTableViewCell : UITableViewCell
-(void)loadCellData:(FleaCommodityListModel*)listModel;
@end
