//
//  PersonalCenterBaseInfoViewController.m
//  CommunityApp
//
//  Created by iss on 6/8/15.
//  Copyright (c) 2015 iss. All rights reserved.
//个人资料

#import "PersonalCenterBaseInfoViewController.h"
#import "PersonalCenterModBaseInfoViewController.h"
#import "PersonalCenterModPwdViewController.h"
#import "LoginConfig.h"
#import "PersonalCenterIntegralViewController.h"
#import "RoadAddressManageViewController.h"
#import "PersonalCenterLoginType.h"
#import "PersonalCenterBindTelViewController.h"
#import "UIImageView+AFNetworking.h"
//微信登陆
#import "PersonalWeinXinLoginViewController.h"

@interface PersonalCenterBaseInfoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
@property (assign,nonatomic) LoginTypeEnum loginType;
@property (strong,nonatomic) IBOutlet UILabel* secLabel;
@property (strong,nonatomic) IBOutlet UIImageView* secIcon;
@property (strong,nonatomic) IBOutlet UIButton* secRightIcon;
@property (strong,nonatomic) IBOutlet UILabel* telLabel;
@property (strong,nonatomic) IBOutlet UILabel* telStatueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hLine1;
@property (weak, nonatomic) IBOutlet UIImageView *hLine2;
@property (weak, nonatomic) IBOutlet UIImageView *hLine3;
@property (weak, nonatomic) IBOutlet UIImageView *hLine4;
@property (weak, nonatomic) IBOutlet UIButton *headIcon;
@property (weak, nonatomic) IBOutlet UIImageView *myAvatar;


@end

@implementation PersonalCenterBaseInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title=Str_PersonalInfo_Title;
    
    [Common updateLayout:_hLine1 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine2 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine3 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine4 where:NSLayoutAttributeHeight constant:0.5];
    
    _loginType = (LoginTypeEnum)[[LoginConfig Instance]loginType];
    
    _myAvatar.layer.cornerRadius = _myAvatar.frame.size.width / 2;
    _myAvatar.clipsToBounds = YES;
//    UIImage *avatar = [Common getMyAvatarImgFromLocation];
//    if (avatar) {
//        [_myAvatar setImage:avatar];
//    }
    if (_myAvatarImg) {
        [_myAvatar setImage:_myAvatarImg];
    }else {
        NSString *filePath = [[LoginConfig Instance] userIcon];
        NSURL *iconUrl = [NSURL URLWithString:filePath];
        [_myAvatar setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"head"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed=YES;
    if (_loginType == LoginType_Weixin || _loginType == LoginType_Code) {
        [_secLabel setText:@"手机绑定"];
        [_secIcon setImage:[UIImage imageNamed:@"TelBind"]];
        NSString* bindTel = [[LoginConfig Instance]getBindPhone];
        if (bindTel==nil) {
            [_telStatueLabel setHidden:FALSE];
            [_telLabel setHidden:TRUE];
        }
        else
        {
            [_telStatueLabel setHidden:TRUE];
            [_secRightIcon setHidden:TRUE];
            [_telLabel setHidden:FALSE];
            [_telLabel setText:bindTel];
        }
    }
}

#pragma mark--IBAction
-(IBAction)clickHeadSel:(id)sender
{
    NSLog(@"点击更换头像");
    if([LoginConfig Instance].userLogged ==FALSE)
        return;
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles:Str_Picker_Take,Str_Pick_Album, nil];
    }
    
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles:Str_Pick_Album, nil];
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
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark---UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSString* fileId = [[Common getUUIDString]lowercaseString];
    NSData *fileData = UIImageJPEGRepresentation(image, 0.3);
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",fileId];
    NSInteger size = fileData.length;
    
    __weak typeof(self) weakSelf = self;
    [self uploadImageWithUrl:FileManager_Url path:FileManager_Path fileid:fileId  image:image success:^(NSString *result) {
        // 初始化参数
        NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[fileId, @"1", [[LoginConfig Instance] userID], [NSString stringWithFormat:@"%ld",(long)size/8], fileName, fileName] forKeys:@[@"fileId", @"fileType", @"ownerId", @"fileSize", @"fileName", @"filePath"]];
        // 请求服务器获取数据
        [self getArrayFromServer:MyAvatarUpload_Url path:MyAvatarUpload_Path parameters:dic xmlParentNode:@"list" success:^(NSMutableArray *result) {
            if (result.count > 0) {
                NSDictionary *dic = result[0];
                NSString *filePath = dic[@"filePath"];
                NSString *result = dic[@"result"];
                
                if ([result isEqualToString:@"1"]) {
                    [weakSelf.myAvatar setImage:image];
                    weakSelf.myAvatarImg = image;
                    [weakSelf.delegate setMyAvatarImg:image];
                    
                    [[LoginConfig Instance] setUserIcon:filePath];
                    
                    [Common showBottomToast:@"头像更新成功"];
                }else {
                    [Common showBottomToast:@"头像更新失败"];
                }
            }
        } failure:^(NSError *error) {
            [Common showBottomToast:Str_Comm_RequestTimeout];
        }];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_FileConnectFailed];
    }];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}



-(IBAction)toModBaseInfo:(id)sender
{
    PersonalCenterModBaseInfoViewController* next = [[PersonalCenterModBaseInfoViewController alloc]init];
    [self.navigationController pushViewController:next animated:YES];
    
}
-(IBAction)toModPassword:(id)sender
{
    
    if (_loginType == LoginType_Weixin ||  _loginType == LoginType_Code) {
       
        NSString* bindTel = [[LoginConfig Instance]getBindPhone];
        if (bindTel==nil) {
            PersonalCenterBindTelViewController* next = [[PersonalCenterBindTelViewController alloc]init];
            next.isFirstLogin = NO;
            [self.navigationController pushViewController:next animated:YES];
        }
    }
    else
    {
        PersonalCenterModPwdViewController* next = [[PersonalCenterModPwdViewController alloc]init];
        [self.navigationController pushViewController:next animated:YES];
    }

    
}
-(IBAction)toIntegral
{
    PersonalCenterIntegralViewController* vc = [[PersonalCenterIntegralViewController alloc]init];
    vc.myAvatar = _myAvatarImg;
    [self.navigationController pushViewController:vc animated:TRUE];
}
-(IBAction)toAddress
{
    RoadAddressManageViewController* vc = [[RoadAddressManageViewController alloc]init];
    vc.showType = ShowDataTypeAll;
    vc.isAddressSel = addressSel_Edit;
    [self.navigationController pushViewController:vc animated:TRUE];
}

#pragma mark--IBAction

-(IBAction)loginOut:(id)sender
{
    [MobClick event:@"login_exit"];
    
    [[Common appDelegate].userArray removeAllObjects];
    [[LoginConfig Instance] userLogout];
    //判断手机是否安装微信，安装使用微信登录，否则使用手机登陆
    [Common weiXinLoginOrIphoneLogin];
}
@end
