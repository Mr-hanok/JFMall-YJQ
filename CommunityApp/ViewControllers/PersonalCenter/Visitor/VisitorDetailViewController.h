//
//  VisitorDetailViewController.h
//  CommunityApp
//
//  Created by 张艳清 on 15/10/13.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "VisityList.h"
#import "visitorsModel.h"

@interface VisitorDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
@property(nonatomic,retain)visitorsModel *model;
@property(nonatomic,strong)UIImageView *keyurlView;
//@property(nonatomic,copy)UIImageView *keyurlViewcopy;

@end
