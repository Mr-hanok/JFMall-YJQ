//
//  GoodsCommentTableViewCell.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/9.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsComment.h"

@interface GoodsCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *commentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentPicOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentPicTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentPicThreeBtn;
@property (nonatomic, copy) void(^selectImagesBlock)(NSArray *);

//加载Cell数据
- (void)loadCellData:(GoodsComment *)comment;

@end
