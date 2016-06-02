//
//  ContactSelect.h
//  CommunityApp
//
//  Created by iss on 15/6/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"

@protocol ContactSelectDelegate <NSObject>

@optional
- (void)setSelectedContactName:(NSString *)name andTelno:(NSString *)telno;

@end

@interface ContactSelect : BaseViewController
@property (nonatomic, copy) NSString    *strName;
@property (nonatomic, copy) NSString    *strTelno;

@property (nonatomic, assign) id<ContactSelectDelegate> delegate;

@end
