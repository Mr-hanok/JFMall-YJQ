//
//  iZHC_MoProtocol.h
//  iZHC_MoProtocol
//
//  Created by mac on 15/6/10.
//  Copyright (c) 2015年 izhihuicheng. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol iZHC_MoProtocolDelegate <NSObject>

-(void)getKeyCheckAnswer:(int)result resultString:(NSString *)key;

@end


@interface iZHC_MoProtocol : NSObject<iZHC_MoProtocolDelegate>


-(void)decodeKey:(NSArray *)codeKeyArray;
-(NSString *)getQRCode:(NSArray *)codeKeyArray refreshInterval:(int)refreshInterval;


@property(nonatomic, strong) NSMutableArray *bleNameArray;
@property(nonatomic, strong) NSMutableArray *FIDArray;
@property(nonatomic, strong) NSMutableArray *keyArray;
@property(assign,nonatomic) id<iZHC_MoProtocolDelegate> delegate;
@end
