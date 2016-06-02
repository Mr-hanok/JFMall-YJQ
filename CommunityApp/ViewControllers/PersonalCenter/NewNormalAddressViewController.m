//
//  NewAddRoleInfoViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//  新增路址页面

#import "NewNormalAddressViewController.h"
#import "SelectNeighborhoodViewController.h"
#import "GYZChooseCityController.h"////选择小区
#import "SearchAddressViewController.h"
#import "UserModel.h"
#import "PersonalCenterCustomerClassViewController.h"

@interface NewNormalAddressViewController ()<UITextFieldDelegate,GYZChooseCityDelegate>
{
    NSDictionary *selectHouseInfo;
 
}

//选择小区按钮
@property (strong,nonatomic) IBOutlet UIButton *buttonSelectNeighbood;

//button提交新增路址
@property (strong,nonatomic) IBOutlet UIButton *buttonCommit;

//详细地址textview
@property (strong,nonatomic) IBOutlet UITextField *detailAddress;

@property (nonatomic, strong) IBOutlet UILabel *selectedLabel;
@property (weak, nonatomic) IBOutlet UITextField *contactName;
@property (weak, nonatomic) IBOutlet UITextField *contactTel;

@property (nonatomic, retain) NeighBorHoodModel *neighBorHoodModel;
@property(nonatomic, copy) NSString     *selectedCustomerId;

@end

@implementation NewNormalAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self setNavBarLeftItemAsBackArrow];

    self.navigationItem.title = self.titleName;
#pragma -mark 更新地址页，已提交地址改成不可选择小区
    if (![self.navigationItem.title isEqual:@"更新地址"]) {
         [self.buttonSelectNeighbood addTarget:self action:@selector(actionJumpToSelectNeighbood) forControlEvents:UIControlEventTouchUpInside];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrentRespose)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    [self setViewData];
  //  _contactName.inputAccessoryView = self.toolBar;
   // _contactTel.inputAccessoryView = self.toolBar;
   
}

- (void) setViewData
{
    if (self.roadData != nil)
    {
        [self.selectedLabel setText:self.roadData.projectName];
        [self.contactName setText:self.roadData.contactName];
        [self.contactTel setText:self.roadData.contactTel];
        [self.detailAddress setText:self.roadData.address];
    }
}
#pragma mark-跳转小区
/**********************************************************************
 *
 *  跳转到小区选择页面
 *
 *********************************************************************/

- (void) actionJumpToSelectNeighbood
{
    SelectNeighborhoodViewController *next = [[SelectNeighborhoodViewController alloc]init];
//    GYZChooseCityController *next = [[GYZChooseCityController alloc] init];

//    [next setSelectNeighborhoodBlock:^(NeighBorHoodModel *model)
//    {
//        self.neighBorHoodModel = model;
//        self.selectedLabel.text = model.projectName;
//        self.selectedCustomerId=model.projectId;
//        
//    }];
    GYZChooseCityController *vc = [[GYZChooseCityController alloc] init];
    //    SelectNeighborhoodViewController *vc = [[SelectNeighborhoodViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setSelectedNeighborhoodId:(NSString *)projectId andName:(NSString*)projectName andqrCode:(NSString *)qrCode
{
    NSDictionary * firstDic = @{@"projectId":projectId?projectId:@"",@"projectName":projectName?projectName:@"",@"qrCode":qrCode?qrCode:@""};
    NeighBorHoodModel *model = [[NeighBorHoodModel alloc] initWithDictionary:firstDic];
    self.neighBorHoodModel = model;
    self.selectedLabel.text = projectName;
    self.selectedCustomerId=projectId;
    
}
/**
 * 按钮点击事件
 */
- (IBAction)actionNewAddRoad:(id)sender
{
    if (!self.roadData) {
        [self newAddNormalAddressRoad];
    }
    else {
        [self updateAddressRoad];
    }
}
-(BOOL)checkCommit
{
   
    if (![self isGoToLogin])
    {
        return FALSE;
    }
    
    if (_contactName.text.length == 0)
    {
        //提示工程id不能为空
        [Common showBottomToast:@"请填写姓名"];
        return FALSE;
    }
    else
    {
#pragma -mark 12-30 认证地址姓名必须未中文
        for (int i =0; i<[_contactName.text length]; i++) {
            int a = [_contactName.text characterAtIndex:i];
            if (!(a > 0X4e00 && a < 0X9fff) || _contactName.text.length>4||_contactName.text.length<2) {
                //提示工程id不能为空
                [Common showBottomToast:@"请输入正确的姓名"];
                return FALSE;
            }
        }
    }
    if ([Common checkPhoneNumInput:_contactTel.text] == FALSE) {
        //提示电话号码不能为空
        [Common showBottomToast:@"请填写正确的电话号码"];
        return FALSE;
    }

    NSString *addressString = [_detailAddress.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (addressString.length <= 0) {
        [Common showBottomToast:@"请填写详细地址"];
        return FALSE;
    }
    return TRUE;
}

- (void)newAddNormalAddressRoad
{
    
    if([self checkCommit]==FALSE) {
        return;
    }
    NSUserDefaults*defaultsNewAddress=[NSUserDefaults standardUserDefaults];

    UserModel* user = [[Common appDelegate].userArray objectAtIndex:0];
    // 请求服务器获取数据
    NSString *userId = user.userId;
    NSString *projectId = self.neighBorHoodModel.projectId;
    NSString *detailShowAddress  = _detailAddress.text;
    
#pragma mark-传输保修地址代理方法
  //  [_delegate setSelectedPostAddAndDetailAndnumber:self.selectedLabel.text andDetail:_detailAddress.text andNum:_contactTel.text andName:_contactName.text andProjectId:projectId andBuildingID:self.roadData.buildingId];
    
    if ([[defaultsNewAddress objectForKey:@"addaddress"] isEqualToString:detailShowAddress]&&[[defaultsNewAddress objectForKey:@"addcontactTel"]isEqualToString:_contactTel.text]&&[[defaultsNewAddress objectForKey:@"addcontactName"]isEqualToString:_contactName.text]&&[[defaultsNewAddress objectForKey:@"addprojectId"]isEqualToString:projectId]) {
        UIAlertView*aler=[[UIAlertView alloc]initWithTitle:nil message:@"此地址已经添加过哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [aler show];
        return;
    }
    else{
    // 初始化参数
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:userId,@"userId",detailShowAddress,@"address",_contactTel.text,@"contactTel",_contactName.text,@"contactName",nil];
    if (projectId != nil && projectId.length > 0) {
        [dic setObject:projectId forKey:@"projectId"];
    }
    
    [self getStringFromServer:ServiceInfo_Url path:NewAddRoadAddress_path method:@"post" parameters:dic success:^(NSString *result)
     {
         if ([result isEqualToString:@"1"]) {
             [defaultsNewAddress setObject:detailShowAddress forKey:@"addaddress"];
             [defaultsNewAddress setObject:_contactTel.text forKey:@"addcontactTel"];
             [defaultsNewAddress setObject:_contactName.text forKey:@"addcontactName"];
             [defaultsNewAddress setObject:projectId forKey:@"addprojectId"];
             [Common showBottomToast:@"提交成功"];
             [self.navigationController popViewControllerAnimated:YES];
         }
         else if ([result isEqualToString:@"0"]) {
             [Common showBottomToast:@"提交失败"];
         }
     } failure:^(NSError *error) {
         [Common showBottomToast:Str_Comm_RequestTimeout];
     }
    ];
        
    }
//    [self.navigationController popoverPresentationController];
}

/**
 * 更新路址
 */
-(void) updateAddressRoad
{
    if([self checkCommit ]==FALSE)
        return;
    NSString *relateId =self.roadData.relateId;
    NSString *detailShowAddress  = _detailAddress.text;
    NSString *projectId = self.neighBorHoodModel.projectId;

    // 初始化参数
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:relateId,@"relateId",detailShowAddress,@"address",_contactName.text,@"contactName",_contactTel.text,@"contactTel",nil];
    if (projectId.length != 0) {
        [dic setValue:projectId forKey:@"projectId"];
    }
    [self getStringFromServer:ServiceInfo_Url path:UpdateRoadAddress_path method:@"post" parameters:dic success:^(NSString *result)
     {
         if ([result isEqualToString:@"1"])
         {
             [self.navigationController popViewControllerAnimated:YES];
         }
         else
         {
             [Common showBottomToast:@"修改失败"];
         }
     }
     failure:^(NSError *error)
     {
         [Common showBottomToast:Str_Comm_RequestTimeout];
     }
     ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark --textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}

#pragma mark--other
-(void)resignCurrentRespose
{
    [[[UIApplication sharedApplication]keyWindow]endEditing:TRUE];
}
@end
