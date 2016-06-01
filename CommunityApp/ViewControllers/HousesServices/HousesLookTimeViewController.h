//
//  HousesLookTimeViewController.h
//  CommunityApp
//
//  Created by iss on 7/15/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseViewController.h"
@protocol HousesLookTimeDelegate<NSObject>
-(void)selHousesLookTime:(NSString*)dateString;
@end

@interface HousesLookTimeViewController : BaseViewController
@property (assign,nonatomic)id<HousesLookTimeDelegate> delegate;
@end
