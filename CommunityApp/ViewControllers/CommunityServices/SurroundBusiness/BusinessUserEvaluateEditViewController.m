//
//  BusinessUserEvaluateEditViewController.m
//  CommunityApp
//
//  Created by iss on 7/7/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BusinessUserEvaluateEditViewController.h"
#import "TQStarRatingView.h"
#import "LoginConfig.h"


@interface BusinessUserEvaluateEditViewController ()<UITextFieldDelegate,UITextViewDelegate,StarRatingViewDelegate>
@property (strong,nonatomic) IBOutlet UIView* startViewBg;
@property (strong,nonatomic) TQStarRatingView* startView;
@property (strong,nonatomic) IBOutlet UITextView* evaluationText;
@property (strong,nonatomic) IBOutlet UITextField* personalConsumption;
@property (strong,nonatomic) NSString* scoreString;
@end

@implementation BusinessUserEvaluateEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Str_Store_UserEvaluateEdit;
    [self setNavBarLeftItemAsBackArrow];
    [self setNavBarRightItemTitle:Str_Store_UserEvaluateEdit_Commit andNorBgImgName:nil andPreBgImgName:nil];
    _startView = [[TQStarRatingView alloc]initWithFrame:CGRectMake(70, 12, 22*5, 22)];
    [_startViewBg addSubview:_startView];
    [_startView setScore:0 withAnimation:NO];
    _startView.delegate = self;
    [_evaluationText.layer  setCornerRadius:3];
    [_evaluationText.layer setBorderWidth:0.5f];
    [_evaluationText.layer setBorderColor:[UIColor colorWithRed:212.0/255 green:212.0/255 blue:212.0/255.0 alpha:1].CGColor];
    _scoreString = @"0";
    _personalConsumption.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:Str_Store_UserEvaluateEdit_Tip] == TRUE) {
        textView.text = @"";
        [textView setTextColor:[UIColor colorWithRed:57.0/255 green:57.0/255 blue:57.0/255 alpha:1]];
    }
    return TRUE;
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text isEqualToString:@""] && [string isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
}


//右导航栏事件
- (void)navBarRightItemClick
{
    [self postBusinessDetailToService];
}

// 商家评价接口
- (void)postBusinessDetailToService
{
    [[[UIApplication sharedApplication]keyWindow]endEditing:TRUE];
    if([_personalConsumption.text  isEqualToString:@""] || [_evaluationText.text isEqualToString:@""] || [_evaluationText.text isEqualToString:Str_Store_UserEvaluateEdit_Tip])
    {
        [Common showBottomToast:@"请填写评论和人均消费"];
        return;
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[LoginConfig Instance].userID,self.sellerId,_evaluationText.text,_scoreString,_personalConsumption.text] forKeys:@[@"userId",@"sellerId",@"desc",@"score",@"perConsumption"]];
    
    // 提交数据
    [self getStringFromServer:SurroundBusiness_Url path:SurroundBusinessUploadReviews_Path parameters:dic success:^(NSString *result) {
        if([result isEqualToString:@"1"])
        {
            [self.navigationController popViewControllerAnimated:TRUE];
        }
    }failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

#pragma mark--StarRatingViewDelegate
- (void)starRatingView:(TQStarRatingView *)view score:(float)score
{
    _scoreString = [NSString stringWithFormat:@"%d",(int)(score * kNUMBER_OF_STAR)];
}

@end