//
//  PersonalCenterMyOrderCommentTableViewCell.m
//  CommunityApp
//
//  Created by iss on 8/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterMyOrderCommentTableViewCell.h"
#import <UIImageView+AFNetworking.h>

@interface PersonalCenterMyOrderCommentTableViewCell()
@property (strong,nonatomic) IBOutlet UIView* bg;
@property (strong,nonatomic) IBOutlet UIButton* commentBtn;
@property (strong,nonatomic) IBOutlet UILabel* wareName;
@property (strong,nonatomic) IBOutlet UIImageView* wareImg;
@property (strong,nonatomic) IBOutlet UIImageView* bottomLine;
@property (strong,nonatomic) IBOutlet UIImageView* bottomLine1;
@end
@implementation PersonalCenterMyOrderCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.commentBtn.layer.cornerRadius = 5.0f;
    self.commentBtn.layer.borderWidth =1;
    self.commentBtn.layer.borderColor = [UIColor orangeColor].CGColor;

}

- (void)setCanComment:(BOOL)isCanComment {
    _commentBtn.enabled = isCanComment;
    if (isCanComment) {
        [self.commentBtn setTitle:@"评价" forState:UIControlStateNormal];
        [self.commentBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        self.commentBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    }
    else {
        [self.commentBtn setTitle:@"已评价" forState:UIControlStateNormal];
        [self.commentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.commentBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)toComment:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(toComment:)]) {
        [self.delegate toComment:self];
    }
}
-(void)loadCellData:(NSString*) wareName img:(NSString*)imgUrl isButtom:(BOOL)isButtom
{
    
    if (isButtom) {
        [_bottomLine setHidden:FALSE];
        [_bottomLine1 setHidden:TRUE];
    }
    else
    {
        [_bottomLine setHidden:TRUE];
        [_bottomLine1 setHidden:FALSE];
    }
   
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:imgUrl]];
    [self.wareImg setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    [_wareName setText:wareName];

}
@end
