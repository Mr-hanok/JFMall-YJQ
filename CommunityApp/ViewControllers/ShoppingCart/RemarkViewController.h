//
//  RemarkViewController.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/12.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"

@interface RemarkViewController : BaseViewController

@property (nonatomic, copy) NSString *strRemark;

@property (nonatomic, copy) void(^writeRemarkBlock)(NSString *remark);

@end
