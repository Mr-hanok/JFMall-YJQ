//
//  PropertyBillTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/6/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillListModel.h"
typedef enum E_Cell_Type
{
    E_Cell_First,       // 第一个Cell
    E_Cell_Middle,      // 中间Cell
    E_Cell_Last         // 最后一个Cell
}eCellType;

@interface PropertyBillTableViewCell : UITableViewCell

/* 加载Cell数据
 * @parameter:array 账单数据
 * @parameter:type  cell类型
 */

- (void)loadCellData:(NSArray *)array byCellType:(eCellType)type;
- (void)loadCellModelData:(BillListModel *)model byCellType:(eCellType)type;
@end
