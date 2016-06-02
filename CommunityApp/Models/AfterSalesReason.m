//
//  AfterSalesReason.m
//  CommunityApp
//
//  Created by issuser on 15/7/28.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "AfterSalesReason.h"

@implementation AfterSalesReason
-(id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    
    if(self){
        self.afterSalesReasonId = [dictionary objectForKey:@"afterSalesReasonId"];
        self.afterSalesReasonName = [dictionary objectForKey:@"afterSalesReasonName"];
    }
    
    return self;
}
@end
