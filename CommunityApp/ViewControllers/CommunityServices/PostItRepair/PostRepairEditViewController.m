//
//  CSPRPostRepairEditViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//保修内容类

#import "PostRepairEditViewController.h"
#import "RoadAddressManageViewController.h"
#import "ContactSelect.h"
#import "UserModel.h"
#import "CommitResultViewController.h"
#import "ImageDetailViewController.h"
//#import "common"

#import "NewNormalAddressViewController.h"
@interface PostRepairEditViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, ContactSelectDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ImageDetailViewDelegate,UIGestureRecognizerDelegate, UIAlertViewDelegate,NewNormalAddressViewControllerdelegate,UITextFieldDelegate>

@property (strong,nonatomic) IBOutlet UIView *displayView;
@property (strong,nonatomic) IBOutlet UIImageView* img1;
@property (strong,nonatomic) IBOutlet UIImageView* img2;
@property (strong,nonatomic) IBOutlet UIImageView* img3;


@property (strong,nonatomic) IBOutlet UILabel *nameLabel;
@property(strong,nonatomic)IBOutlet UITextField*nameTextField;
@property(strong,nonatomic)IBOutlet UILabel *telLabel;
@property(strong,nonatomic)IBOutlet UITextField*telTextfield;
@property(strong,nonatomic)IBOutlet UILabel*addressLabel;
@property(strong,nonatomic)IBOutlet UITextField*adressTextField;

@property (strong,nonatomic)IBOutlet UITextView* remarks;
@property (strong,nonatomic)IBOutlet UITableView* table;
@property (strong,nonatomic)IBOutlet UIView* tableHead;
@property (strong,nonatomic)IBOutlet UIView* tableFoot;
@property (assign,nonatomic)CGFloat remarkTextHeight;
@property (strong,nonatomic)NSString *uuidStr;
@property (strong,nonatomic) NSMutableArray* imgArray;
@property (strong,nonatomic) NSMutableArray* picArray;
@property (strong,nonatomic) NSMutableArray* newimgArray;
@property (nonatomic, strong) NSMutableArray *roadDataArray;
@property (nonatomic, assign) BOOL committing;
@property (assign,nonatomic) NSInteger picCount;

@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation PostRepairEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"报事内容";
    [self setNavBarLeftItemAsBackArrow];
    _remarkTextHeight = 60.0f;
    _tableHead.frame = CGRectMake(0, 0, Screen_Width, 60);
    _tableFoot.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    _table.tableHeaderView = _tableHead;
    _table.tableFooterView = _tableFoot;
    self.telTextfield.delegate=self;
    [self requestDefaultRoadData];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapResignCurrentResponder)];
    [self.view addGestureRecognizer:tap];
    tap.delegate=self;
    
    _picArray = [[NSMutableArray alloc]init];
    _imgArray = [[NSMutableArray alloc]init];
    [_img3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgHandleSingleFingerEvent:)]];
    [_img1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgHandleSingleFingerEvent:)]];
    [_img2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgHandleSingleFingerEvent:)]];
    self.committing = NO;
    
    
    
}
#pragma mark---UIGestureRecognizerDelegate
-(void)imgHandleSingleFingerEvent:(UITapGestureRecognizer *)tapGesture
{
    if([tapGesture view].tag>_imgArray.count)
    {
        [self clickImgPicker:[tapGesture view]];
        return;
    }
    ImageDetailViewController* vc = [[ImageDetailViewController alloc]init];
    if([tapGesture view].tag>1){
        NSMutableDictionary *newImageDic = [[NSMutableDictionary alloc]init];
        for(int i=0;i<_imgArray.count;++i){
            UIImage *newImg =[_imgArray objectAtIndex:i];
            [newImageDic setObject:newImg forKey:[NSString stringWithFormat:@"%d",i+1]];
        }
        if(newImageDic && newImageDic.count>0){
            _newimgArray = [NSMutableArray array];
            [_newimgArray removeAllObjects];
            
            NSString *sdas=[NSString stringWithFormat:@"%ld",[tapGesture view].tag];
            UIImage *asd = [newImageDic objectForKey:sdas];
            [_newimgArray addObject:asd];
            
            [newImageDic removeObjectForKey:[NSString stringWithFormat:@"%ld",[tapGesture view].tag]];
            for(NSString *compKey in newImageDic){
                [_newimgArray addObject:[newImageDic objectForKey:compKey]];
            }
        }
        [vc setImageDetail:_newimgArray];
    }else{
        [vc setImageDetail:_imgArray];
    }
    vc.delegate = self;
    YjqLog(@"_imgArray***************%@",_imgArray);
    
    [self.navigationController pushViewController:vc animated:TRUE];
    
}
#pragma mark-TextFielddelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==self.telTextfield) {
        self.telTextfield.keyboardType=UIKeyboardTypeNumberPad;
    }
    return YES;
}
#pragma mark---ImageDetailViewDelegate
-(void)clickDel:(NSInteger)delIndex
{
    if (_imgArray.count < delIndex) {
        return;
    }
    _picCount --;
    [_imgArray removeObjectAtIndex:delIndex];
    for (int i=0;i<_imgArray.count;i++) {
        UIImageView* imgView = (UIImageView*)[self.view viewWithTag:i+1];
        [imgView setImage:[_imgArray objectAtIndex:i]];
    }
    UIImageView* imgView = (UIImageView*)[self.view viewWithTag:_imgArray.count+1];
    [imgView setHidden:FALSE];
    [imgView setImage:[UIImage imageNamed:@"PlusIconNor"]];
    for(int i=3;i>_imgArray.count+1;i--)
    {
        UIView* View =  [self.view viewWithTag:i];
        [View setHidden:TRUE];
    }
}
#pragma mark-修改报修地址增加方式 2015.11.14
- (IBAction)jumpToRoadAddress:(id)sender
{
//    NewNormalAddressViewController*newNormalAddressVC=[[NewNormalAddressViewController alloc]init];
//    newNormalAddressVC.delegate=self;
//     [self.navigationController pushViewController:newNormalAddressVC animated:YES];
    
    
//
//    RoadAddressManageViewController *next = [[RoadAddressManageViewController alloc] init];
//    next.isAddressSel = addressSel_Default;
//    next.showType = ShowDataTypeAuth;
//    [next setSelectRoadData:^(RoadData *data) {
//        if (![data.authen isEqualToString:@"1"]) {
//            [self showAdressNotAuthAlert];
//            return;
//        }
//        NSString *addressStr = [NSString stringWithFormat:@"%@%@",data.projectName,data.address];
//        [_address setText:addressStr];
//        _telText = data.contactTel;
//        _nameText = data.contactName;
//        NSString *nameAndPhoneStr = [NSString stringWithFormat:@"%@ %@", data.contactName, data.contactTel];
//        [_nameAndPhoneLabel setText:nameAndPhoneStr];
//        _projectId = data.projectId;
//        _buildingId  = data.buildingId;
//    }];
//    [self.navigationController pushViewController:next animated:YES];
}

#pragma mark - 服务器获取数据
- (void)requestDefaultRoadData
{
    UserModel* user = [[Common appDelegate].userArray objectAtIndex:0];
    // 请求服务器获取数据
    NSString *userId = user.userId;
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: userId,@"userId",nil];
    [self getArrayFromServer:ServiceInfo_Url path:DefaultRoadAddress_path method:@"GET" parameters:dic xmlParentNode:@"buildingLocation" success:^(NSMutableArray *result)
     {
         if (result.count == 0) {
             //没有默认地址的情况
             return;
         }
         NSDictionary *roadDic = [result firstObject];
         if (roadDic.count == 0) {
             //没有默认地址的情况
             return;
         }
         RoadData *defaultRoadData = [[RoadData alloc] initWithDictionary:roadDic];
//         if (![defaultRoadData.authen isEqualToString:@"1"]) {
//             //默认地址没有认证的情况
//             return;
//         }
//         _nameTextField.text=@"yijisadhfiew";
         //[_nameAndPhoneLabel setText:[NSString stringWithFormat:@"%@ %@", defaultRoadData.contactName, defaultRoadData.contactTel]];
//         _address.text=@"jiehow";
       //  [_address setText: [NSString stringWithFormat:@"%@%@",defaultRoadData.projectName, defaultRoadData.address]];
        
         _buildingId  = defaultRoadData.buildingId;
     } failure:^(NSError *error) {
         [Common showBottomToast:Str_Comm_RequestTimeout];
     }];
}

-(BOOL)toCheckCommit
{
    if(![self isGoToLogin])
    {
        return FALSE;
    }
//
    if ([_remarks.text isEqualToString:@"详情描述"]) {
        [Common showBottomToast:@"请填写报事详情描述"];
        return FALSE;
    }
//
    if (_nameTextField.text.length == 0) {
        [Common showBottomToast:@"请填写有效的联系电话"];
        return FALSE;
    }
    if ( _telTextfield.text.length == 0) {
        [Common showBottomToast:@"请填写有效联系电话"];
        return FALSE;
    }
    
    if ( _adressTextField.text.length == 0) {
        [Common showBottomToast:@"请填写有效的联系地址"];
        return FALSE;
    }

   return TRUE;
}
//
-(void)toCommitDetail
{    // 请求服务器获取数据
    NSString *userId = [[LoginConfig Instance] userID];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:@"projectId"];
    YjqLog(@"%@",projectId);

    if (_uuidStr == nil) {
        _uuidStr = [Common getUUIDString];
    }
         NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:_uuidStr,@"orderId",userId,@"userId",_serviceId,@"serviceId",_remarks.text,@"remarks",_adressTextField.text,@"address",_telTextfield.text,@"linkTel",_nameTextField.text,@"linkName",@"1",@"buildingId",projectId,@"projectId",@"1",@"anonymous",nil];
//
    // 请求服务器获取数据
    [self getStringFromServer:SelectCategory_Url path:MyPostRepairUpload_Path method:nil parameters:dic success:^(NSString* string)
     {
        
             NSRange len = [string rangeOfString:@"<result>1</result>"];
             
             if(len.length != -1){
#pragma mark-进入提交结果
                 CommitResultViewController* next = [[CommitResultViewController alloc]init];
                 next.resultTitle = @"提交成功";
                 next.resultDesc = @"您已报事成功，我们将会尽快予以处理。";
                 next.eFromViewID = E_ResultViewFromViewID_PostItRepair;
                 [self.navigationController pushViewController:next animated:YES];
             }else{
                 UIAlertView*al=[[UIAlertView alloc]initWithTitle:@"提交失败" message:@"网络开小差了，请您重新提交。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [al show];
             }
         }
    
    failure:^(NSError *error)
    {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
    

}
-(void)toCommitImg
{
    YjqLog(@"_imgArray**************************===================%@",_imgArray);
    if (_imgArray.count == 0) {
        self.committing = NO;
        [self toCommitDetail];
    }
    else
    {
        if(_uuidStr==nil)
        {
            _uuidStr = [Common getUUIDString];
        }
        
        YjqLog(@"_uuidStr++++++++++=============%@",_uuidStr);
        UIImage* image =  [_imgArray firstObject];
        NSString* fileId = [[Common getUUIDString]lowercaseString];
#pragma mark-上传图片
        [self uploadImageWithUrl:FileManager_Url path:FileManager_Path fileid:fileId  image:image success:^(NSString *result) {
            [self uploadImgPathToServer:ServiceInfo_Url path:MyPostRepairUploadFiles_Path recordId:_uuidStr fileId:fileId success:^(NSString *result) {
                [_imgArray removeObject:image];
                [self toCommitImg];// 递归
                
            } failure:^(NSError *error) {
                [Common showBottomToast:Str_Comm_RequestTimeout];
            }];
            
        } failure:^(NSError *error) {
            [Common showBottomToast:Str_Comm_FileConnectFailed];
        }];
    }
}
#pragma mark--IBAction
-(IBAction)clickCommit:(id)sender
{
    if([self toCheckCommit]==FALSE)
        return;
    [self getImgToArray];
    if (!self.committing) {
        self.committing = YES;
        [self toCommitImg];
    }
}
-(void)getImgToArray
{
    [_imgArray removeAllObjects];
    for (int i=1; i<=_picCount; i++) {
        UIImageView* img = (UIImageView*)  [self.view viewWithTag:i];
        if (img.hidden == TRUE) {
            break;
        }
        [_imgArray addObject:img.image];
    }
}
#pragma mark-选择图片添加方式 拍照 从相册中读取  11.24 周二
-(void)clickImgPicker:(id)sender
{
    [[[UIApplication sharedApplication]keyWindow]endEditing:NO];
    
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles:Str_MyPost_Picker_Take,Str_MyPost_Pick_Album, nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles:Str_MyPost_Pick_Album, nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];

  

}
#pragma mark--UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 2:
                // 取消
                return;
                case 0:
                // 相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
                
                case 1:
                // 相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            } else {
                return;
            }
        }
        
        // 跳转到相机或相册页面
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        //imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{//UIImagePickerControllerEditedImage
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(_imgArray.count==0)
    {
        [ _img1 setImage:image];
        [ _img2 setHidden:FALSE];
    }
    else if(_imgArray.count==1)
    {
        [_img2 setImage:image];
        [_img3 setHidden:FALSE];
    }
    else
    {
        [_img3 setImage:image];
        
    }
    [_imgArray addObject:image];
    _picCount ++;
    
    [picker dismissViewControllerAnimated:YES completion:nil];

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -tableview

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identify = @"UITableViewCell";
    UITableViewCell* cell = [_table dequeueReusableCellWithIdentifier:identify];
    if(cell == nil)
        cell = [[UITableViewCell alloc]init];
    cell.frame = CGRectMake(0, 0, Screen_Width, 1);
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


#pragma mark - TextView delegate
// 文本编辑开始
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:Str_MyPost_Remark_Default] == TRUE) {
        textView.text = @"";
        [textView setTextColor:[UIColor colorWithRed:57.0/255 green:57.0/255 blue:57.0/255 alpha:1]];
    }
    
    return TRUE;
}

// 文本内容改变
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // 更新footerView高度
    [self autoUpdateHeadViewHeight];
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return TRUE;
}


#pragma mark--other
-(void)tapResignCurrentResponder
{
    [_remarks resignFirstResponder];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)autoUpdateHeadViewHeight
{
    CGFloat height = self.remarkTextHeight;
    if (IOS7) {
        CGRect textFrame=[[self.remarks layoutManager]usedRectForTextContainer:[self.remarks textContainer]];
        height = textFrame.size.height;
        
    }else {
        
        height = self.remarks.contentSize.height;
    }
    
    if (height != self.remarkTextHeight && height< Screen_Height-self.keyboardHeight-Navigation_Bar_Height) {
        self.remarkTextHeight = height;
        if (self.remarkTextHeight < 60.0) {
            self.remarkTextHeight = 60.0;
        }
        self.tableHead.frame = CGRectMake(0, 0, Screen_Width, self.remarkTextHeight);
        self.table.tableHeaderView = self.tableHead;
        [_table reloadData];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self jumpToRoadAddress:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Get Method
- (NSMutableArray *)roadDataArray
{
    if (!_roadDataArray) {
        _roadDataArray = [[NSMutableArray alloc] init];
    }
    return _roadDataArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
