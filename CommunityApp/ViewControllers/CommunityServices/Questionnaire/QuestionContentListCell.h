//
//  QuestionContentTableViewCell.h
//  CommunityApp
//
//  Created by iss on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionContentListCell;

@protocol QuestionContentListCellDelegate<NSObject>

-(void)cellSelect:(QuestionContentListCell*)cell;
@end

@interface QuestionContentListCell : UITableViewCell

@property(nonatomic,assign) id <QuestionContentListCellDelegate>   delegate;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(strong,nonatomic)IBOutlet UIButton* check1;
@property(strong,nonatomic)IBOutlet UIButton* check;

@property (nonatomic, copy) void(^checkBoxClickBlock)(void);
@property (nonatomic, copy) void(^textChangeBlock)(NSString *content);

-(void)setCellText:(NSString*)questionCellText andType:(NSString *)type andStatus:(BOOL)isSelected;
-(void)setCheckStatus:(BOOL )status;
-(void)clickCheckBoxByCell;
-(BOOL)isCheckBoxSel;

@end
