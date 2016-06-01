//
//  NewVieitorViewController.h
//  CommunityApp
//
//  Created by 张艳清 on 15/10/13.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "ManagementProtocol.h"
#import "VisitorAimViewController.h"
//时间协议

//#import "FMDatabase.h"
@interface NewVieitorViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,ManagementProtocol,UIActionSheetDelegate>
@property(strong,nonatomic)id<ManagementProtocol> delegate;
@property (nonatomic, strong) NSString *startTimeStr;
@property (nonatomic, strong) NSString *endTimeStr;
@property (nonatomic, copy) NSString    *projectId;     //项目(小区）ID
@property(nonatomic,strong)UIImageView *keyurlView;//二维码试图


@end
