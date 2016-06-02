//
//  CSPRQuestionnaireTableCellTableViewCell.m
//  CommunityApp
//
//  Created by iss on 15/6/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "QuestionnaireTableCellTableViewCell.h"

@interface QuestionnaireTableCellTableViewCell()
@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *title;


@end

@implementation QuestionnaireTableCellTableViewCell

- (void)awakeFromNib
{
    self.bgView.layer.borderColor = COLOR_RGB(220, 220, 220).CGColor;
    self.bgView.layer.borderWidth = 1.0;
    self.bgView.layer.cornerRadius = 3.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


// 装载Cell数据
- (void)loadCellData:(QuestionnaireSurvey *)questionnaireSurvey
{
    [self.title setText:questionnaireSurvey.title];
}

@end
