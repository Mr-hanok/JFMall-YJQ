//
//  NewAddRoleInfoViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//  新增路址页面

#import "NewAddRoleInfoViewController.h"
#import "SelectNeighborhoodViewController.h"
#import "GYZChooseCityController.h"///////选择小区
#import "SearchAddressViewController.h"
#import "UserModel.h"
#import "PersonalCenterCustomerClassViewController.h"
#import <Masonry/Masonry.h>
#import "AddressRoadCommitedViewController.h"
#import <UIKit/UIKit.h>
@interface NewAddRoleInfoViewController ()<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate,GYZChooseCityDelegate>
{
    NSDictionary *selectHouseInfo;
    
    NSDictionary *selectBuildDic;           /**< 选择的楼栋 */
    NSDictionary *selectUnitDic;            /**< 选择的单元 */
    NSDictionary *selectFloorDic;           /**< 选择的楼层 */
    NSDictionary *selectRoomDic;            /**< 选择的房间号 */
    
    NSArray *buildList;
    NSArray *unitList;
    NSArray *floorList;
    NSArray *roomList;
    
}
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIButton *pickerViewBackButton;//灰色背景
//选择小区按钮
@property (strong,nonatomic) IBOutlet UIButton *buttonSelectNeighbood;
//button提交新增路址
@property (strong,nonatomic) IBOutlet UIButton *buttonCommit;
//详细地址textview
@property (strong,nonatomic) IBOutlet UITextField *buildUnitField;
@property (strong,nonatomic) IBOutlet UITextField *floorRoomField;

@property (nonatomic, strong) IBOutlet UILabel *selectedLabel;

@property (weak, nonatomic) IBOutlet UILabel *selectedCustomer;//被选中的客户属性
@property (weak, nonatomic) IBOutlet UITextField *contactName;

@property (weak, nonatomic) IBOutlet UITextField *contactTel;

@property (nonatomic, retain) NeighBorHoodModel *neighBorHoodModel;

@property(nonatomic, copy) NSString     *selectedCustomerId;//被选中客户属性的id

//pickerView顶部的控件

@property(nonatomic,strong)UIView*closeAndFinishButtonView;//存放关闭和完成按钮

@property(nonatomic,strong)UIButton*closeButton;//关闭按钮

@property(nonatomic,strong)UIButton*finishButton;//完成按钮

@property(nonatomic,assign)BOOL buildAndfloorBool;//标识完成的是哪个字符串

@property(nonatomic,strong)IBOutlet UIButton * rentButton;//租户

@property(nonatomic,strong)IBOutlet UIButton*ownerButton;//业主

@property(nonatomic,strong)IBOutlet UIButton*  tenantButton;//住户

@end

@implementation NewAddRoleInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavBarLeftItemAsBackArrow];
       //选择项目，进入选择小区
    [self.buttonSelectNeighbood addTarget:self action:@selector(actionJumpToSelectNeighbood) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.title = self.titleName;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrentRespose)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
   // [self setViewData];
    self.buildAndfloorBool=YES;
#pragma -mark 业主认证去掉强制绑定手机号12-10
        [self obtainBindingTel];
//    _contactTel.userInteractionEnabled=NO;
    _contactName.delegate=self;
    
    self.rentButton.tag=1;
    self.ownerButton.tag=2;
    self.tenantButton.tag=3;
#pragma -mark 2016.03.03业主认证页面默认改为住户
    _selectedCustomerId=[NSString stringWithFormat:@"%ld",self.tenantButton.tag];//设置默认选中 业主 客户属性

    self.rentButton.layer.borderWidth=1;
    self.rentButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.ownerButton.layer.borderWidth=1;
    self.ownerButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.tenantButton.layer.borderWidth=1;
    self.tenantButton.layer.borderColor=[UIColor blueColor].CGColor;
    
}
#pragma mark-设置联系人名字，电话
//- (void) setViewData
//{
//    if (self.roadData != nil)
//    {
//        [self.selectedLabel setText:self.roadData.projectName];
//        [self.contactName setText:self.roadData.contactName];
//        [self.contactTel setText:self.roadData.contactTel];
//        }
//}
#pragma mark-如果绑定手机号获取手机号
-(void)obtainBindingTel
{
    NSString* bindTel = [[LoginConfig Instance]getBindPhone];
        [_contactTel setText:bindTel];
}
/**********************************************************************
 *
 *  跳转到小区选择页面
 *
 *********************************************************************/
#pragma mark-  跳转到小区选择页面

- (void) actionJumpToSelectNeighbood
{
//    SelectNeighborhoodViewController *next = [[SelectNeighborhoodViewController alloc]init];
////    GYZChooseCityController *next = [[GYZChooseCityController alloc] init];
//    [next setSelectNeighborhoodBlock:^(NeighBorHoodModel *model)
//     {
//         self.neighBorHoodModel = model;
//         self.selectedLabel.text = model.projectName;
//         buildList = nil;
//         unitList = nil;
//         floorList = nil;
//         roomList = nil;
//         self.buildUnitField.text=nil;
//         self.floorRoomField.text=nil;
//     }];
//    [self.navigationController pushViewController:next animated:YES];
    
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
    buildList = nil;
    unitList = nil;
    floorList = nil;
    roomList = nil;
    self.buildUnitField.text=nil;
    self.floorRoomField.text=nil;
    
}
/**
 * 按钮点击事件
 */
- (IBAction)actionNewAddRoad:(id)sender
{
    if (!self.roadData)
    {
        if (self.authen) {
            [self newAddAuthAddressRoad];
        }
        else {
            [self newAddNormalAddressRoad];
        }
    }
    
    else
    {
        [self updateAddressRoad];
    }
}
-(BOOL)checkCommit
{
    
    if (![self isGoToLogin])
    {
        return FALSE;
    }

    if (self.neighBorHoodModel == nil) {
        [Common showBottomToast:@"请选择项目"];
        return FALSE;
    }
    else{
#pragma -mark 12-30 认证地址姓名必须未中文
        for (int i =0; i<[_contactName.text length]; i++) {
            int a = [_contactName.text characterAtIndex:i];
            if (!(a > 0X4e00 && a < 0X9fff) || _contactName.text.length>4||_contactName.text.length<2) {
                                    //提示工程id不能为空
                    [Common showBottomToast:@"请输入正确的姓名"];
                    return FALSE;
            }
        }
   
//        if (_contactName.text.length>4||_contactName.text.length<2)
//         {
//            //提示工程id不能为空
//            [Common showBottomToast:@"请输入正确的姓名"];
//           return FALSE;
//           }

            if ([Common checkPhoneNumInput:_contactTel.text] == FALSE) {
          //提示电话号码不能为空
          [Common showBottomToast:@"请填写正确的电话号码"];
          return FALSE;
            }
       }
   // }
        if (_buildUnitField.text.length <= 0 || _floorRoomField.text.length <= 0) {
        [Common showBottomToast:@"请填写详细地址"];
        return FALSE;
        }
    return TRUE;
}

/**
 * 新增路址
 */
-(void)newAddAuthAddressRoad
{
    if([self checkCommit]==FALSE) {
        return;
    }
    if (self.neighBorHoodModel.projectId.length == 0) {
        [Common showNoticeAlertView:@"请选择项目"];
        return;
    }
    if (selectRoomDic == nil) {
        [Common showNoticeAlertView:@"请选择详细地址"];
        return;
    }
    
    UserModel* user = [[Common appDelegate].userArray objectAtIndex:0];
    // 请求服务器获取数据
    NSString *userId = user.userId;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:selectRoomDic[@"infoId"] forKey:@"houseInfoId"];
    [params setValue:userId forKey:@"owenId"];
    [params setValue:self.contactTel.text forKey:@"regNumber"];
    [params setValue:self.contactName.text forKey:@"regName"];
    [params setValue:self.selectedCustomerId forKey:@"propertyId"];
    [params setValue:self.neighBorHoodModel.projectId forKey:@"projectId"];
    [params setValue:@"3" forKey:@"source"];//来源 1,电话,2微信,3客户端,4其他
    
    YjqLog(@"selectRoomDic==============================%@",params);

    
    [self getStringFromServer:Service_OrderInfo_Url path:@"authOwenerLocation" method:@"POST" parameters:params success:^(NSString *result) {
        if ([result isEqualToString:@"1"]) {
            [Common showBottomToast:@"提交成功"];
            AddressRoadCommitedViewController *next = [[AddressRoadCommitedViewController alloc] init];
            [self.navigationController pushViewController:next animated:YES];
        }
        else if ([result isEqualToString:@"2"]) {
            [Common showBottomToast:@"该地址已认证过"];
        }
        else {
            [Common showBottomToast:@"提交失败"];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
    }

- (void)newAddNormalAddressRoad
{
    if([self checkCommit]==FALSE) {
        return;
    }
    UserModel* user = [[Common appDelegate].userArray objectAtIndex:0];
    // 请求服务器获取数据
    NSString *userId = user.userId;
    NSString *projectId = self.neighBorHoodModel.projectId;
    NSString *detailShowAddress  = [NSString stringWithFormat:@"%@%@", _buildUnitField.text, _floorRoomField.text];
    // 初始化参数
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:userId,@"userId",detailShowAddress,@"address",_contactTel.text,@"contactTel",_contactName.text,@"contactName",nil];
    if (projectId != nil && projectId.length > 0) {
        [dic setObject:projectId forKey:@"projectId"];
    }
    
    [self getStringFromServer:ServiceInfo_Url path:NewAddRoadAddress_path method:@"post" parameters:dic success:^(NSString *result)
     {
         if ([result isEqualToString:@"1"]) {
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

/**
 * 更新路址
 */
-(void) updateAddressRoad
{
    if([self checkCommit ]==FALSE)
        return;
    NSString *relateId =self.roadData.relateId;
    NSString *detailShowAddress  = [NSString stringWithFormat:@"%@%@", _buildUnitField.text, _floorRoomField.text];
    
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:relateId,@"relateId",detailShowAddress,@"address",_contactName.text,@"contactName",_contactTel.text,@"contactTel",nil];
    
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    if (textField==_contactName) {
        if (self.neighBorHoodModel == nil) {
            [Common showBottomToast:@"请选择项目"];
            return FALSE;
        }
    }
    if (textField==self.buildUnitField) {
        _contactName.placeholder=nil;
            if (_contactName.text.length==0) {
                [Common showBottomToast:@"请输入姓名"];
                _contactName.placeholder=@"请输入";
                return NO;
            }
    }

    if (self.authen) {//新增认证路址按钮被选择
        if (textField == self.buildUnitField) {
            self.buildAndfloorBool=YES;
         [[[UIApplication sharedApplication] keyWindow] endEditing:NO];//收起键盘
            if (self.neighBorHoodModel == nil) {
                [Common showBottomToast:@"请选择项目"];
                return NO;
            }
#pragma mark-请求数据11.23
            [self getBuildListFromServer];//从服务器请求数据
            self.pickerView.tag = 0;
            [self.view addSubview:self.pickerViewBackButton];
            [self.pickerViewBackButton addSubview:self.pickerView];
            
            [self.pickerViewBackButton addSubview:self.closeAndFinishButtonView];//添加pickerView上面的关闭和完成按钮
            [self.pickerViewBackButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsZero);
            }];
            [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.pickerViewBackButton.mas_left);
                make.right.equalTo(self.pickerViewBackButton.mas_right);
                make.top.equalTo(self.pickerViewBackButton.mas_bottom);
                make.height.equalTo(@216);
            }];
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.25 animations:^{
                [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.pickerViewBackButton.mas_left);
                    make.right.equalTo(self.pickerViewBackButton.mas_right);
                    make.bottom.equalTo(self.pickerViewBackButton.mas_bottom);
                    make.height.equalTo(@216);
                }];
                [self.view layoutIfNeeded];
            }];
            return NO;
        }
        else if (textField == self.floorRoomField) {
            self.buildAndfloorBool=NO;
            if (selectUnitDic == nil) {//楼栋单元为空时
                [Common showBottomToast:@"请先选择单元"];
                return NO;
            }
#pragma mark-请求数据11.23
            [self getFloorListFromServer];
            self.pickerView.tag = 1;
            [self.view addSubview:self.pickerViewBackButton];
            [self.pickerViewBackButton addSubview:self.pickerView];
            
            [self.pickerViewBackButton addSubview:self.closeAndFinishButtonView];//添加pickerView上面的关闭和完成按钮
            [self.pickerViewBackButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsZero);
            }];
            [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.pickerViewBackButton.mas_left);
                make.right.equalTo(self.pickerViewBackButton.mas_right);
                make.top.equalTo(self.pickerViewBackButton.mas_bottom);
                make.height.equalTo(@216);
            }];
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.25 animations:^{
                [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.pickerViewBackButton.mas_left);
                    make.right.equalTo(self.pickerViewBackButton.mas_right);
                    make.bottom.equalTo(self.pickerViewBackButton.mas_bottom);
                    make.height.equalTo(@216);
                }];
                [self.view layoutIfNeeded];
            }];
        return NO;
        }
    }
    
    return YES;
}
#pragma mark- 楼东单元数据
- (void)getBuildListFromServer
{
    buildList = nil;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.neighBorHoodModel.projectId forKey:@"projectId"];
    [params setValue:[NSString stringWithFormat:@"%i", newAddnum] forKey:@"perSize"];
    [self getArrayFromServer:@"rest/crmServiceInfo" path:@"getHouserBuildingByParam" method:@"POST" parameters:params xmlParentNode:@"houseInfoBeans/houseInfo" success:^(NSMutableArray *result) {
        buildList = result;
        unitList = nil;
        floorList = nil;
        roomList = nil;
        
        selectBuildDic = buildList.count > 0 ? buildList[0] : @{};
        [self getUnitListFromServer];
        [_pickerView reloadAllComponents];
        [self.pickerView selectRow:0 inComponent:0 animated:NO];
        
    } failure:^(NSError *error) {
        selectBuildDic = @{};
        [_pickerView reloadAllComponents];
    }];
}
//单元
- (void)getUnitListFromServer
{
    unitList = nil;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.neighBorHoodModel.projectId forKey:@"projectId"];
    [params setValue:selectBuildDic[@"convertBuildingId"] forKey:@"buildingId"];
    [params setValue:[NSString stringWithFormat:@"%i", newAddnum] forKey:@"perSize"];
    [self getArrayFromServer:@"rest/crmServiceInfo" path:@"getHouserCellByParam" method:@"POST" parameters:params xmlParentNode:@"houseInfoBeans/houseInfo" success:^(NSMutableArray *result) {
        unitList = result;
        floorList = nil;
        roomList = nil;
        
        selectUnitDic = unitList.count > 0 ? unitList[0] : @{};
        
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:NO];
        
#pragma mark-设置默认值
        if (unitList.count==0 && buildList.count==0) {
            [self.pickerViewBackButton removeFromSuperview];
            UIAlertView*aler=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您所在的社区暂不支持该功能！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aler show];
            return ;
        }
        
    } failure:^(NSError *error) {
        selectUnitDic = @{};
        [self.pickerView reloadComponent:1];
    }];
}
#pragma mark- 楼层房间数据
//楼层
- (void)getFloorListFromServer
{
    floorList = nil;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.neighBorHoodModel.projectId forKey:@"projectId"];
    [params setValue:selectBuildDic[@"convertBuildingId"] forKey:@"buildingId"];
    [params setValue:selectUnitDic[@"convertCellId"] forKey:@"cellId"];
    [params setValue:[NSString stringWithFormat:@"%i",newAddnum] forKey:@"perSize"];
    [self getArrayFromServer:@"rest/crmServiceInfo" path:@"getHouserFloorByParam" method:@"POST" parameters:params xmlParentNode:@"houseInfoBeans/houseInfo" success:^(NSMutableArray *result) {
        floorList = result;
        roomList = nil;
        
        selectFloorDic = floorList.count > 0 ? floorList[0] : @{};
        [self getRoomListFromServer];
        
        [self.pickerView reloadAllComponents];
        [self.pickerView selectRow:0 inComponent:0 animated:NO];
        
    } failure:^(NSError *error) {
        selectFloorDic = @{};
        [self.pickerView reloadAllComponents];
    }];
}
//房间
- (void)getRoomListFromServer
{
    roomList = nil;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.neighBorHoodModel.projectId forKey:@"projectId"];
    [params setValue:selectBuildDic[@"convertBuildingId"] forKey:@"buildingId"];
    [params setValue:selectUnitDic[@"convertCellId"] forKey:@"cellId"];
    [params setValue:selectFloorDic[@"convertFloorId"] forKey:@"floorId"];
    [params setValue:[NSString stringWithFormat:@"%i",newAddnum] forKey:@"perSize"];
    [self getArrayFromServer:@"rest/crmServiceInfo" path:@"getHouserRoomByParam" method:@"POST" parameters:params xmlParentNode:@"houseInfoBeans/houseInfo" success:^(NSMutableArray *result) {
        roomList = result;
        
        selectRoomDic = roomList.count > 0 ? roomList[0] : @{};
        
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:NO];
#pragma mark-设置默认值
       
        if (roomList.count==0&&floorList.count==0) {
            [self.pickerViewBackButton removeFromSuperview];
            UIAlertView*aler=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您所在的社区暂不支持该功能！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aler show];
            return ;
        }
    } failure:^(NSError *error) {
        selectRoomDic = @{};
        [self.pickerView reloadComponent:1];
    }];
}

#pragma mark--other
-(void)resignCurrentRespose
{
    [[[UIApplication sharedApplication]keyWindow]endEditing:TRUE];
}

#pragma mark-客户属性选择
- (IBAction)addRoadBtnClickHandler:(UIButton*)button
{
    [self resignCurrentRespose];
    self.rentButton.layer.borderWidth=1;
    self.rentButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.ownerButton.layer.borderWidth=1;
    self.ownerButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.tenantButton.layer.borderWidth=1;
    self.tenantButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    button.layer.borderWidth=1;
    button.layer.borderColor=[UIColor blueColor].CGColor;
    _selectedCustomerId=[NSString stringWithFormat:@"%ld",button.tag];
}
#pragma mark - UIPickerViewDelegate
//2015.11.12
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    if (pickerView.tag == 0) {
        if (component == 0) {
            title = [buildList[row] valueForKey:@"address"];
        }
        else {
            title = [unitList[row] valueForKey:@"address"];
        }
    }
    else {
        if (component == 0) {
            title = [floorList[row] valueForKey:@"address"];
        }
        else {
            title = [roomList[row] valueForKey:@"address"];
        }
    }
    
    title = title.length > 0 ? title : @"全部";
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
       if (pickerView.tag == 0) {
        if (component == 0) {
            selectBuildDic = buildList.count > 0 ? buildList[row] : @{};
            [self getUnitListFromServer];
        }
        else {
            selectUnitDic = unitList.count > 0 ? unitList[row] : @{};
        }
    }
    else {
        if (component == 0) {
            selectFloorDic = floorList.count > 0 ? floorList[row] : @{};
            [self getRoomListFromServer];
        }
        else {
            selectRoomDic = roomList.count > 0 ? roomList[row] : @{};
        }
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)view;
    
    if (!label)
    {
        label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.numberOfLines = 1;
    }
    
    NSString *title;
    if (pickerView.tag == 0) {
        if (component == 0) {
            if (buildList.count == 0) {
                label.userInteractionEnabled = NO;
            }
            else {
                label.userInteractionEnabled = YES;
                title = [buildList[row] valueForKey:@"address"];
            }
        }
        else {
            if (unitList.count == 0) {
                label.userInteractionEnabled = NO;
            }
            else {
                label.userInteractionEnabled = YES;
                title = [unitList[row] valueForKey:@"address"];
            }
        }
    }
    else {
        if (component == 0) {
            if (floorList.count == 0) {
                label.userInteractionEnabled = NO;
            }
            else {
                label.userInteractionEnabled = YES;
                title = [floorList[row] valueForKey:@"address"];
            }
        }
        else {
            if (roomList.count == 0) {
                label.userInteractionEnabled = NO;
            }
            else {
                label.userInteractionEnabled = YES;
                title = [roomList[row] valueForKey:@"address"];
            }
        }
    }
    
    label.text = title.length > 0 ? title : @"全部";
    
    return label;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 0) {
        if (component == 0) {
            if (buildList.count <= 0) {
                return 1;
            }
            return buildList.count;
        }
        else {
            if (unitList.count <= 0) {
                return 1;
            }
            return unitList.count;
        }
    }
    else {
        if (component == 0) {
            if (floorList.count <= 0) {
                return 1;
            }
            return floorList.count;
        }
        else {
            if (roomList.count <= 0) {
                return 1;
            }
            return roomList.count;
        }
    }
}
#pragma mark-按钮事件
- (void)pickerViewBackButtonClicked:(UIButton *)sender
{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.pickerViewBackButton.mas_left);
            make.right.equalTo(self.pickerViewBackButton.mas_right);
            make.top.equalTo(self.pickerViewBackButton.mas_bottom);
            make.height.equalTo(@216);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.pickerView removeFromSuperview];
            [sender removeFromSuperview];
        }
    }];
}
//关闭按钮事件

-(void)closeButtonClick:(UIButton*)button

{
    
    //[_pickerView removeFromSuperview];
    
    [_pickerViewBackButton removeFromSuperview];
    
    
    
}

//完成按钮事件

-(void)finishButtonClick:(UIButton*)button
{
    if (self.buildAndfloorBool) {
        
        NSString *buildString = selectBuildDic[@"address"];
        NSString *unitString = selectUnitDic[@"address"];
        buildString = buildString.length > 0 ? buildString : @"全部";
        unitString = unitString.length > 0 ? unitString : @"全部";
        
        self.buildUnitField.text = [NSString stringWithFormat:@"%@-%@", buildString, unitString];
    }
    else {
        NSString *floorString = selectFloorDic[@"address"];
        NSString *roomString = selectRoomDic[@"address"];
        floorString = floorString.length > 0 ? floorString : @"全部";
        roomString = roomString.length > 0 ? roomString : @"全部";
        
        self.floorRoomField.text = [NSString stringWithFormat:@"%@-%@", floorString, roomString];
    }
    [_pickerViewBackButton removeFromSuperview];
}

#pragma mark-懒加载pickerView、pickerViewBackButton、closeButton、finishButton

- (UIPickerView *)pickerView

{
    
    if (!_pickerView) {
        
        _pickerView = [[UIPickerView alloc] init];
        
        _pickerView.delegate = self;
        
        _pickerView.dataSource = self;
        
        _pickerView.alpha = 1.0f;
        
        _pickerView.backgroundColor = [UIColor whiteColor];
        
    }
    
    return _pickerView;
    
}



- (UIButton *)pickerViewBackButton

{
    
    if (!_pickerViewBackButton) {
        
        _pickerViewBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_pickerViewBackButton addTarget:self action:@selector(pickerViewBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _pickerViewBackButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        
    }
    
    return _pickerViewBackButton;
    
}

-(UIView *)closeAndFinishButtonView

{    if (_closeAndFinishButtonView==nil) {
    
    _closeAndFinishButtonView=[[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-self.pickerView.frame.size.height, self.view.frame.size.width,30)];
    
    _closeAndFinishButtonView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
    [self.closeAndFinishButtonView addSubview:self.closeButton];
    
    [self.closeAndFinishButtonView addSubview:self.finishButton];
    
}
    
    return _closeAndFinishButtonView;
    
}

-(UIButton *)closeButton

{
    
    if (_closeButton==nil) {
        
        _closeButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,70, 30)];
        
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];//给按钮添加事件
        
        [_closeButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];//给按钮添加文字颜色
        
    }
    
    return _closeButton;
    
}

-(UIButton *)finishButton

{
    
    if (_finishButton==nil) {
        
        _finishButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-70,0,70, 30)];
        
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        
        [_finishButton addTarget:self action:@selector(finishButtonClick:) forControlEvents:UIControlEventTouchUpInside];//给按钮添加事件
        
        [_finishButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];//给按钮添加文字颜色
        
        
        
    }
    
    return _finishButton;
    
}

@end
