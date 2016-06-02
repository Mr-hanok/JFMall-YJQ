//
//  WaresDetailTableViewCell.h
//  CommunityApp
//
//  Created by iss on 8/7/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsComment.h"


@interface WaresDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *commentDesc;
@property (weak, nonatomic) IBOutlet UIImageView *topLine;


//加载Cell数据
- (void)loadCellData:(GoodsComment *)comment;

@end
