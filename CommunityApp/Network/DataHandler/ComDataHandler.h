//
//  ComDataAdapter.h
//  CommonApp
//
//  Created by lipeng on 16/4/4.
//  Copyright © 2016年 common. All rights reserved.
//

#ifndef ComDataAdapter_h
#define ComDataAdapter_h


@protocol DataHandleDelegate <NSObject>

- (NSDictionary *)handleResponse:(id)responseData;
//- (void)buildModel:(NSDictionary *)dic;

@end


#endif /* ComDataAdapter_h */
