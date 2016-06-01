//
//  BookListModel.h
//  CommonApp
//
//  Created by lipeng on 16/3/30.
//  Copyright © 2016年 common. All rights reserved.
//

#import "ComListModel.h"

@interface BookListModel : ComListModel

@property NSString*     alt;
@property NSInteger     count;
@property NSInteger     start;
@property NSInteger     total;
@property NSArray*      books;

@end
