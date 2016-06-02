//
//  DBOperation.h
//  CommunityApp
//
//  Created by issuser on 15/6/25.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "WaresDetail.h"
#import "ServiceDetail.h"
#import "ShopCartModel.h"

@class CommunityMessage;

@interface DBOperation : NSObject

+(DBOperation *)Instance;

/* 向数据库中插入商品数据 */
- (BOOL)insertWaresData:(WaresDetail *)data;

/* 向数据库中插入服务数据 */
- (BOOL)insertServiceData:(ServiceDetail *)data;

/* 获取购物车数据库中某个商品的数量 */
- (NSInteger)getWaresCountInCartByWaresId:(NSString *)waresId;

/* 选择所有购物车数据 */
- (NSArray *)selectAllCartData;

/* 删除购物车中的某个商品或服务 */
- (BOOL)deleteWaresDataFromCart:(NSString *)wsId withWaresStyle:(NSString *)waresStyle;

/* 删除购物车里所有数据 */
- (BOOL)deleteCartAllData;

/* 更新商品数据到数据库 */
- (BOOL)updateWaresData:(NSString *)wareId withWaresStyle:(NSString *)waresStyle andCount:(NSInteger)count;

/* 获取购物车中商品的数量 同一商品计数为1 */
- (NSInteger)getWaresCountInCart;

/* 获取购物车中服务的数量 */
- (NSInteger)getServiceCountInCart;

/* 获取购物车中商品和服务的总数量 */
- (NSInteger)getTotalWaresAndServicesCountInCart;

/* 选择购物车中所有商品或服务数据 type:0-商品 1-服务 */
- (NSArray *)getAllWaresOrServiceDataInCartByType:(NSInteger)type;

/* 同步购物车商品数据 */
- (BOOL)syncWaresDataFromServer:(ShopCartModel *)model;

/* 选择最新一条插入购物车的数据 */
- (ShopCartModel *)selectLatestDataFromCart;

#pragma mark - 及时聊天消息相关
- (BOOL)updateCommunityMessage:(CommunityMessage *)message;
- (BOOL)deleteCommunityMessage:(CommunityMessage *)message;
- (NSArray *)selectAllCommunityMessage;
- (NSArray *)selectCommunityMessagesWithSql:(NSString *)sql;
- (CommunityMessage *)selectCommunityMessage:(CommunityMessage *)message;

@end
