//
//  BuildingsServicesBuildingInfoViewControllerTableViewCell.h
//  CommunityApp
//
//  Created by iss on 6/30/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HousesServicesBuildingInfoViewControllerTableViewCell;
@protocol HousesServicesBuildingInfoViewControllerTableViewCellDelegate<NSObject>
-(void)textFiledShouldEditEnd:(HousesServicesBuildingInfoViewControllerTableViewCell*)cell inputText:(NSString*)inputText;
@end
@interface HousesServicesBuildingInfoViewControllerTableViewCell : UITableViewCell
-(void)loadCellData:(NSArray*)data;
-(void)setTextContext:(NSString*)text;
-(void)isBottom;
-(NSString*)getInputText;
@property (assign,nonatomic) id<HousesServicesBuildingInfoViewControllerTableViewCellDelegate> delegate;
@end
