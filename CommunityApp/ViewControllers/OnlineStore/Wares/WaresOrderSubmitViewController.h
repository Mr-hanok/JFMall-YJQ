//
//  WaresOrderSubmitViewController.h
//  CommunityApp
//
//  Created by iss on 8/18/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "WaresDetail.h"

@interface WaresOrderSubmitViewController : BaseViewController
@property (strong, nonatomic) WaresDetail   *waresDetail;
@property (nonatomic, strong) NSArray *paymentTypes;
@property (nonatomic, strong) NSString *remainCount;

@end
