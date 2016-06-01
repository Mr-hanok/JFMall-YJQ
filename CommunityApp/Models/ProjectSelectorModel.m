//
//  ProjectSelectorModel.m
//  CommunityApp
//
//  Created by issuser on 15/7/22.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ProjectSelectorModel.h"

@implementation ProjectSelectorModel
-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if(self){
        _detailId   = [dictionary objectForKey:@"detailId"];    //ID
        _detailName = [dictionary objectForKey:@"detailName"];  //名称
    }
    return self;
}
@end
