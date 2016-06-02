//
//  PersonalCenterMyFavoriteTableViewCell.h
//  CommunityApp
//
//  Created by iss on 8/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Favorite.h"

@interface PersonalCenterMyFavoriteTableViewCell : UITableViewCell


// 加载Cell数据
- (void)loadCellData:(Favorite *)fav;

@end
