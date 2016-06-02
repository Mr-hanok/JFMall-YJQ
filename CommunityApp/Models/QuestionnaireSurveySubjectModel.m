//
//  QuestionnaireSurveySubject.m
//  CommunityApp
//
//  Created by iss on 6/18/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "QuestionnaireSurveySubjectModel.h"

@implementation QuestionnaireSurveyElementModel
-(id)initWithDictionary:(NSDictionary*)dic
{
    self = [super initWithDictionary:dic];
    if (self) {
        self.title  = [dic objectForKey:@"title"];
        self.elementId = [dic objectForKey:@"elementId"];
        self.isSelected = NO;
    }

    return self;
}

@end

@implementation QuestionnaireSurveySubjectModel
-(id)initWithDictionary:(NSDictionary*)dic
{
    self = [super initWithDictionary:dic];
    if (self) {
        self.title = [dic objectForKey:@"title"];
        self.type = [dic objectForKey:@"type"];
        self.subjectId = [dic objectForKey:@"subjectId"];
        self.elements = [[NSMutableArray alloc]init];
        self.content = [[NSString alloc]init];
        //    NSMutableArray* elements =[dic objectForKey:@"elements"];
        //    for (NSDictionary* ele in elements) {
        //         [self.elements addObject: [[QuestionnaireSurveyElementModel alloc]initWithDictionary:ele]];
        //    }
    }

    return self;
}
@end
