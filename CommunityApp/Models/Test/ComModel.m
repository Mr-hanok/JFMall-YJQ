//
//  ComModel.m
//  CommonApp
//
//  Created by lipeng on 16/3/9.
//  Copyright © 2016年 common. All rights reserved.
//

#import "ComModel.h"
#import "ComNetworking.h"
#import "JsonDataHandler.h"

@interface ComModel()

@property(nonatomic, strong) ComNetworking *netWorking;
@property(nonatomic, strong) id<DataHandleDelegate> dataHandler;

@end

@implementation ComModel

- (NSString *)requestPath {
    return @"";
}

- (ComNetworking *)netWorking {
    if (!_netWorking) {
        _netWorking = [[ComNetworking alloc] initWithBaseUrl:BaseUrl path:[self requestPath]];
    }
    return _netWorking;
}

- (NSMutableDictionary *)dataParams {
    return nil;
}

- (void)addDataParam:(NSObject *)param forKey:(NSString *)keyString {
    [self.netWorking addDataParam:param forKey:keyString];
}

- (void)setParams {
    //    //1, check params
    //    NSDictionary *headers = [self httpHeader];
    //    if (headers) {
    //        [self.mtopRequest addHttpHeaders:headers];
    //    }
    NSDictionary *dataParams = [self dataParams];
    if (dataParams) {
        [self.netWorking addDataParamFromDictionary:dataParams];
    }
    NSLog(@"\n%@",self.netWorking.parameters);
    //    // 添加额外的扩展参数, 和mtop系统参数平级
    //    NSDictionary *mtopParams = [self mtopParams];
    //    if (mtopParams) {
    //        [self.mtopRequest addExtParameters:mtopParams];
    //    }
}

- (void)loadOnSuccess:(SuccessBlock)successBlock onFailed:(FailedBlock)failedBlock {
    [self beforeLoad];
    __weak __typeof(self)weakSelf = self;
    [self.netWorking postRequestOnSuccess:^(id data) {
        [weakSelf handleResponse:data];
        
        if (successBlock) {
            successBlock(weakSelf);
        }
    } onFailed:^(NSError *error) {
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)load {
    [self beforeLoad];
    
    __weak __typeof(self)weakSelf = self;
    [self.netWorking postRequestOnSuccess:^(id data) {
        
        [weakSelf handleResponse:data];
        [weakSelf loadSucceed:weakSelf];
        
        //        if (weakSelf.successBlock) {
        //            weakSelf.successBlock(buildData);
        //        }
    } onFailed:^(NSError *error) {
        [weakSelf loadFailed:error];
        
        //        if (weakSelf.failedBlock) {
        //            weakSelf.failedBlock(error);
        //        }
    }];
}

- (id<DataHandleDelegate>)dataHandler {
    if (!_dataHandler) {
        _dataHandler = [[JsonDataHandler alloc] init];
    }
    return _dataHandler;
}

- (void)handleResponse:(id)responseData {
    if ([self.dataHandler respondsToSelector:@selector(handleResponse:)]) {
        NSDictionary *dic = [self.dataHandler handleResponse:responseData];
        DLog(@"%@", dic);
        [self buildModel:dic];
    }
}

- (void)buildModel:(NSDictionary *)dic {
    [self yy_modelSetWithDictionary:dic];
}

- (void)beforeLoad {
    [self cancelLoad];
    [self setParams];
}

- (void)loadSucceed:(id)response {
    //    NSLog(@"\n%@",response.json);
    //    [self constructSuccessData:[self responseJSONData:response]];
    if (self.successBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.successBlock(response);
        });
    }
    //    if (self.loadCompletionBlock) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            self.loadCompletionBlock(self,nil);
    //        });
    //    }
}

- (void)loadFailed:(NSError *)error {
    //    response.error.msg = [self userFriendlyErrorMsg:response.error];
    //    NSLog(@"\n%@\n%@",response.error,response.json);
    if (self.failedBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.failedBlock(error);
        });
    }
    //    if (self.loadCompletionBlock) {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            self.loadCompletionBlock(self,response.error);
    //        });
    //    }
}

- (void)cancelLoad {
    [self.netWorking cancel];
}

@end
