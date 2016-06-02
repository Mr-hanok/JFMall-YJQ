//
//  PersonalCenterModBaseInfoViewController.m
//  CommunityApp
//
//  Created by iss on 6/8/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterModBaseInfoViewController.h"
#import "PersonalCenterCustomerClassViewController.h"
#import "UserModel.h"
#import "PersonalCenterAreaSelectViewController.h"
#import "PersonalInfo.h"

@interface PersonalCenterModBaseInfoViewController ()<UIActionSheetDelegate,UITextFieldDelegate>

@property(strong,nonatomic)IBOutlet UITextField* userName;
@property(strong,nonatomic)IBOutlet UILabel* sex;
@property(strong,nonatomic)IBOutlet UILabel* property;
@property(strong,nonatomic)NSString* propertyId;
@property(strong,nonatomic)IBOutlet UITextField* userAccount;
@property(strong,nonatomic)IBOutlet UILabel* address;
@property(strong,nonatomic) DistinctModel* pro;
@property(strong,nonatomic) DistinctModel* city;
@property(nonatomic, retain) PersonalInfo   *personalInfo;

@end

@implementation PersonalCenterModBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title=Str_BaseInfo_Title;
    
    // 初始化基本数据
    [self initBasicDataInfo];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrentResponse)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
  
   // _userName.inputAccessoryView = self.toolBar;
   // _userAccount.inputAccessoryView = self.toolBar;
//    [self freshPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)toDistinctSel:(id)sender {
    [self resignCurrentResponse];
    PersonalCenterAreaSelectViewController* vc = [[PersonalCenterAreaSelectViewController alloc]init];
    [vc setDistinctData:^(DistinctModel *pro, DistinctModel *city) {
        _pro = ( DistinctModel*)[pro copy];
        _city = ( DistinctModel*)[city copy];
        [_address setText:[NSString stringWithFormat:@"%@ %@",_pro.cityName,_city.cityName]];
    }];
    [self.navigationController pushViewController:vc animated:TRUE];
}

- (IBAction)toCustomerClass:(id)sender {
    [self resignCurrentResponse];
    PersonalCenterCustomerClassViewController* next = [[PersonalCenterCustomerClassViewController alloc]init];
    [next setPersonalCenterResult:^(NSString *string) {
        [_property setText:string];
    }];
    [next setCustomPropertyId:^(NSString *string) {
        _propertyId = string;
    }];
    [self.navigationController pushViewController:next animated:YES];
}

- (IBAction)toSexSelect:(id)sender {
    [self resignCurrentResponse];
    UIActionSheet *sheet;
    
    sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles:Str_Comm_Man, Str_Comm_Femail, nil];

    sheet.tag = 255;
    
    [sheet showInView:self.view];
}

- (IBAction)commitClick:(id)sender {
    // 表单校验
    [self formValidate] ? [self postDataToServer] : nil;
}

- (BOOL)formValidate {
    if([_userName.text isEqualToString:@""] || [_sex.text isEqualToString:Str_BaseInfo_Select] || [_property.text isEqualToString:Str_BaseInfo_Select]|| [_address.text isEqualToString:Str_BaseInfo_Select]||[_userAccount.text isEqualToString:@""]){
        [Common showNoticeAlertView:@"请填写完整信息"];
        return NO;
    }
    else if (![Common checkPhoneNumInput:_userAccount.text]){
        [Common showNoticeAlertView:@"联系电话格式不正确"];
        return NO;
    }
    // [_address setText:user.area];
    //🍎
    

    _userNamestr = _userName.text;
    _userAccountstr = _userAccount.text;

    //🍎
    
    NSString *area = _address.text;
    NSLog(@"%@",area);
    return YES;
}

#pragma mark--UIActionSheet
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 255) {
        if(buttonIndex == 0)
        {
            [_sex setText:Str_Comm_Man];
        }
        else if(buttonIndex == 1)
            [_sex setText:Str_Comm_Femail];
    }
}

#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo {
    NSMutableArray* userArray = [Common appDelegate].userArray;
    UserModel* user = [userArray firstObject];
    if (user != nil && user.propertyId != nil && user.propertyId.length > 0) {
        _propertyId = user.propertyId;
    }else {
        _propertyId = @"";
    }
    _personalInfo = [[PersonalInfo alloc] init];
    [self getDataFromServer];
}

// 发送修改数据到服务器
- (void)postDataToServer {
    NSMutableArray* userArray = [Common appDelegate].userArray;
    
    if(userArray.count == 0)
        return;
    UserModel* userDic = [userArray objectAtIndex:0];
    
    // 初始化参数
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:userDic.userId,@"userId",_userName.text,@"userName",[_sex.text isEqualToString:@"男"]?@"0":@"1",@"sex",_property.text,@"property",_userAccount.text,@"ownerPhone",nil];
    
    if (_pro.cityId != nil && _pro.cityId.length > 0) {
        [dic setObject:_pro.cityId forKey:@"provinceId"];
    }
    if (_city.cityId != nil && _city.cityId.length > 0) {
        [dic setObject:_city.cityId forKey:@"cityId"];
    }

    // 请求服务器获取数据
    [self getStringFromServer:ServiceInfo_Url path:EditInfo_Path method:@"POST" parameters:dic success:^(NSString* string) {
        //register success
        if([string isEqualToString:@"1"]) {
            [Common showBottomToast:@"修改成功"];
            [self freshUserData];
            [self.navigationController popViewControllerAnimated:TRUE];
        }
        else{
            [Common showBottomToast:@"修改失败"];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


//从服务器获取个人信息数据
-(void)getDataFromServer
{
    if ([self isGoToLogin]) {
        NSString *userId = [[LoginConfig Instance] userID];
        if (userId == nil || userId.length <= 0) {
            [Common showBottomToast:@"用户账户错误"];
            return;
        }
        
        // 初始化参数
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[userId] forKeys:@[@"infoId"]];
        
        // 请求服务器获取数据
        [self getArrayFromServer:PersonalInfo_Url path:PersonalInfo_Path method:@"GET" parameters:dic xmlParentNode:@"ownerInfo" success:^(NSMutableArray *result) {
            for (NSDictionary *dic in result) {
                _personalInfo = [[PersonalInfo alloc] initWithDictionary:dic];
            }
            [self freshPage];
        } failure:^(NSError *error) {
            [Common showBottomToast:Str_Comm_RequestTimeout];
        }];
    }
}


#pragma mark--other
-(void)freshPage
{
    if (_personalInfo) {
        if (_personalInfo.ownerName != nil && _personalInfo.ownerName.length > 0) {
            [_userName setText:_personalInfo.ownerName];
        }
        if (_personalInfo.sex != nil && _personalInfo.sex.length > 0) {
            NSString *ownerSex = [_personalInfo.sex isEqualToString:@"0"] ? Str_Comm_Man : Str_Comm_Femail;
            [_sex setText:ownerSex];
        }
        if (_personalInfo.ownerPhone != nil && _personalInfo.ownerPhone.length > 0) {
            [_userAccount setText:_personalInfo.ownerPhone];
        }
        if (_personalInfo.customPropert != nil && _personalInfo.customPropert.length > 0) {
            [_property setText:_personalInfo.customPropert];
        }
        
        NSString *address = @"";
        if (_personalInfo.priviceId != nil && _personalInfo.priviceId.length > 0) {
            address = [address stringByAppendingString:_personalInfo.priviceId];
        }
        if (_personalInfo.cityId != nil && _personalInfo.cityId.length > 0) {
            address = [address stringByAppendingString:[NSString stringWithFormat:@"  %@", _personalInfo.cityId]];
        }
        [_address setText:address];
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefault valueForKey:User_Name_Key];
    NSString *userSex = [userDefault valueForKey:User_Sex_Key];
    NSString *phoneNumber = [userDefault valueForKey:User_OwnerPhone_Key];
    NSString *userProperty = [userDefault valueForKey:User_PropertyName_Key];
    NSString *userArea = [userDefault valueForKey:User_Area_Key];
    [_userName setText:userName];
    NSString *ownerSex = [userSex isEqualToString:@"0"] ? Str_Comm_Man : Str_Comm_Femail;
    [_sex setText:ownerSex];
    [_userAccount setText:phoneNumber];
    [_property setText:userProperty];
}

-(void)freshUserData {
    NSMutableArray* userArray = [Common appDelegate].userArray;
    UserModel* user = [userArray objectAtIndex:0];
    user.sex =  [_sex.text isEqualToString:Str_Comm_Man] ? @"0" : @"1";
    user.propertyId = _propertyId;
    user.propertyName = _property.text;
    user.userName = _userName.text;
    user.ownerPhone = _userAccount.text;
    NSString* area = @"";
    
    if(_pro)
      area = [area stringByAppendingString:_pro.cityName];
    if(_city)
      area = [area stringByAppendingString:[NSString stringWithFormat:@" %@",_city.cityName]];
    user.area = area;
    [[LoginConfig Instance]saveUserBase:user];
}

- (void)resignCurrentResponse {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark--textfiled delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return TRUE;
}
@end
