//
//  PersonalCenterBaseInfoViewController.h
//  CommunityApp
//
//  Created by iss on 6/8/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseViewController.h"

@protocol SetMyAvatarImgDelegate <NSObject>

@optional
- (void)setMyAvatarImg:(UIImage *)avatar;

@end

@interface PersonalCenterBaseInfoViewController : BaseViewController

@property (nonatomic, assign) id<SetMyAvatarImgDelegate> delegate;
@property (nonatomic, retain) UIImage   *myAvatarImg;

@end
