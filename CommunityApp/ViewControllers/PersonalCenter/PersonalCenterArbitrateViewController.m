//
//  PersonalCenterCommodityCommentViewController.m
//  CommunityApp
//
//  Created by iss on 8/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterArbitrateViewController.h"
#import "ImageDetailViewController.h"

@interface PersonalCenterArbitrateViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImageDetailViewDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>
@property (strong,nonatomic) IBOutlet UIView *pickView;
@property (strong,nonatomic) IBOutlet UIView *displayView;
@property (strong,nonatomic) IBOutlet UIImageView* img1;
@property (strong,nonatomic) IBOutlet UIImageView* img2;
@property (strong,nonatomic) IBOutlet UIImageView* img3;
@property (strong,nonatomic) IBOutlet UITextView* remark;
@property (strong,nonatomic) NSString* recordId;
@property (strong,nonatomic) NSMutableArray* imgArray;
@property (strong,nonatomic) NSMutableArray* picArray;
@property (nonatomic, assign) BOOL committing;              /**< 是否正在上传图片 */
@property (assign,nonatomic) NSInteger picCount;
@end

@implementation PersonalCenterArbitrateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_ArbitrateApply_Title;
    [self setNavBarRightItemTitle:Str_Comm_Commit
                  andNorBgImgName:nil andPreBgImgName:nil];
    _picArray = [[NSMutableArray alloc]init];
    _imgArray = [[NSMutableArray alloc]init];
    [_img3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    [_img1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    [_img2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurResponse)];
    [self.view addGestureRecognizer:tap];
    self.committing = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)resignCurResponse
{
    [[[UIApplication sharedApplication]keyWindow]endEditing:TRUE];
}
-(IBAction)clickImgPicker:(id)sender
{
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
#pragma mark---UIGestureRecognizerDelegate
-(void)handleSingleFingerEvent:(UITapGestureRecognizer *)tapGesture
{
    if([tapGesture view].tag>_imgArray.count)
    {
        [self clickImgPicker:[tapGesture view]];
        return;
    }
    ImageDetailViewController* vc = [[ImageDetailViewController alloc]init];
    [vc setImageDetail:_imgArray];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:TRUE];
    
}
#pragma mark---ImageDetailViewDelegate
-(void)clickDel:(NSInteger)delIndex
{
    if (_imgArray.count < delIndex+1) {
        return;
    }
    [_imgArray removeObjectAtIndex:delIndex];
    _picCount--;
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
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(_imgArray.count == 0)
    {
        [ _img1 setImage:image];
        [_img2 setHidden:FALSE];
    }
    else if(_imgArray.count == 1)
    {
        [_img2 setImage:image];
        [_img3 setHidden:FALSE];
    }
    else
    {
        [_img3 setImage:image];
    }
    [_imgArray addObject:image];
    _picCount++;
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(BOOL)toCheckCommit
{
    if(![self isGoToLogin])
    {
        return FALSE;
    }
    if(_remark.text==nil || [_remark.text isEqualToString:@""] || [_remark.text isEqualToString:Str_Arbitrate_Remark_Default])
    {
        [Common showBottomToast:@"请输入提交内容"];
        return FALSE;
    }
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    if (projectId==nil|| [projectId isEqualToString:@""]) {
         [Common showBottomToast:@"请选择小区"];
         return FALSE;
    }
    return TRUE;
}
-(void)toCommitDetail
{

    NSString *userId = [[LoginConfig Instance] userID];
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    if(_recordId==nil)
        _recordId = @"";
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[userId, projectId, self.orderId ,self.remark.text,@"3",_recordId] forKeys:@[@"user_id", @"projectId", @"orderId", @"content", @"suggestType",@"picId"]];
    
    // 请求服务器获取数据
    [self getStringFromServer:FeedInfo_Url path:FeedInfo_Path parameters:dic success:^(NSString *result) {
        if ([result isEqualToString:@"1"]) {
            [Common showBottomToast:@"提交成功"];
            [self.navigationController popViewControllerAnimated:TRUE];
        }else {
            [Common showBottomToast:@"提交失败"];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
 

}

-(void)toCommitImg
{
    if (_imgArray.count == 0) {
        self.committing = NO;
        [self toCommitDetail];
    }
    else
    {
        if(_recordId==nil)
            _recordId = [[Common getUUIDString]lowercaseString];
        UIImage* image =  [_imgArray firstObject];
        NSString* fileId = [[Common getUUIDString]lowercaseString];
        [self uploadImageWithUrl:FileManager_Url path:FileManager_Path fileid:fileId  image:image success:^(NSString *result) {
            [self uploadImgPathToServer:FeedInfoUploadFiles_Url path:FeedInfoUploadFiles_Path recordId:_orderId fileId:fileId success:^(NSString *result) {
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
-(void)navBarRightItemClick
{
    [self getImgToArray];
    if([self toCheckCommit]==FALSE)
        return;
    if (!self.committing) {
        self.committing = YES;
        [self toCommitImg];
    }
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:Str_Arbitrate_Remark_Default] == TRUE) {
        textView.text = @"";
        [textView setTextColor:[UIColor colorWithRed:57.0/255 green:57.0/255 blue:57.0/255 alpha:1]];
    }
    return TRUE;
}
@end
