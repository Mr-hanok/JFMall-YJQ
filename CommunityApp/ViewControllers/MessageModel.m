//
//  MessageModel.m
//  CommunityApp
//
//  Created by lsy on 15/12/6.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "MessageModel.h"
@implementation MessageModel

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];

    if (self) {
        //        _slideInfoId = [dictionary objectForKey:@"slideInfoId"];
        _createTimeString = [dictionary objectForKey:@"createTime"];
        _msgIdString = [dictionary objectForKey:@"msgId"];
        _msgTypeString = [dictionary objectForKey:@"msgType"];
        _newsReadString = [dictionary objectForKey:@"newsRead"];
        _newsTypeString = [dictionary objectForKey:@"newsType"];
        _pictureString = [dictionary objectForKey:@"picture"];
        _pushStatusString = [dictionary objectForKey:@"pushStatus"];
        _titlelString = [dictionary objectForKey:@"titlel"];
        _contentString = [dictionary objectForKey:@"content"];
        _toModuleString = [dictionary objectForKey:@"toModule"];
        _toTypeString = [dictionary objectForKey:@"toType"];
        _urlString = [dictionary objectForKey:@"url"];

    }

    return self;
}

@end
