//
//  HousesDescriptionTableViewCell.h
//  CommunityApp
//
//  Created by iss on 15/6/30.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HousesDescriptionTableViewCell;
@protocol HousesDescriptionTableViewCellDelegate <NSObject>
- (void)textViewCell:(HousesDescriptionTableViewCell *)cell didChangeText:(NSString *)text;
@end

@interface HousesDescriptionTableViewCell : UITableViewCell
@property (strong,nonatomic)NSString * placeholder;
- (void) setTitleText:(NSString*)titleText DetailText:(NSString*)detailText;
@property (weak, nonatomic) id<HousesDescriptionTableViewCellDelegate> delegate;
-(CGFloat) getCellHeight;
+(CGFloat) getCellHeightByString:(NSString*)input;
@end
