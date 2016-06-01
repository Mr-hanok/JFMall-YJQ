//
//  ComTableViewCell.h
//  CommonApp
//
//  Created by lipeng on 16/4/1.
//  Copyright © 2016年 common. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComTableViewCell : UITableViewCell

@property (nonatomic, strong) id             item;
@property (nonatomic, strong) NSIndexPath   *indexPath;

@end
