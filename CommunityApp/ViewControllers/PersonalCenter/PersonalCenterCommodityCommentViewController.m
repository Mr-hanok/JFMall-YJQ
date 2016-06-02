//
//  PersonalCenterCommodityCommentViewController.m
//  CommunityApp
//
//  Created by iss on 8/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterCommodityCommentViewController.h"
#import "ImageDetailViewController.h"

@interface PersonalCenterCommodityCommentViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ImageDetailViewDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>
@property (strong,nonatomic) IBOutlet UIView *pickView;
@property (strong,nonatomic) IBOutlet UIView *displayView;
@property (strong,nonatomic) IBOutlet UIImageView* img1;
@property (strong,nonatomic) IBOutlet UIImageView* img2;
@property (strong,nonatomic) IBOutlet UIImageView* img3;

@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (strong,nonatomic) NSMutableArray* imgArray;
@property (strong,nonatomic) NSMutableArray* picArray;
//变量修改
@property (copy,nonatomic) NSString *goodsId;
@property (copy,nonatomic) NSString *orderId;
@property (strong,nonatomic) NSString* picId;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkBgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UIView *remarkbBgView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (assign,nonatomic) CGFloat remarkTextHeight;
@property (assign,nonatomic) NSInteger picCount;

@end

@implementation PersonalCenterCommodityCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_CommodityComment_Title;
    
    _picArray = [[NSMutableArray alloc]init];
    _imgArray = [[NSMutableArray alloc]init];
    [_img3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    [_img1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    [_img2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)clickImgPicker:(id)sender
{
    [_contentText resignFirstResponder];
    
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
-(void)clickDel:(NSInteger)delIndex
{
    
    if (_imgArray.count < delIndex) {
        return;
    }
    [_imgArray removeObjectAtIndex:delIndex];
    _picCount --;
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

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
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
}
-(void)uploadImgPathToServer:(NSString*)recordId fileId:(NSString*)fileId success:(void (^)(NSString *result))success
                     failure:(void (^)(NSError *error))failure
{
    // 初始化参数
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *createTime = [formatter stringFromDate:[NSDate date]];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%@",fileId],@"fileId",@"1",@"fileType",recordId,@"rectId",@"0",@"fileStatu",@"0",@"doModified",createTime,@"createTime",@"1",@"type",nil];
    // 请求服务器获取数据
    [self getStringFromServer:GoodsCommentFile_Url path:GoodsCommentFile_Path method:nil parameters:dic success:^(NSString* string)
     {
         if ([string isEqualToString:@"1"]) {
             NSLog(@"%@",@"uploadImgPathToServer success");
         }
         success(string);
     }
     failure:^(NSError *error)
     {
         [Common showBottomToast:Str_Comm_RequestTimeout];
         failure(error);
     }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(BOOL)checkCommit
{
    NSString *contentStr = [_contentText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (contentStr.length == 0 || [contentStr isEqualToString:Str_OrderComment_Remark_Default]) {
        [Common showBottomToast:@"请输入评价内容"];
        return FALSE;
    }
    return TRUE;
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
-(void)toCommitImg
{
    if (_imgArray.count == 0) {
        [self goodsCommentSave];
    }
    else
    {
        UIImage* image =  [_imgArray objectAtIndex:0];
        NSString* fileId = [[Common getUUIDString]lowercaseString];
        [self uploadImageWithUrl:UploadCrmFiles_Url path:UploadCrmFiles_Path fileid:fileId  image:image success:^(NSString *result) {
            [self uploadImgPathToServer:UploadCrmFiles_Url path:UploadCrmFiles_Path recordId:_picId fileId:fileId success:^(NSString *result) {
                [_imgArray removeObjectAtIndex:0];
                [self toCommitImg];// 递归
            } failure:^(NSError *error) {
                [Common showBottomToast:@"图片上传失败"];
            }];
            
        } failure:^(NSError *error) {
            [Common showBottomToast:Str_Comm_FileConnectFailed];
        }];
    }
}

- (IBAction)clickCommit
{
    [_contentText resignFirstResponder];
    
    if (![self checkCommit]) {
        return;
    }
    
    [self getImgToArray];
    _picId = [[Common getUUIDString] lowercaseString];
    [self toCommitImg];

}

- (void)loadBasicData:(NSString *)goodsId andOrderId:(NSString *)orderId {
    self.goodsId = goodsId;
    self.orderId = orderId;
}

#pragma mark - 商品评价接口
- (void)goodsCommentSave {
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.goodsId, [LoginConfig Instance].userID, [LoginConfig Instance].userName,_contentText.text,_orderId,_picId] forKeys:@[@"goodsId",@"userId",@"userName",@"content",@"orderId",@"picId"]];

    // 提交数据
    [self getArrayFromServer:GoodsCommentList_Url path:GoodsCommentSave_Path method:@"POST" parameters:dic xmlParentNode:@"list" success:^(NSMutableArray *result) {
        NSDictionary *dic = (NSDictionary *)[result firstObject];
        NSString *rstVal = [dic objectForKey:@"result"];
        if([rstVal isEqualToString:@"1"]){
            [Common showBottomToast:@"评价成功"];
            [self.navigationController popViewControllerAnimated:TRUE];
        }else{
            [Common showBottomToast:@"评价失败"];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

#pragma mark - TextView delegate
// 文本编辑开始
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:Str_OrderComment_Remark_Default] == TRUE) {
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
-(void)resignCurrentResponder
{
    [[[UIApplication sharedApplication]keyWindow]endEditing:TRUE];
}
#define REMARKVIEWHEIGHT 100
#define REMARKBGVIEWHEIGHT 101
#define BGVIEW 184
-(void)autoUpdateHeadViewHeight
{
    CGFloat height = self.remarkTextHeight;
    if (IOS7) {
        CGRect textFrame=[[self.contentText layoutManager]usedRectForTextContainer:[self.contentText textContainer]];
        height = textFrame.size.height;
        
    }else {
        
        height = self.contentText.contentSize.height;
    }
    
    if (height != self.remarkTextHeight && height< Screen_Height-self.keyboardHeight-Navigation_Bar_Height-84-40) {
        self.remarkTextHeight = height;
        if (self.remarkTextHeight < REMARKVIEWHEIGHT) {
            self.remarkTextHeight = REMARKVIEWHEIGHT;
        }

    }
    _remarkHeight.constant =  self.remarkTextHeight;
    _remarkBgHeight.constant = REMARKBGVIEWHEIGHT+ _remarkHeight.constant-REMARKVIEWHEIGHT;
    _viewHeight.constant = BGVIEW+ _remarkHeight.constant-REMARKVIEWHEIGHT;
}

@end

