//
//  MyGrouponHeaderView.h
//  CommunityApp
//
//  Created by iss on 7/20/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponsHeaderView : UITableViewHeaderFooterView


@property (nonatomic, copy)void(^sectionHeaderClickBlock)(void);


-(void)loadCellData:(NSString *)title andValidity:(NSString *)validity andOrderNo:(NSString *)orderNo andOrderState:(NSString *)orderState;

@end
