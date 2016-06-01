//
//  TagModel.h
//  CommonApp
//
//  Created by lipeng on 16/3/12.
//  Copyright © 2016年 common. All rights reserved.
//

#import "ComModel.h"

@interface TagModel : ComModel

@property(nonatomic, assign) NSInteger count;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *title;

@end
