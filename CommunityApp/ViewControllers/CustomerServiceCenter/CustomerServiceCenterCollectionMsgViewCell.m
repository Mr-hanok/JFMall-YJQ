//
//  CustomerServiceCenterCollectionMsgViewCell.m
//  CommunityApp
//
//  Created by iss on 6/29/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "CustomerServiceCenterCollectionMsgViewCell.h"
@interface CustomerServiceCenterCollectionMsgViewCell()

@property (strong,nonatomic)IBOutlet UILabel* label;
@property (strong,nonatomic)IBOutlet UIImageView* imgNor;
@property (strong,nonatomic)IBOutlet UIImageView* imgSel;
@property (strong,nonatomic)IBOutlet UILabel* detail;
@property (strong,nonatomic)IBOutlet UIView* detailView;
@end

@implementation CustomerServiceCenterCollectionMsgViewCell

- (void)awakeFromNib {
    // Initialization code
    _detail.numberOfLines = 0;
    _detail.lineBreakMode = NSLineBreakByWordWrapping;
}
-(void) setCell:(NSString *)string detail:(NSString *)detail
{
    [_label setText:string];
    [_detail setText:detail];
    
}
-(void)showDetail
{
    [_detailView setHidden:FALSE];
    [_imgNor setHidden:TRUE];
    [_imgSel setHidden:FALSE];
    [self autoResizeFrame];
    
}
-(void)hideDetail
{
    [_detailView setHidden:TRUE];
    [_imgNor setHidden:FALSE];
    [_imgSel setHidden:TRUE];
    [self autoResizeFrame];

}

-(void) autoResizeFrame{
    static CGFloat TitleHeight = 43.0f;
    if(_detail.hidden == FALSE)
    {
        UIFont *font = [UIFont systemFontOfSize:15];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        CGRect tmpRect = [_detail.text boundingRectWithSize:CGSizeMake(Screen_Width-20, 2000)  options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        
        //计算实际frame大小，并将label的frame变成实际大小
        
        CGRect  contentViewFrame = CGRectMake(0, 0, Screen_Width, TitleHeight+tmpRect.size.height);
        [self.contentView setFrame:contentViewFrame];
    }else
    {
        CGRect  contentViewFrame = CGRectMake(0, 0, Screen_Width, TitleHeight);
        [self.contentView setFrame:contentViewFrame];

    }
}
-(CGFloat)getCellHeight
{
    return self.contentView.frame.size.height;
}
@end
