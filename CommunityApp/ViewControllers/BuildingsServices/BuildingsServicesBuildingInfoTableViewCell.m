//
//  BuildingsServicesBuildingInfoTableViewCell.m
//  CommunityApp
//
//  Created by iss on 7/2/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BuildingsServicesBuildingInfoTableViewCell.h"
@interface BuildingsServicesBuildingInfoTableViewCell()
@property (strong,nonatomic) IBOutlet UILabel* title;
@property (strong,nonatomic) IBOutlet UILabel* text;
@end

@implementation BuildingsServicesBuildingInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _text.numberOfLines = 0;
    _text.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCellData:(NSDictionary*)data
{
    NSString* title = [data objectForKey:@"title"];
    if(title == nil)
    {
        title = [[data allKeys]objectAtIndex:0];
    }
    NSString* s = [data objectForKey:@"text"];
    if(s == nil)
    {
        s = [data objectForKey:title];
    }
    [_title setText:[NSString stringWithFormat:@"%@:",title]];
    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect tmpRect = [s boundingRectWithSize:CGSizeMake([BuildingsServicesBuildingInfoTableViewCell textWidth], 2000)  options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    //计算实际frame大小，并将label的frame变成实际大小
       
    [_title setFrame:CGRectMake(15, [BuildingsServicesBuildingInfoTableViewCell textHeightOrgin], 65, 21)];
    CGRect  textViewFrame = CGRectMake(90,[BuildingsServicesBuildingInfoTableViewCell textHeightOrgin], [BuildingsServicesBuildingInfoTableViewCell textWidth], tmpRect.size.height);

    [_text setFrame:textViewFrame];
    CGRect  contentViewFrame = CGRectMake(0, 0, Screen_Width, _text.frame.size.height+[BuildingsServicesBuildingInfoTableViewCell textHeightOrgin]*2);
    [self.contentView setFrame:contentViewFrame];
    [_text setText:s];

}

+(CGFloat)textHeightOrgin
{
    return 5;
}

+(CGFloat)textWidth
{
    return Screen_Width-90-15;
}


@end
