//
//  CategorySelectedViewController.h
//  CommunityApp
//
//  Created by iss on 15/6/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"

@interface CategorySelectedViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) NSString* serviceName;
@end
