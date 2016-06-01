//
//  BaseModel.h
//  CommunityApp
//
//  Created by issuser on 15/6/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DDXML.h>


@interface BaseModel : NSObject

/**
 * 初始化方法一，将NSDictionary转换成BaseModel数据
 * @param dictionary 需要转换的dictionary
 * @return BaseModel 返回数据类型
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;

/**
 * 初始化方法二，将接口返回的DDXMLElement转换成BaseModel数据
 * @param element 需要转换的element
 * @return BaseModel 返回数据类型
 */
- (id)initWithDDXMLElement:(DDXMLElement *)element;

/**
 * 初始化方法三，将接口返回的NSMutableDictionary转换成BaseModel数据
 * @param dic 需要转换的字典
 * @return BaseModel 返回数据类型
 */
-(id)initWithMutableDictionary:(NSMutableDictionary*)dic;


/**
 * 初始化方法四，将接口返回的FMResultSet转换成BaseModel数据
 * @param rs 需要转换的结果集
 * @return BaseModel 返回数据类型
 */
-(id)initWithFMResultSet:(FMResultSet *)rs;

/**
 * 将BaseModel数据转换成NSDictionary类型数据
 * @return dictionary 返回数据
 */
- (NSDictionary *)convertToDictionary;

@end
