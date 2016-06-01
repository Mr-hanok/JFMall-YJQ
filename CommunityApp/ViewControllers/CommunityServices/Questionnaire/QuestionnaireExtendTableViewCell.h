//
//  QuestionnaireExtendTableViewCell.h
//  CommunityApp
//
//  Created by issuser on 15/6/18.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionnaireSurvey.h"

typedef void(^JoinQuestionnaireBtnClickBlock)(void);

@interface QuestionnaireExtendTableViewCell : UITableViewCell

@property (nonatomic, copy) JoinQuestionnaireBtnClickBlock  block;


- (void)loadCellData:(QuestionnaireSurvey *)questionnaireSurvey;

- (void)registJoinQuestionnairBlock:(JoinQuestionnaireBtnClickBlock)block;

@end
