//
//  BuildingsServicesBuildingInfoTableViewCell.h
//  CommunityApp
//
//  Created by iss on 7/2/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuildingsServicesBuildingInfoTableViewCell : UITableViewCell
-(void)loadCellData:(NSDictionary*)data;
+(CGFloat)textWidth;
+(CGFloat)textHeightOrgin;
@end
