//
//  CSPRQuestionnaireTableCellTableViewCell.h
//  CommunityApp
//
//  Created by iss on 15/6/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionnaireSurvey.h"

@interface QuestionnaireTableCellTableViewCell : UITableViewCell

- (void)loadCellData:(QuestionnaireSurvey *)questionnaireSurvey;

@end
