//
//  QuestionContentTableViewCell.m
//  CommunityApp
//
//  Created by iss on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//  问卷调查cells two

#import "QuestionContentListCell.h"

@interface QuestionContentListCell() <UITextViewDelegate>
@property(strong,nonatomic)IBOutlet UILabel* text;
@end

@implementation QuestionContentListCell

- (void)awakeFromNib
{
    self.textView.delegate = self;
    // Initialization code
}

- (void)textViewDidChange:(UITextView *)textView {
    if (_textChangeBlock) {
        NSString *ContentTexts = @"";
        if(textView.text !=nil){
            ContentTexts = textView.text;
        }
        _textChangeBlock(ContentTexts);
    }
}

-(void)setCellText:(NSString*)questionCellText andType:(NSString *)type andStatus:(BOOL)isSelected
{
    [_text setText:questionCellText];
    if ([type isEqualToString:@"0"]){
        [_selectView setHidden:NO];
        [_inputView setHidden:YES];
        [_check setHidden:TRUE];
        [_check1 setHidden:FALSE];
        [_check1 setSelected:isSelected];
    }else if ([type isEqualToString:@"1"]){
        [_selectView setHidden:NO];
        [_inputView setHidden:YES];
        [_check setHidden:FALSE];
        [_check1 setHidden:TRUE];
        [_check setSelected:isSelected];
    }else if ([type isEqualToString:@"2"]){
        [_selectView setHidden:YES];
        [_inputView setHidden:NO];
        [_textView setText:questionCellText];
    }
}
-(void)clickCheckBoxByCell
{
    if (!_check.isHidden)
    {
        [self selClick:_check];
    }
    else if (!_check1.isHidden)
    {
        [self selClick:_check1];
    }
        
}

-(IBAction)selClick:(UIButton*)sender
{
    if (sender == _check) {
        [_check setSelected:!_check.isSelected];
    }else if (sender == _check1) {
        [_check1 setSelected:YES];
    }
    
    if (self.checkBoxClickBlock) {
        self.checkBoxClickBlock();
    }
    
//    if ([_check isHidden]  && ( self.delegate ||[self.delegate respondsToSelector:@selector(cellSelect:)])) {
//        [self.delegate cellSelect:self];
//    }
}
-(void)setCheckStatus:(BOOL )status
{
    if([_check isHidden] == FALSE)
    {
        [_check setSelected:status];
    }
    else if([_check1 isHidden] == FALSE)
    {
        [_check1 setSelected:status];
    }
        
}
-(BOOL)isCheckBoxSel
{
    return _check.isSelected|_check1.isSelected;
}
@end
