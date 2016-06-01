//
//  HouseLookTimeDateViewController.h
//  CommunityApp
//
//  Created by iss on 7/16/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseViewController.h"
@protocol HouseLookTimeDateDelegate<NSObject>
-(void)selHouseLookTimeDate:(NSString*)dateString;
@end
@interface HouseLookTimeDateViewController : BaseViewController
@property (assign,nonatomic)id<HouseLookTimeDateDelegate> delegate;
@end
