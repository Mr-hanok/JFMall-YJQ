//
//  ComRequest.h
//  CommonApp
//
//  Created by lipeng on 16/3/8.
//  Copyright © 2016年 common. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequestDelegate <NSObject>

@required
- (NSString *)requestPath;

@end

@protocol ResponseDelegate <NSObject>

- (id)buildResponse:(id)responseData;

@end

@class ComRequest;

typedef void (^SuccessBlock)(id data);
typedef void (^FailedBlock)(NSError *error);

@interface ComRequest : NSObject <RequestDelegate>

@property(nonatomic, copy) NSString *urlPathString;
@property(nonatomic, assign) id<RequestDelegate> requestDelegate;
@property(nonatomic, assign) id<ResponseDelegate> responseDelegate;

@property(nonatomic, copy) SuccessBlock successBlock;
@property(nonatomic, copy) FailedBlock failedBlock;

- (void)addDataParam:(NSObject *)param forKey:(NSString *)keyString;
- (void)sendRequestOnSuccess:(SuccessBlock)successBlock onFailed:(FailedBlock)failedBlock;
- (void)getRequestOnSuccess:(SuccessBlock)successBlock onFailed:(FailedBlock)failedBlock;
- (void)load;
- (void)cancel;

- (void)succeed:(id)response;
- (void)failed:(NSError *)error;

@end
