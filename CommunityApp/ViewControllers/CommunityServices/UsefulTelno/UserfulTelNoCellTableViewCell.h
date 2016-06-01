//
//  UserfulTelNoCellTableViewCell.h
//  CommunityApp
//
//  Created by iss on 15/6/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserfulTelNoCellTableViewCell : UITableViewCell
    -(void)loadCellData:(NSArray *)array;
@property (nonatomic, copy)void(^dialCallHotLine)(void);
@end
