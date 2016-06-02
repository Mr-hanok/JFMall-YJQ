//
//  PersonalCenterAuthenticationViewController.m
//  CommunityApp
//
//  Created by iss on 7/3/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterAuthenticationViewController.h"
#import "RoadAddressManageViewController.h"

@interface PersonalCenterAuthenticationViewController ()
@property (strong,nonatomic)IBOutlet UITextField* projectNameTextField;
@property (strong,nonatomic)IBOutlet UITextField* detailAdressTextField;
@property (strong,nonatomic)IBOutlet UITextField* telNumTextField;

@property (weak, nonatomic) IBOutlet UIImageView *vLine1;
@property (weak, nonatomic) IBOutlet UIImageView *vLine2;
@property (weak, nonatomic) IBOutlet UIImageView *vLine3;

@property (strong,nonatomic) NSString* projectName;
@property (strong,nonatomic) NSString* addressId;
@property (strong,nonatomic) NSString* address;
@end

@implementation PersonalCenterAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Str_Owner;
    [self setNavBarLeftItemAsBackArrow];
    
    [Common updateLayout:_vLine1 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_vLine2 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_vLine3 where:NSLayoutAttributeHeight constant:0.5];
    
    [_projectNameTextField setText:_roadData.projectName];
    [_detailAdressTextField setText:_roadData.address];
    [_telNumTextField setText:_roadData.contactTel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)clickCommit:(id)sender
{
    if (_roadData.relateId == nil || [_roadData.relateId isEqualToString:@""]) {
        [Common showBottomToast:@"地址ID不正, 请选择正确的地址"];
        return;
    }
    
    if(_telNumTextField.text ==nil|| ![Common checkPhoneNumInput:_telNumTextField.text]) {
        [Common showBottomToast:@"请输入正确的电话号码"];
        return;
    }
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:_roadData.relateId,@"addressId",_telNumTextField.text,@"regNumber", nil];
    [self getStringFromServer:ServiceInfo_Url path:Auth_Path parameters:dic success:^(NSString *result) {
        if([result isEqualToString:@"1"]) {
            [Common showBottomToast:@"提交申请成功"];
            [self.navigationController popViewControllerAnimated:TRUE];
        }else {
            [Common showBottomToast:@"提交申请失败"];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

#pragma mark --- other
//-(void)freshPage
//{
//    NSRange rang = [_address rangeOfString:@" "];
//    if (rang.length == 0) {
//        return;
//    }
//    [_projectNameLabel setText:[_address substringToIndex:rang.location]];
//    [_projectAdressLabel setText:[_address substringFromIndex:rang.location+1]];
//}
@end
