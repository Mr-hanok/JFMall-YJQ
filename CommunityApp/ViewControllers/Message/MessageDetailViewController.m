//
//  MessageDetailViewController.m
//  CommunityApp
//
//  Created by iss on 8/18/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "MessageDetailViewController.h"

@implementation MessageDetailViewController

- (void)viewDidLoad {
    
    NSString*ulrStr=[[NSString alloc]init];
    NSString *userid = [[LoginConfig Instance]userID];
    ulrStr=[NSString stringWithFormat:@"%@property_GbSlideInfo_showDetailsClientPage.do?userId=%@&newsId=%@",Service_Address,userid,self.messageMsgid];
    NSLog(@"%@",ulrStr);
    self.url = ulrStr;
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"消息详情";
}

@end

