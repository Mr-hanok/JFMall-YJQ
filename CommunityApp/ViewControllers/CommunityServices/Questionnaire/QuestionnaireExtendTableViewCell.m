//
//  QuestionnaireExtendTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/6/18.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "QuestionnaireExtendTableViewCell.h"

@interface QuestionnaireExtendTableViewCell()
@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UILabel *desc;

@end

@implementation QuestionnaireExtendTableViewCell

- (void)awakeFromNib {
    self.bgView.layer.borderColor = COLOR_RGB(220, 220, 220).CGColor;
    self.bgView.layer.borderWidth = 1.0;
    self.bgView.layer.cornerRadius = 3.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 加载Cell数据
- (void)loadCellData:(QuestionnaireSurvey *)questionnaireSurvey
{
    [self.title setText:questionnaireSurvey.title];
    [self.desc setText:questionnaireSurvey.questionDescription];
}


// 点击参与按钮点击事件处理函数
- (IBAction)joinBtnClickHandler:(id)sender
{
    if (self.block) {
        self.block();
    }
}


- (void)registJoinQuestionnairBlock:(JoinQuestionnaireBtnClickBlock)block
{
    self.block = block;
}

@end
