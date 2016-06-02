//
//  QuestionContentListViewController.h
//  CommunityApp
//
//  Created by iss on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//  问卷调查内容

#import "BaseViewController.h"

@interface QuestionContentListViewController : BaseViewController
@property(copy,nonatomic)NSString* qid;
@property(copy,nonatomic)NSString* investigatorName;
@property(copy,nonatomic)NSString* investigatorTel;
@end
