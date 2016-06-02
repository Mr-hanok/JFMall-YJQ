//
//  QuestionSurveyJoinViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//  问卷调查加人页面

#import "QuestionSurveyJoinViewController.h"
#import "QuestionContentListViewController.h"
#import "UserModel.h"

@interface QuestionSurveyJoinViewController ()<UITextFieldDelegate>
@property (strong,nonatomic)IBOutlet UITextField* userName;
@property (strong,nonatomic)IBOutlet UITextField* userTel;
@end

@implementation QuestionSurveyJoinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"问卷调查";
    [self setNavBarLeftItemAsBackArrow];
    if([Common appDelegate].userArray.count==0)
    {
        return;
    }
    UserModel* user = [[Common appDelegate].userArray objectAtIndex:0];
    
    if(user==nil)
    {
      return;
    }
    if([user.userName isEqualToString:@""])
        [_userName setText:user.userAccount];
    else
        [_userName setText:user.userName];

    if (user.userName == nil || [user.userName isEqualToString:@""]) {
        [_userTel setPlaceholder:@"请输入联系人电话"];
    }
    else {
        [_userTel setText:user.ownerPhone];
    }
    
    // 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrentResponder)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(IBAction)startSurvey:(id)sender
{
    if([Common checkPhoneNumInput:_userTel.text] == FALSE)
    {
        [Common showBottomToast:@"请输入正确格式的电话号码"];
        return;
    }
    QuestionContentListViewController* next = [[QuestionContentListViewController alloc]init];
    next.qid = _qid;
    next.investigatorName = _userName.text;
    next.investigatorTel = _userTel.text;
    [self.navigationController pushViewController:next animated:YES];
}

#pragma mark --- textFiled delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}
#pragma mark--other
-(void)resignCurrentResponder
{
//    [_userName resignFirstResponder];
//    [_userTel resignFirstResponder];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
