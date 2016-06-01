//
//  AfterSaleHistoryTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/7/24.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AfterSaleDealRecordDetail.h"
#define FOOTVIEWHEIGHT 50.f
#define CONTENTVIEWHEIGHT 43.f
#define BGVIEWHEIGHT 165.f
#define BUTTOMMARGIN 10.f
@interface AfterSaleHistoryTableViewCell : UITableViewCell
-(void)loadCellData:(AfterSaleDealRecordDetail*)cellData;
@end
