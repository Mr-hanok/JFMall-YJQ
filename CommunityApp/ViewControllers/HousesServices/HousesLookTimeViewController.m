//
//  HousesLookTimeViewController.m
//  CommunityApp
//
//  Created by iss on 7/15/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "HousesLookTimeViewController.h"
#import "HouseLookTimeDateViewController.h"
#define START_SHEET_TAG 256
#define END_SHEET_TAG START_SHEET_TAG+1
@interface HousesLookTimeViewController ()<HouseLookTimeDateDelegate,UIActionSheetDelegate>
@property (strong,nonatomic) IBOutlet UILabel* dateLabel;
@property (strong,nonatomic) IBOutlet UILabel* timeStartLabel;
@property (strong,nonatomic) IBOutlet UILabel* timeEndLabel;
@end

@implementation HousesLookTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Str_BuildingsInfo_VisitTimeTitle;
    [self setNavBarLeftItemAsBackArrow];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark---IBAction
-(IBAction)clickDateSelect:(id)sender
{
    HouseLookTimeDateViewController* vc = [[HouseLookTimeDateViewController alloc]init];
    vc.delegate  = self;
    [self.navigationController pushViewController:vc animated:TRUE];
}
-(IBAction)clickStartTimeSel:(id)sender
{
    [self showTimeSheet:START_SHEET_TAG];
}
-(IBAction)clickEndTimeSel:(id)sender
{
    [self showTimeSheet:END_SHEET_TAG];
}
-(IBAction)clickOk:(id)sender
{
    if ([_dateLabel.text isEqualToString:@""] && [_timeStartLabel.text isEqualToString:@""] && [_timeEndLabel.text isEqualToString:@""]) {
        return;
    }
    NSMutableString * dateString = [[NSMutableString alloc]initWithString:@""];
    if ([_dateLabel.text isEqualToString:@""]==FALSE) {
        [dateString appendString:_dateLabel.text];
    }
    if ([_timeStartLabel.text isEqualToString:@""]==FALSE && [_timeStartLabel.text isEqualToString:@"开始时间"]==FALSE) {
        [dateString appendString:[NSString stringWithFormat:@" %@" ,_timeStartLabel.text]];
    }
    if ([_timeEndLabel.text isEqualToString:@""]==FALSE && [_timeEndLabel.text isEqualToString:@"结束时间"]==FALSE) {
        [dateString appendString:[NSString stringWithFormat:@"-%@" ,_timeEndLabel.text]];
    }
    
    if([self.delegate respondsToSelector:@selector(selHousesLookTime:)])
    {
        [self.delegate selHousesLookTime:dateString];
    }
    [self.navigationController popViewControllerAnimated:TRUE];
}
#pragma mark---HouseLookTimeDateDelegate
-(void)selHouseLookTimeDate:(NSString *)dateString
{
    [_dateLabel setText:dateString];
}
#pragma mark---UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* timeString  = [NSString stringWithFormat:@"%2ld:00",buttonIndex+1];
    if (actionSheet.tag == START_SHEET_TAG) {
        [_timeStartLabel setText:timeString];
    }else if (actionSheet.tag == END_SHEET_TAG)
    {
        [_timeEndLabel setText:timeString];
    }
}
#pragma mark --- other
-(void) showTimeSheet:(NSInteger)sheetTag
{
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles:@"1:00",@"2:00",@"3:00",@"4:00",@"5:00",@"6:00",@"7:00",@"8:00",@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"24:00", nil];
    sheet.tag = sheetTag;
    [sheet showInView:self.view];
}
@end
