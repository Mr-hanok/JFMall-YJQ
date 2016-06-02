//
//  GoodsCommentTableViewCell.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/9.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GoodsCommentTableViewCell.h"
#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface GoodsCommentTableViewCell ()

@property(nonatomic, strong) NSArray *goodsUrl;

@end

@implementation GoodsCommentTableViewCell

- (void)awakeFromNib {
    _avatarImgView.layer.cornerRadius = _avatarImgView.frame.size.width / 2.0;
    _avatarImgView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//加载Cell数据
- (void)loadCellData:(GoodsComment *)comment
{
    [_avatarImgView setImageWithURL:[NSURL URLWithString:comment.userPic] placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    
    [self.userNameLabel setText:comment.userName];
    [self.commentDescLabel setText:comment.desc];
    
    NSString *date = comment.date;
    if (date.length >= 19) {
        date = [comment.date substringToIndex:19];
    }
    [self.commentTimeLabel setText:date];
    
    if (![comment.goodsPic isEqualToString:@""]) {
        _goodsUrl = [comment.goodsPic componentsSeparatedByString:@","];
        if (_goodsUrl.count >= 1) {
            NSURL *iconUrl = [NSURL URLWithString:[_goodsUrl objectAtIndex:0]];
            [_commentPicOneBtn setBackgroundImageForState:UIControlStateNormal withURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
        }
        if (_goodsUrl.count >= 2) {
            NSURL *iconUrl = [NSURL URLWithString:[_goodsUrl objectAtIndex:1]];
            [_commentPicTwoBtn setBackgroundImageForState:UIControlStateNormal withURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
        }
        if (_goodsUrl.count >= 3) {
            NSURL *iconUrl = [NSURL URLWithString:[_goodsUrl objectAtIndex:2]];
            [_commentPicThreeBtn setBackgroundImageForState:UIControlStateNormal withURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
        }
    }
}

- (IBAction)clickImages:(id)sender {
    if (_selectImagesBlock) {
        _selectImagesBlock(_goodsUrl);
    }
}

@end
