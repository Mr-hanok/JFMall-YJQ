//
//  SearchAddressViewController.h
//  CommunityApp
//
//  Created by Andrew on 15/8/29.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchAddressViewController : BaseViewController

@property (nonatomic, copy) void (^didFinishSelectAddress)(NSDictionary *addressInfo);
@property (nonatomic, strong) NSString *projectId;

@end
