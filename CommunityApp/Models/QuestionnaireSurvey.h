//
//  QuestionnaireSurvey.h
//  CommunityApp
//
//  Created by iss on 15/6/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseModel.h"

@interface QuestionnaireSurvey :BaseModel
  @property (nonatomic, copy) NSString *mpqid;
  @property (nonatomic, copy) NSString *title;
  @property (nonatomic, copy) NSString *questionDescription;
  @property (nonatomic, copy) NSString *starttime;
  @property (nonatomic, copy) NSString *endtime;
//🍎
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *tel;

@end
