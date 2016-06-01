//
//  PersonalCenterMyOrderHeadView.h
//  CommunityApp
//
//  Created by iss on 7/8/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "OrderModel.h"
@interface PersonalCenterMyOrderHeadView : UITableViewHeaderFooterView


@property (strong,nonatomic) NSString *orderstr;

//-(void) setCommodityCell:(materialsModel *)data  totalPrice:(NSString*)total;
-(void)setHeadText:(NSString *)time orderId:(NSString*)Id state:(NSString*)state;
-(void)setViewFrame:(CGRect)frame;
@end
