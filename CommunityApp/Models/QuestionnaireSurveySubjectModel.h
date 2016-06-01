//
//  QuestionnaireSurveySubject.h
//  CommunityApp
//
//  Created by iss on 6/18/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseModel.h"

@interface QuestionnaireSurveyElementModel : BaseModel
@property(copy,nonatomic)NSString* elementId;
@property(copy,nonatomic)NSString* title;
@property(nonatomic, assign) BOOL isSelected;
@end

@interface QuestionnaireSurveySubjectModel : BaseModel
@property(copy,nonatomic)NSString* subjectId;
@property(copy,nonatomic)NSString* title;
@property(copy,nonatomic)NSString* type;
@property(copy,nonatomic)NSString* content;
@property(readwrite,nonatomic)NSMutableArray* elements;

@end

