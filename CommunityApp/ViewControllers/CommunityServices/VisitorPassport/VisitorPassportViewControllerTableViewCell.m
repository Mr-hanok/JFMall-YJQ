//
//  VisitorPassportViewControllerTableViewCell.m
//  CommunityApp
//
//  Created by iss on 7/1/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "VisitorPassportViewControllerTableViewCell.h"
@interface VisitorPassportViewControllerTableViewCell()
@property (strong,nonatomic) IBOutlet UILabel* title;
@property (strong,nonatomic) IBOutlet UILabel* text;
@property (strong,nonatomic) IBOutlet UITextField* input;
@property (strong,nonatomic) IBOutlet UIImageView* rightImg;
@property (weak, nonatomic) IBOutlet UIImageView *vCellLine;

@end

@implementation VisitorPassportViewControllerTableViewCell

- (void)awakeFromNib {
    [Common updateLayout:_vCellLine where:NSLayoutAttributeHeight constant:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(NSString*)getInputText
{
    return  _input.text;
}
-(void)loadCellData:(NSArray*)data textFieldDelegate:(id<UITextFieldDelegate>)textFieldDelegate
{
    if (data.count == 0) {
        return;
    }
    [_title setText:[data objectAtIndex:0]];
    if (data.count == 2) {
        [_text setText:[data objectAtIndex:1]];
    }
    else
    {
        [_input setHidden:FALSE];
        [_rightImg setHidden:TRUE];
        [_text setHidden:TRUE];
    }
    _input.delegate = textFieldDelegate;
}
-(void)setContextText:(NSString*)text
{
    [_text setText:text];
}
@end
