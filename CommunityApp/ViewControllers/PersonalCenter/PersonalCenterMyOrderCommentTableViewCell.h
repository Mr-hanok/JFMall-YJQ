//
//  PersonalCenterMyOrderCommentTableViewCell.h
//  CommunityApp
//
//  Created by iss on 8/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonalCenterMyOrderCommentTableViewCell;
@protocol PersonalCenterMyOrderCommentDelegate<NSObject>
-(void)toComment:(PersonalCenterMyOrderCommentTableViewCell*)cell;
@end
@interface PersonalCenterMyOrderCommentTableViewCell : UITableViewCell
@property (assign,nonatomic)id<PersonalCenterMyOrderCommentDelegate>delegate;
-(void)loadCellData:(NSString*) wareName img:(NSString*)imgUrl isButtom:(BOOL)isButtom;
- (void)setCanComment:(BOOL)isCanComment;
@end
