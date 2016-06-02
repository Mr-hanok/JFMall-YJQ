//
//  BusinessUserEvaluateTableViewCell.m
//  CommunityApp
//
//  Created by iss on 7/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BusinessUserEvaluateTableViewCell.h"
#import "TQStarRatingView.h"
#import "UIImageView+AFNetworking.h"

@interface BusinessUserEvaluateTableViewCell()
@property (strong,nonatomic) IBOutlet UIView* startViewBg;
@property (strong,nonatomic) TQStarRatingView* startView;
@property (strong,nonatomic) IBOutlet UILabel* evaluateLabel;
@property (strong,nonatomic) IBOutlet UIImageView* userIcon;
@property (weak, nonatomic) IBOutlet UIImageView *hLine;
@property (strong,nonatomic) IBOutlet UILabel* time;
@property (strong,nonatomic) IBOutlet UILabel* userName;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong,nonatomic) SurroundBusinessReviewModel* reviewData;

@end
@implementation BusinessUserEvaluateTableViewCell

- (void)awakeFromNib {
    [Common updateLayout:_hLine where:NSLayoutAttributeHeight constant:0.5];
    _evaluateLabel.numberOfLines = 0;
    _evaluateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _startView = [[TQStarRatingView alloc]initWithFrame:CGRectMake(0, 3, 10*5, 10)];
    _startView.isEdit = FALSE;
    [_startViewBg addSubview:_startView];
    
    _userIcon.layer.cornerRadius = _userIcon.frame.size.width / 2.0;
    _userIcon.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCellData:(SurroundBusinessReviewModel*) data{
    if (data.filePath != nil && data.filePath.length > 0) {
        NSURL *iconUrl = [NSURL URLWithString:data.filePath];
        [_userIcon setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    }

    [_evaluateLabel setText: data.desc];
    [_startView setScore:[data.score floatValue]/kNUMBER_OF_STAR withAnimation:FALSE];
    if(data.submitName ==nil || [data.submitName isEqualToString:@""])
    {
        [_userName setText:@"****"];
    }
    else
    {
        NSString* firstName = [data.submitName substringToIndex:1];
        NSMutableString* mask  = [[NSMutableString alloc]init];
        for (int i= 0 ; i<data.submitName.length-1; i++) {
            [mask appendString:@"*"];
        }
       [_userName setText:[NSString stringWithFormat:@"%@%@",firstName,mask]];
    }
    [_time setText:data.submitDate];
   CGFloat height = [self autoResizeCellHeight];
   CGRect frame = CGRectMake(0, 0, Screen_Width, height);
    NSString* price =@"0.0";
    if (data.perConsumption != nil && [data.perConsumption isEqualToString:@""]==FALSE) {
        price = data.perConsumption;
    }
    [_priceLabel setText:[NSString stringWithFormat:@"￥%@",price]];
    [self.contentView setFrame:frame];
}
-(CGFloat)autoResizeCellHeight
{
    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect tmpRect = [_evaluateLabel.text boundingRectWithSize:CGSizeMake([BusinessUserEvaluateTableViewCell textWidth], 2000)  options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    //计算实际frame大小，并将label的frame变成实际大小
    
//    [_title setFrame:CGRectMake(15, [BuildingsServicesBuildingInfoTableViewCell textHeightOrgin], 65, 21)];
//    CGRect  textViewFrame = CGRectMake(90,[BuildingsServicesBuildingInfoTableViewCell textHeightOrgin], [BuildingsServicesBuildingInfoTableViewCell textWidth], tmpRect.size.height);
//    
//    [_text setFrame:textViewFrame];
    if(tmpRect.size.height+[BusinessUserEvaluateTableViewCell textOriginY]+[BusinessUserEvaluateTableViewCell textMarginBottom]<=71.0f)
        return [BusinessUserEvaluateTableViewCell cellFixHeight];
    return tmpRect.size.height+[BusinessUserEvaluateTableViewCell textOriginY]+[BusinessUserEvaluateTableViewCell textMarginBottom];
}

+(CGFloat) textWidth
{
    return Screen_Width-70;
}
+(CGFloat) textOriginY
{
    return 38.0f+1.0f;
}
+(CGFloat) textMarginBottom
{
    return 10.0f;
}
+(CGFloat) cellFixHeight
{
    return 91.0f;
}
@end
