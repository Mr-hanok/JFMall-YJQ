//
//  VisitorAimViewController.h
//  CommunityApp
//
//  Created by 张艳清 on 15/10/13.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "ManagementProtocol.h"


@interface VisitorAimViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
@property(strong,nonatomic)id<ManagementProtocol> delegate;


@end
