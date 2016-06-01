//
//  DBOperation.m
//  CommunityApp
//
//  Created by issuser on 15/6/25.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "DBOperation.h"
#import "CommunityMessage.h"

@implementation DBOperation


#pragma mark - init
static DBOperation * instance = nil;

+(DBOperation *)Instance
{
    @synchronized(self)
    {
        if (nil == instance)
        {
            [self new];
        }
    }
    return instance;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}


/* 创建用户购物车信息一览表
 * type: 0-商品；1-服务
 * wsid: 商品id 或 服务id
 * wsname: 商品名 或 服务名 
 * count: 商品数量
 * originalprice: 商品或服务原价
 * currentprice: 商品或服务现价
 * picurl: 图片URL
 * supportservice: 支持的服务
 * servicetime: 预约服务时间
 * intocarttime: 商品加入购物车时间
 * sellerId: 商家ID
 * sellerName: 商家名称
 * deliverytype: 配送方式
 * waresstyle: 商品规格型号
 * projectid: 项目ID（小区ID）
 */
-(BOOL)createCartDataTable:(NSString *)tableName inDataBase:(FMDatabase *)db
{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE '%@' ('id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 'type' INTEGER, 'wsid' Text, 'wsname' Text,'count' INTEGER, 'originalprice' Text, 'currentprice' Text, 'picurl' Text, 'supportservice' Text, 'appointmentType' INTEGER, 'servicetime' Text, 'intocarttime' Text, 'sellerId' Text, 'sellername' Text, 'deliverytype' Text, 'waresstyle' Text, 'projectid' Text, 'specialofferstatus' Text, 'specialofferbuy' Text, 'specialofferprice' Text)",tableName];
    return [db executeUpdate:sql];
}

//同步购物车商品数据
- (BOOL)syncWaresDataFromServer:(ShopCartModel *)model
{
    BOOL retVal = NO;
    
    if ([[LoginConfig Instance] userLogged])
    {
        FMDatabase *db = [[Common appDelegate] db];
        
        if ([db open])
        {
            NSString *tableName = [NSString stringWithFormat:@"shop_cart_list_%@", [[LoginConfig Instance] userAccount]];
            
            retVal = [self isTableExist:tableName inDataBase:db];
            if (!retVal)
            {
                retVal = [self createCartDataTable:tableName inDataBase:db];
            }
            if (retVal) {
                retVal = [self insertWaresDataWithShopCartModel:model toTable:tableName inDataBase:db];
            }

            [db close];
        }
    }
    
    
    return retVal;
}


/* 插入一条商品数据到购物车 */
-(BOOL)insertWaresDataWithShopCartModel:(ShopCartModel *)model toTable:(NSString*)tableName inDataBase:(FMDatabase *)db
{
    BOOL retVal = NO;
    
    NSString *sql = [NSString stringWithFormat:@"select * from sqlite_master where tbl_name='%@'", tableName];
    FMResultSet *rs = [db executeQuery:sql];
    NSString *tableSql = @"";
    while ([rs next]) {
        tableSql = [rs stringForColumn:@"sql"];
    }
    if ([tableSql rangeOfString:@"paymentType"].location == NSNotFound) {
        sql = [NSString stringWithFormat:@"alter table %@ add paymentType text", tableName];
        [db executeUpdate:sql];
    }
    if ([tableSql rangeOfString:@"goodsType"].location == NSNotFound) {
        sql = [NSString stringWithFormat:@"alter table %@ add goodsType text", tableName];
        [db executeUpdate:sql];
    }
    if ([tableSql rangeOfString:@"isPutGoods"].location == NSNotFound) {
        sql = [NSString stringWithFormat:@"alter table %@ add isPutGoods text", tableName];
        [db executeUpdate:sql];
    }
    if ([tableSql rangeOfString:@"storeRemainCount"].location == NSNotFound) {
        sql = [NSString stringWithFormat:@"alter table %@ add storeRemainCount text", tableName];
        [db executeUpdate:sql];
    }
    if ([tableSql rangeOfString:@"moduleType"].location == NSNotFound) {
        sql = [NSString stringWithFormat:@"alter table %@ add moduleType text", tableName];
        [db executeUpdate:sql];
    }
    //插入购物车信息
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (type,wsid,wsname,count,originalprice,currentprice,picurl,supportservice,appointmentType,servicetime,intocarttime,sellerId, sellername, deliverytype, waresstyle, projectid, paymentType, goodsType, isPutGoods, storeRemainCount,moduleType,specialOfferStatus,specialOfferBuy,specialOfferPrice) values(0,?,?,?,?,?,?,?,0,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",tableName];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSSSSS"];
    NSString *strDate = [formatter stringFromDate:date];
    
    retVal = [db executeUpdate:insertSql, model.wsId, model.wsName, [NSString stringWithFormat:@"%ld", (long)model.count], model.originalPrice, model.currentPrice, model.picUrl, @"", @"", strDate, model.sellerId, model.sellerName, model.deliveryType, model.waresStyle, model.projectId, model.paymentType, model.goodsType, model.isPutGoods, model.storeRemainCount,model.moduleType,model.specialOfferStatus,model.specialOfferBuy,model.specialOfferPrice];
    
    if (!retVal)
    {
        NSLog(@"insert data failed!");
        [db rollback];
    }
    
    return retVal;
}






//向数据库中插入商品数据
- (BOOL)insertWaresData:(WaresDetail *)data
{
    BOOL retVal = NO;
    
    if ([[LoginConfig Instance] userLogged])
    {
        FMDatabase *db = [[Common appDelegate] db];
        
        if ([db open])
        {
            NSString *tableName = [NSString stringWithFormat:@"shop_cart_list_%@", [[LoginConfig Instance] userAccount]];
            
            if ([self isTableExist:tableName inDataBase:db])
            {
                NSInteger count = [self getWaresCountInCartByWaresId:data.goodsId andWaresStyle:data.selectedStyle fromTable:tableName inDataBase:db];
                
                if (count <= 0) {
                    retVal = [self insertWaresData:data toTable:tableName inDataBase:db];
                }
                else {
                    retVal = [self updateWaresData:data.goodsId withWaresStyle:data.selectedStyle andCount:(count+1) toTable:tableName inDataBase:db];
                }
            }
            else
            {
                if ([self createCartDataTable:tableName inDataBase:db])
                {
                    retVal = [self insertWaresData:data toTable:tableName inDataBase:db];
                }
            }
            
            [db close];
        }
    }
    
    return retVal;
}


//向数据库中插入服务数据
- (BOOL)insertServiceData:(ServiceDetail *)data
{
    BOOL retVal = NO;
    
    if ([[LoginConfig Instance] userLogged])
    {
        FMDatabase *db = [[Common appDelegate] db];
        
        if ([db open])
        {
            NSString *tableName = [NSString stringWithFormat:@"shop_cart_list_%@", [[LoginConfig Instance] userAccount]];
            
            if ([self isTableExist:tableName inDataBase:db])
            {
                NSInteger count = [self getWaresCountInCartByWaresId:data.serviceId andWaresStyle:@"" fromTable:tableName inDataBase:db];
                
                if (count <= 0) {
                    retVal = [self insertServiceData:data toTable:tableName inDataBase:db];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该服务已经在购物车中" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    retVal = NO;
                }
            }
            else
            {
                if ([self createCartDataTable:tableName inDataBase:db])
                {
                    retVal = [self insertServiceData:data toTable:tableName inDataBase:db];
                }
            }
            
            [db close];
        }
    }
    
    return retVal;
}


/* 获取购物车数据库中某个商品的数量 */
- (NSInteger)getWaresCountInCartByWaresId:(NSString *)waresId andWaresStyle:(NSString *)waresStyle
{
    NSInteger count = 0;
    
    if ([[LoginConfig Instance] userLogged])
    {
        FMDatabase *db = [[Common appDelegate] db];
        
        if ([db open])
        {
            NSString *tableName = [NSString stringWithFormat:@"shop_cart_list_%@", [[LoginConfig Instance] userAccount]];
            
            if ([self isTableExist:tableName inDataBase:db])
            {
                count = [self getWaresCountInCartByWaresId:waresId andWaresStyle:waresStyle fromTable:tableName inDataBase:db];
            }
        }
    }
    return count;
}


/* 获取购物车数据库中某个商品的数量 指定表名和数据库 */
- (NSInteger)getWaresCountInCartByWaresId:(NSString *)waresId andWaresStyle:(NSString *)waresStyle fromTable:(NSString *)tableName inDataBase:(FMDatabase *)db
{
    NSInteger count = 0;
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    
    NSString    *sql = [NSString stringWithFormat:@"select count from %@ where wsid = '%@' and waresstyle = '%@' and projectid = '%@'",tableName,waresId, waresStyle, projectId];
    FMResultSet *rs  = [db executeQuery:sql];
    
    while ([rs next]) {
        count = [rs intForColumn:@"count"];
    }
    
    return count;
}

/* 更新商品数据到数据库 */
- (BOOL)updateWaresData:(NSString *)wareId withWaresStyle:(NSString *)waresStyle andCount:(NSInteger)count
{
    BOOL retVal = NO;
    
    if ([[LoginConfig Instance] userLogged])
    {
        FMDatabase *db = [[Common appDelegate] db];
        
        if ([db open])
        {
            NSString *tableName = [NSString stringWithFormat:@"shop_cart_list_%@", [[LoginConfig Instance] userAccount]];
            if ([self isTableExist:tableName inDataBase:db]) {
                retVal = [self updateWaresData:wareId withWaresStyle:waresStyle andCount:count toTable:tableName inDataBase:db];
            }
        }
    }
    return retVal;
}

/* 更新商品数据到数据库 指定表名和数据库 */
- (BOOL)updateWaresData:(NSString *)wareId withWaresStyle:(NSString *)waresStyle andCount:(NSInteger)count toTable:(NSString*)tableName inDataBase:(FMDatabase *)db
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSSSSS"];
    NSString *strDate = [formatter stringFromDate:date];
    
    NSString * sql = [NSString stringWithFormat:@"update %@ set count = '%ld' , intocarttime = '%@' where wsid = '%@' and projectid = '%@' and waresStyle = '%@'",tableName, count, strDate, wareId, projectId, waresStyle];
    
    return [db executeUpdate:sql];
}


/* 插入一条商品数据到购物车 */
-(BOOL)insertWaresData:(WaresDetail *)data toTable:(NSString*)tableName inDataBase:(FMDatabase *)db
{
    BOOL retVal = NO;
    
    NSString *sql = [NSString stringWithFormat:@"select * from sqlite_master where tbl_name='%@'", tableName];
    FMResultSet *rs = [db executeQuery:sql];
    NSString *tableSql = @"";
    while ([rs next]) {
        tableSql = [rs stringForColumn:@"sql"];
    }
    if ([tableSql rangeOfString:@"moduleType"].location == NSNotFound) {
        sql = [NSString stringWithFormat:@"alter table %@ add moduleType text", tableName];
        [db executeUpdate:sql];
    }
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    
    //插入购物车信息
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (type,wsid,wsname,count,originalprice,currentprice,picurl,supportservice,appointmentType,servicetime,intocarttime,sellerId, sellername, deliverytype, waresstyle, projectid,moduleType,specialOfferStatus,specialOfferBuy,specialOfferPrice) values(0,?,?,1,?,?,?,?,0,?,?,?,?,?,?,?,?,?,?,?)",tableName];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSSSSS"];
    NSString *strDate = [formatter stringFromDate:date];
    
    retVal = [db executeUpdate:insertSql, data.goodsId, data.goodsName, data.goodsActualPrice, data.goodsPrice, data.goodsUrl, data.label, @"",strDate, data.sellerId, data.sellerName, data.deliveryType, data.selectedStyle, projectId,data.moduleType,data.specialOfferStatus,data.specialOfferBuy,data.specialOfferPrice];
    
    if (!retVal)
    {
        NSLog(@"insert data failed!");
        [db rollback];
    }
    
    return retVal;
}


/* 插入一条服务数据到购物车 */
-(BOOL)insertServiceData:(ServiceDetail *)data toTable:(NSString*)tableName inDataBase:(FMDatabase *)db
{
    BOOL retVal = NO;
    
    //插入购物车信息
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (type,wsid,wsname,count,originalprice,currentprice,picurl,supportservice,appointmentType,servicetime,intocarttime) values(1,?,?,1,?,?,?,?,?,?,?)",tableName];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSSSSS"];
    NSString *strDate = [formatter stringFromDate:date];
    
    retVal = [db executeUpdate:insertSql, data.serviceId, data.serviceName, data.servicePrice, data.servicePrice, data.servicePicUrl, @"", [NSString stringWithFormat:@"%ld",(long)data.appointmentType], data.serviceTime, strDate];
    
    if (!retVal)
    {
        NSLog(@"insert data failed!");
        [db rollback];
    }
    
    return retVal;
}

/* 选择购物车中所有商品或服务数据 */
- (NSArray *)getAllWaresOrServiceDataInCartByType:(NSInteger)type
{
    NSMutableArray *cartArray = [[NSMutableArray alloc] init];
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    
    if ([[LoginConfig Instance] userLogged])
    {
        FMDatabase *db = [[Common appDelegate] db];
        
        if ([db open])
        {
            NSString *tableName = [NSString stringWithFormat:@"shop_cart_list_%@", [[LoginConfig Instance] userAccount]];
            if ([self isTableExist:tableName inDataBase:db]) {
                NSString    *sql = [NSString stringWithFormat:@"select * from %@ where type=%ld and projectid=%@ order by intocarttime desc", tableName, type, projectId];
                FMResultSet *rs  = [db executeQuery:sql];
                while ([rs next]) {
                    [cartArray addObject:[[ShopCartModel alloc] initWithFMResultSet:rs]];
                }
            }
        }
    }
    return cartArray;
}


/* 选择最新一条插入购物车的数据 */
- (ShopCartModel *)selectLatestDataFromCart
{
    ShopCartModel *model = [[ShopCartModel alloc] init];
    
    if ([[LoginConfig Instance] userLogged])
    {
        FMDatabase *db = [[Common appDelegate] db];
        
        if ([db open])
        {
            NSString *tableName = [NSString stringWithFormat:@"shop_cart_list_%@", [[LoginConfig Instance] userAccount]];
            if ([self isTableExist:tableName inDataBase:db]) {
                NSString *sql = [NSString stringWithFormat:@"select * from %@ where (intocarttime=(select max(intocarttime) from %@))", tableName, tableName];
                FMResultSet *rs  = [db executeQuery:sql];
                while ([rs next]) {
                   model = [[ShopCartModel alloc] initWithFMResultSet:rs];
                }
            }
        }
    }
    return model;
}



/* 选择所有购物车数据 */
- (NSArray *)selectAllCartData
{
    NSMutableArray *cartArray = [[NSMutableArray alloc] init];
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    
    if ([[LoginConfig Instance] userLogged])
    {
        FMDatabase *db = [[Common appDelegate] db];
        
        if ([db open])
        {
            NSString *tableName = [NSString stringWithFormat:@"shop_cart_list_%@", [[LoginConfig Instance] userAccount]];
            if ([self isTableExist:tableName inDataBase:db]) {
                NSString    *sql = [NSString stringWithFormat:@"select * from %@ where projectid=%@ order by intocarttime desc", tableName, projectId];
                FMResultSet *rs  = [db executeQuery:sql];
                while ([rs next]) {
                    [cartArray addObject:[[ShopCartModel alloc] initWithFMResultSet:rs]];
                }
            }
        }
    }
    return cartArray;
}

/* 获取购物车中商品的数量 同一商品计数为1 */
- (NSInteger)getWaresCountInCart
{
    NSInteger waresCount = 0;
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    
    if ([[LoginConfig Instance] userLogged])
    {
        FMDatabase *db = [[Common appDelegate] db];
        
        if ([db open])
        {
            NSString *tableName = [NSString stringWithFormat:@"shop_cart_list_%@", [[LoginConfig Instance] userAccount]];
            if ([self isTableExist:tableName inDataBase:db]) {
                NSString    *sql = [NSString stringWithFormat:@"select count(*) as 'warescount' from %@ where type=0 and projectid=%@", tableName, projectId];
                FMResultSet *rs  = [db executeQuery:sql];
                while ([rs next]) {
                    waresCount += [rs intForColumn:@"warescount"];
                }
            }
        }
    }
    return waresCount;
}


/* 获取购物车中服务的数量 */
- (NSInteger)getServiceCountInCart
{
    NSInteger serviceCount = 0;
    
    if ([[LoginConfig Instance] userLogged])
    {
        FMDatabase *db = [[Common appDelegate] db];
        
        if ([db open])
        {
            NSString *tableName = [NSString stringWithFormat:@"shop_cart_list_%@", [[LoginConfig Instance] userAccount]];
            if ([self isTableExist:tableName inDataBase:db]) {
                NSString    *sql = [NSString stringWithFormat:@"select count(*) as 'servicecount' from %@ where type=1", tableName];
                FMResultSet *rs  = [db executeQuery:sql];
                while ([rs next]) {
                    serviceCount += [rs intForColumn:@"servicecount"];
                }
            }
        }
    }
    return serviceCount;
}


/* 获取购物车中商品和服务的总数量 */
- (NSInteger)getTotalWaresAndServicesCountInCart
{
    NSInteger totalCount = 0;
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    
    if ([[LoginConfig Instance] userLogged])
    {
        FMDatabase *db = [[Common appDelegate] db];
        
        if ([db open])
        {
            NSString *tableName = [NSString stringWithFormat:@"shop_cart_list_%@", [[LoginConfig Instance] userAccount]];
            if ([self isTableExist:tableName inDataBase:db]) {
                NSString    *sql = [NSString stringWithFormat:@"select * from %@ where projectid=%@ order by intocarttime desc", tableName, projectId];
                FMResultSet *rs  = [db executeQuery:sql];
                while ([rs next]) {
                    totalCount += [rs intForColumn:@"count"];
                }
            }
        }
    }
    return totalCount;
}


// 删除购物车中的某个商品或服务
- (BOOL)deleteWaresDataFromCart:(NSString *)wsId withWaresStyle:(NSString *)waresStyle
{
    BOOL status = NO;
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    
    if ([[LoginConfig Instance] userLogged])
    {
        FMDatabase *db = [[Common appDelegate] db];
        
        if ([db open])
        {
            NSString *tableName = [NSString stringWithFormat:@"shop_cart_list_%@",[[LoginConfig Instance] userAccount]];
            NSString * sql = [NSString stringWithFormat:@"delete from %@ where wsid = '%@' and waresstyle = '%@' and projectid = '%@' ", tableName, wsId, waresStyle, projectId];
            
            status = [db executeUpdate:sql];
            
            [db close];
        }
    }
    
    return status;
}


//删除购物车里所有数据
- (BOOL)deleteCartAllData
{
    BOOL status = NO;
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    
    if ([[LoginConfig Instance] userLogged])
    {
        FMDatabase *db = [[Common appDelegate] db];
        
        if ([db open])
        {
            NSString *tableName = [NSString stringWithFormat:@"shop_cart_list_%@",[[LoginConfig Instance] userAccount]];
            NSString *sql = [NSString stringWithFormat:@"delete from %@ where projectid=%@",tableName, projectId];
            
            status = [db executeUpdate:sql];
            
            [db close];
        }
    }
    
    return status;
}


/* 判断用户购物车表是否存在？ */
-(BOOL)isTableExist:(NSString*)tableName inDataBase:(FMDatabase*)db
{
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        NSInteger count = [rs intForColumn:@"count"];
        
        if (count == 0)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)updateCommunityMessage:(CommunityMessage *)message
{
    
    BOOL result = NO;
    FMDatabase *db = [[Common appDelegate] db];
    if ([db open]) {
        if ([self isTableExist:kCommunityMessageTableName inDataBase:db]) {
            
            NSString *sql = [NSString stringWithFormat:@"select * from sqlite_master where tbl_name='%@'", kCommunityMessageTableName];
            FMResultSet *rs = [db executeQuery:sql];
            NSString *tableSql = @"";
            while ([rs next]) {
                tableSql = [rs stringForColumn:@"sql"];
            }
            if ([tableSql rangeOfString:@"userId"].location == NSNotFound) {
                sql = [NSString stringWithFormat:@"alter table %@ add userId text", kCommunityMessageTableName];
                [db executeUpdate:sql];
            }
            if ([tableSql rangeOfString:@"messageType"].location == NSNotFound) {
                sql = [NSString stringWithFormat:@"alter table %@ add messageType text", kCommunityMessageTableName];
                [db executeUpdate:sql];
            }
            CommunityMessage *o;
            rs = [db executeQuery:message.selectSql];
            while ([rs next]) {
                o = [[CommunityMessage alloc] convertFMResultSet:rs];
            }
            if (o == nil) {
                if ([db open]) {
                    result = [db executeUpdate:[message insertSql] withArgumentsInArray:[message insertArguments]];
                    [db close];
                }
            }
            else {
                if ([db open]) {
                    result = [db executeUpdate:[message updateSql] withArgumentsInArray:[message updateArguments]];
                    [db close];
                }
            }
        }
        else {
            if ([db executeUpdate:message.createSql]) {
                result = [db executeUpdate:[message insertSql] withArgumentsInArray:[message insertArguments]];
            }
        }
        [db close];
    }
    return result;
}

- (BOOL)deleteCommunityMessage:(CommunityMessage *)message
{
    BOOL result = NO;
    FMDatabase *db = [[Common appDelegate] db];
    if ([db open]) {
        if ([self isTableExist:kCommunityMessageTableName inDataBase:db]) {
            result = [db executeUpdate:[message deleteSql]];
        }
        [db close];
    }
    return result;
}

- (NSArray *)selectAllCommunityMessage
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    FMDatabase *db = [[Common appDelegate] db];
    if ([db open])
    {
        if ([self isTableExist:kCommunityMessageTableName inDataBase:db])
        {
            NSString *sql = [NSString stringWithFormat:@"select * from %@ order by id",kCommunityMessageTableName];
            FMResultSet *rs  = [db executeQuery:sql];
            while ([rs next]) {
                [array addObject:[[CommunityMessage alloc] convertFMResultSet:rs]];
            }
        }
        [db close];
    }
    return array;
}

- (NSArray *)selectCommunityMessagesWithSql:(NSString *)sql
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    FMDatabase *db = [[Common appDelegate] db];
    if ([db open])
    {
        if ([self isTableExist:kCommunityMessageTableName inDataBase:db])
        {
            FMResultSet *rs  = [db executeQuery:sql];
            while ([rs next]) {
                [array addObject:[[CommunityMessage alloc] convertFMResultSet:rs]];
            }
        }
        [db close];
    }
    return array;
}

- (CommunityMessage *)selectCommunityMessage:(CommunityMessage *)message
{
    CommunityMessage *result;
    FMDatabase *db = [[Common appDelegate] db];
    if ([db open]) {
        if ([self isTableExist:kCommunityMessageTableName inDataBase:db]) {
            FMResultSet *rs = [db executeQuery:[message selectSql]];
            while ([rs next]) {
                result = [message convertFMResultSet:rs];
                break;
            }
        }
        [db close];
    }
    
    return result;
}

@end

