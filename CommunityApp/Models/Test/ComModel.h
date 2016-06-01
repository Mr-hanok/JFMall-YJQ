//
//  ComModel.h
//  CommonApp
//
//  Created by lipeng on 16/3/9.
//  Copyright © 2016年 common. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(id data);
typedef void (^FailedBlock)(NSError *error);

@interface ComModel : NSObject

@property(nonatomic, assign) NSInteger              status;
@property(nonatomic, copy)   NSString*              statusInfo;

@property(nonatomic, copy)   SuccessBlock           successBlock;
@property(nonatomic, copy)   FailedBlock            failedBlock;

- (void)load;
- (void)loadOnSuccess:(SuccessBlock)successBlock onFailed:(FailedBlock)failedBlock;
- (void)beforeLoad;
- (void)loadSucceed:(id)response;
- (void)loadFailed:(NSError *)error;
- (void)cancelLoad;

- (NSDictionary*)dataParams;
- (void)addDataParam:(NSObject *)param forKey:(NSString *)keyString;

@end
