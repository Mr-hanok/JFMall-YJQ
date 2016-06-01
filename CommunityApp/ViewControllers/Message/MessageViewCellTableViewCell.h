//
//  MessageViewCellTableViewCell.h
//  CommunityApp
//
//  Created by iss on 6/10/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
@interface MessageViewCellTableViewCell : UITableViewCell
//设置数据
-(void)setMessageModelData:(MessageModel*)modelData;
@end
