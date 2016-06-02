//
//  JsonRequest.h
//  CommonApp
//
//  Created by lipeng on 16/3/20.
//  Copyright © 2016年 common. All rights reserved.
//

#import "ComRequest.h"

@protocol JsonRequestDelegate <RequestDelegate>

@required
- (Class)modelClass;

@end

@interface JsonRequest : ComRequest <JsonRequestDelegate, ResponseDelegate>

@property(nonatomic, assign) id<JsonRequestDelegate> jsonReqDelegate;

@end
