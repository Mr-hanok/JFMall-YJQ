//
//  RoadManageCellTableViewCell.h
//  CommunityApp
//
//  Created by iss on 15/6/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoadData.h"

@interface RoadManageCellTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIButton *myButton;
@property (nonatomic, strong) IBOutlet UILabel *neighborhoodAddressLable;
@property (nonatomic, strong) IBOutlet UILabel *neighborhoodNameLable;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *authenticationLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *setDefaultBtnWidth;

/* 加载Cell数据
 * @parameter:array 路址数据 
 */
- (void)loadCellData:(RoadData *)roadData  isModify:(BOOL) isModify;
@end
