//
//  CustomerServicePropertyHeadView.h
//  CommunityApp
//
//  Created by iss on 6/29/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerServicePropertyHeadView : UICollectionReusableView
@property(copy,nonatomic) void (^PropertyBlock)();
@property(copy,nonatomic) void (^HotLineBlock)();
@end
