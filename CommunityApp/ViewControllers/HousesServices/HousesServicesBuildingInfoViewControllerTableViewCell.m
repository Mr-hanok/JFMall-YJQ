//
//  BuildingsServicesBuildingInfoViewControllerTableViewCell.m
//  CommunityApp
//
//  Created by iss on 6/30/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "HousesServicesBuildingInfoViewControllerTableViewCell.h"
@interface HousesServicesBuildingInfoViewControllerTableViewCell()<UITextFieldDelegate>
@property (strong,nonatomic) IBOutlet UILabel* title;

@property (strong,nonatomic) IBOutlet UILabel* text;
@property (strong,nonatomic) IBOutlet UIImageView* rightImg;


@property (strong,nonatomic) IBOutlet UITextField* inPutText;
@property (strong,nonatomic) IBOutlet UILabel* unit;

@property (strong,nonatomic) IBOutlet UIImageView* bottomImg;
@property (strong,nonatomic) IBOutlet UIImageView* bottomImg1;
@end

@implementation HousesServicesBuildingInfoViewControllerTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _inPutText.delegate = self;
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textFieldTextDidChangeOneCI:)
     name:UITextFieldTextDidEndEditingNotification
     object:_inPutText];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(NSString*)getInputText
{
    return _inPutText.text;
}
-(void)loadCellData:(NSArray*)data
{
    if(data.count==0)
        return;
    [_title setText:[data objectAtIndex:0]];
    if(data.count == 1 || data.count == 2)
    {
        [_inPutText setHidden:FALSE];
        [_rightImg setHidden:TRUE];
        [_text setHidden:TRUE];
        [_unit setHidden:TRUE];
        if(data.count==2)
            [_inPutText setText:[data objectAtIndex:1]];
    }
    else if(data.count == 3 || data.count == 4)
    {
         NSString* type = [data objectAtIndex:1];
        if ([type isEqualToString:@"0"]==FALSE) {
            [_unit setHidden:FALSE];
            [_unit setText:[data objectAtIndex:2]];
            [_rightImg setHidden:TRUE];
            [_text setHidden:TRUE];
            [_inPutText setHidden:FALSE];
            if (data.count == 4) {
                [_inPutText setText:[data objectAtIndex:3]];
            }
        }
        else
        {
            [_rightImg setHidden:FALSE];
            [_text setHidden:FALSE];
            [_text setText:[data objectAtIndex:2]];
            if (data.count == 4) {
                [_text setText:[data objectAtIndex:3]];
            }
            [_unit setHidden:TRUE];
            [_inPutText setHidden:TRUE];
        }
    }
        
}
-(void)setTextContext:(NSString*)text
{
    [_text setText:text];
}
-(void)isBottom
{
    [_bottomImg setHidden:TRUE];
    [_bottomImg1 setHidden:FALSE];
}
#pragma mark---UITextFieldDelegate
-(void)textFieldTextDidChangeOneCI:(NSNotification *)notification
{
    if ([self.delegate respondsToSelector:@selector(textFiledShouldEditEnd:inputText:)]) {
        [self.delegate textFiledShouldEditEnd:self inputText:_inPutText.text];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return TRUE;
}
@end
