//
//  HouseKeepHeadCollectionReusableView.h
//  CommunityApp
//
//  Created by iss on 8/5/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseKeepHeadCollectionReusableView : UICollectionReusableView
-(void)loadHeaderCell:(NSArray*)picUrl andSetContinuous:(BOOL)isContinuous;
@end
