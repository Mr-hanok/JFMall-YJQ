//
//  PersonalCenterMsgBoardViewController.m
//  CommunityApp
//
//  Created by issuser on 15/7/20.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "PersonalCenterMsgBoardViewController.h"
#import "ImageDetailViewController.h"
#import "ResultModel.h"

@interface PersonalCenterMsgBoardViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,ImageDetailViewDelegate>

// UITextView
@property (weak, nonatomic) IBOutlet UITextView *msgBoardTextView;

@property (strong,nonatomic) IBOutlet UIView *displayView;
@property (strong,nonatomic) IBOutlet UIImageView* img1;
@property (strong,nonatomic) IBOutlet UIImageView* img2;
@property (strong,nonatomic) IBOutlet UIImageView* img3;
@property (strong,nonatomic)IBOutlet UITextView* remarks;

// Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msgBoardConstraint;

@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *recordId;
@property (copy, nonatomic) NSString *uuidStr;

@property (assign,nonatomic)CGFloat remarkTextHeight;
@property (strong,nonatomic) NSMutableArray* picArray;
@property (strong,nonatomic) NSMutableArray* imgArray;
@property (assign,nonatomic) NSInteger selImageTag;
//setImageDetail:(UIImage*)img;
@end

@implementation PersonalCenterMsgBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_PersonalMsgBoard_Title;
    [self setNavBarRightItemTitle:Str_PersonalMsgBoard_Commit andNorBgImgName:nil andPreBgImgName:nil];
    [self initWidgetStyle];
    _uuidStr = [Common getUUIDString];
    
    // 添加手势
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrentResponse)]];
    
    _recordId = [[Common getUUIDString]lowercaseString];
    _picArray = [[NSMutableArray alloc]init];
    _imgArray = [[NSMutableArray alloc]init];

    [_img1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    [_img3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    [_img2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    
    self.msgBoardConstraint.constant = 250.f;

}

#pragma mark - 初始化控件样式
- (void)initWidgetStyle {
    [self drawViewLayerBorder:_msgBoardTextView];
}

// 描画View边框
-(void)drawViewLayerBorder:(UIView *)view {
    CALayer *viewLayer = view.layer;
    viewLayer.borderWidth = 1;
    viewLayer.cornerRadius = 2;
    viewLayer.masksToBounds = YES;
    viewLayer.borderColor = [[UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark---UIGestureRecognizerDelegate
-(void)handleSingleFingerEvent:(UITapGestureRecognizer *)tapGesture
{
    if([tapGesture view].tag > _imgArray.count)
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
    _selImageTag = delIndex;
    if (_imgArray.count < _selImageTag) {
        return;
    }
    [_imgArray removeObjectAtIndex:_selImageTag];
    for (int i=0; i < _imgArray.count; i++) {
        UIImageView* imgView = (UIImageView*)[self.view viewWithTag:i+1];
        [imgView setImage:[_imgArray objectAtIndex:i]];
    }
    UIImageView* imgView = (UIImageView*)[self.view viewWithTag:_imgArray.count+1];
    [imgView setHidden:FALSE];
    [imgView setImage:[UIImage imageNamed:@"PlusIconNor"]];
    for(int i=3; i > _imgArray.count+1; i--)
    {
        UIView* View =  [self.view viewWithTag:i];
        [View setHidden:TRUE];
    }
}

#pragma mark--other
-(void)resignCurrentResponse
{
    [_remarks resignFirstResponder];
}

// 点击添加图片按钮
- (IBAction)clickImgPicker:(id)sender {
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
    
    NSString* fileId = [[Common getUUIDString]lowercaseString];
    [self uploadImageWithUrl:FileManager_Url path:FileManager_Path fileid:fileId image:image success:^(NSString *result) {
        [_picArray addObject:[NSString stringWithFormat:@"%@,",fileId]];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_FileConnectFailed];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
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

    }
    
}

#pragma mark - 向服务器提交数据
- (void)toCommitDetail {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefault objectForKey:User_UserId_Key];
    self.content  = self.msgBoardTextView.text;
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.afterSalesId,self.content,userId,self.recordId] forKeys:@[@"afterSalesId",@"content",@"userid",@"recordId"]];
    
    [self getStringFromServer:SaveTbgMessageRecord_Url path:SaveTbgMessageRecord_Path method:@"post" parameters:dic success:^(NSString *result) {
        [self.navigationController popViewControllerAnimated:YES];
    }failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

- (void)navBarRightItemClick {
    self.content  = self.msgBoardTextView.text;
    
    if([self.content isEqual:nil] || [self.content isEqual: @""]) {
        [Common showBottomToast:@"亲，您还有没有输入内容哦"];
    }
    
    [_picArray removeAllObjects];
    for(UIImage* image in _imgArray) {
        NSString* fileId = [[Common getUUIDString]lowercaseString];
        [self uploadImageWithUrl:FileManager_Url path:FileManager_Path fileid:fileId image:image success:^(NSString *result)
         {
            
            [self uploadImgPathToServer: UploadMessageFiles_Url path:UploadMessageFiles_Path recordId:_recordId fileId:fileId success:^(NSString *result) {
                [_picArray addObject:fileId];
                if (_picArray.count == _imgArray.count) {
                    [self toCommitDetail];
                }

            } failure:^(NSError *error) {
                [Common showBottomToast:Str_Comm_RequestTimeout];
            }];
            
       }
        failure:^(NSError *error) {
            [Common showBottomToast:Str_Comm_FileConnectFailed];
        }];
    }
}

@end
