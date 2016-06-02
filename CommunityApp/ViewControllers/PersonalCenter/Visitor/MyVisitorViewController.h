//
//  MyVisitorViewController.h
//  CommunityApp
//
//  Created by 张艳清 on 15/10/13.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "NewVieitorViewController.h"

@interface MyVisitorViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
@property (nonatomic,retain)NSMutableArray *dataSouce;

//@property(nonatomic,copy)NSString*currentTime;
- (void) visitorList;
@end
