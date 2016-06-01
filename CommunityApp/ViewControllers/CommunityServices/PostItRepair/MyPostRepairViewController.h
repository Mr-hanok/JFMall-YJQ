//
//  CSPRMyPostRepairViewController.h
//  CommunityApp
//
//  Created by iss on 15/6/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
typedef enum
{
    LeftNarvigate_ToPre=0,
    LeftNarvigate_ToRoot
} LeftNarvigate_OP;
@interface MyPostRepairViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property(strong,nonatomic) IBOutlet UITableView *myPostWorkTable;
@property(strong,nonatomic) IBOutlet UIButton *unComplateButton;
@property(strong,nonatomic) IBOutlet UIButton *complateButton;
@property(assign,nonatomic) LeftNarvigate_OP leftOp;
@end
