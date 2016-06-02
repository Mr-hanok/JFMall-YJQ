//
//  PersonalCenterMyOrderFooterView.h
//  CommunityApp
//
//  Created by iss on 7/8/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonalCenterMyOrderFooterView;
@protocol PersonalCenterMyOrderFooterViewDelegate<NSObject>
-(void)toPay:(id)Sender;
-(void)toRefund:(id)Sender;
-(void)toTrace:(id)Sender;
-(void)toComment:(id)Sender;
-(void)toAccepted:(id)Sender;
-(void)toCancel:(id)Sender;
@end

@interface PersonalCenterMyOrderFooterView : UITableViewHeaderFooterView
@property (strong,nonatomic) NSArray* btnArray;
-(void)setViewWithTag:(NSInteger)tag;
@property (assign,nonatomic)id<PersonalCenterMyOrderFooterViewDelegate> delegate;
@property(strong,nonatomic)UIButton *fixbtn;//11-27
@end
