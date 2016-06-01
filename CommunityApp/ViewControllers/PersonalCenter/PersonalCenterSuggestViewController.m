//
//  PersonalCenterSuggestViewController.m
//  CommunityApp
//
//  Created by iss on 6/10/15.
//  Copyright (c) 2015 iss. All rights reserved.
//
typedef enum{
    AppSuggest = 0,
    PropertySuggest
} SuggestType;

typedef enum {
    SuggestTypeAction = 255,
    ImagePickerAction
}ActionSheetType;

#import "PersonalCenterSuggestViewController.h"
#import "ImageDetailViewController.h"

@interface PersonalCenterSuggestViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,ImageDetailViewDelegate>
@property (strong,nonatomic)IBOutlet UIView* head;
@property (strong,nonatomic)IBOutlet UIView* footer;
@property (weak, nonatomic) IBOutlet UILabel *suggestTypeLabel;

@property (strong,nonatomic)IBOutlet UITableView* table;
@property (strong,nonatomic)IBOutlet UITextView* remarks;
// button
 
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;

@property (assign,nonatomic)CGFloat remarkTextHeight;
@property (assign,nonatomic)SuggestType eSuggestType;
@property (copy,nonatomic)NSString *orderId;
 
@property (strong,nonatomic) NSMutableArray* picArray;
@property (strong,nonatomic) NSMutableArray* imgArray;
@property (assign,nonatomic) NSInteger picCount;
@end

@implementation PersonalCenterSuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_Suggest_Title;
    
    [self initUIView];
  
    _picArray = [[NSMutableArray alloc]init];
    _imgArray = [[NSMutableArray alloc]init];
    
    [_img1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    [_img2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    [_img3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    
}
#pragma mark---UIGestureRecognizerDelegate
-(void)handleSingleFingerEvent:(UITapGestureRecognizer *)tapGesture
{
    if([tapGesture view].tag>_imgArray.count)
    {
        [self clickButton1:[tapGesture view]];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickSuggestBtn:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"商城改进建议", @"物业改进建议", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = SuggestTypeAction;
    [actionSheet showInView:self.view];
}

#pragma mark - TextView delegate
// 文本编辑开始
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:Str_MySuggest_Remark_Default] == TRUE) {
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
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return TRUE;
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

#pragma mark - 初始化View样式
- (void)initUIView {
    _remarkTextHeight = 150.f;
    _head.frame = CGRectMake(0, 0, Screen_Width, 150);
    
    _footer.frame = CGRectMake(0, 0, Screen_Width, 201);
    _table.tableHeaderView = _head;
    _table.tableFooterView = _footer;
   
}

#pragma mark--other
-(void)autoUpdateHeadViewHeight
{
    CGFloat height = self.remarkTextHeight;
    if (IOS7) {
        CGRect textFrame=[[self.remarks layoutManager]usedRectForTextContainer:[self.remarks textContainer]];
        height = textFrame.size.height;
        
    }else {
        
        height = self.remarks.contentSize.height;
    }
    
    if (height != self.remarkTextHeight&& height < Screen_Height-self.keyboardHeight-Navigation_Bar_Height) {
        self.remarkTextHeight = height;
        if (self.remarkTextHeight < 150.f) {
            self.remarkTextHeight = 150.0;
        }
        self.head.frame = CGRectMake(0, 0, Screen_Width, self.remarkTextHeight);
        self.table.tableHeaderView = self.head;
        [_table reloadData];
    }
    
}

#pragma mark---UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(_imgArray.count == 0)
    {
        [_img1 setImage:image];
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
    _picCount ++;
}

- (IBAction)clickButton1:(id)sender {
    [self showSelectImageActionSheet];
}

- (IBAction)clickButton2:(id)sender {
    [self showSelectImageActionSheet];
}

- (IBAction)clickButton3:(id)sender {
    [self showSelectImageActionSheet];
}

- (void)showSelectImageActionSheet {
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles:Str_MyPost_Picker_Take,Str_MyPost_Pick_Album, nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles:Str_MyPost_Pick_Album, nil];
    }

    sheet.tag = ImagePickerAction;
    
    [sheet showInView:self.view];
}

#pragma mark--UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == ImagePickerAction) {
        
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
    else if (actionSheet.tag == SuggestTypeAction) {
        if (buttonIndex == AppSuggest) {
            [_suggestTypeLabel setText:@"商城改进建议"];
        }else if (buttonIndex == PropertySuggest) {
            [_suggestTypeLabel setText:@"物业改进建议"];
        }
    }
}

- (void)toCommitDetail {
    NSString *userId = [[LoginConfig Instance]  userID];
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    if (_orderId==nil) {
        _orderId = [[Common getUUIDString]lowercaseString];
    }
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[userId, projectId, self.orderId ,self.remarks.text,[NSString stringWithFormat:@"%u",self.eSuggestType]] forKeys:@[@"user_id", @"projectId", @"orderId", @"content", @"suggestType"]];
    
    // 请求服务器获取数据
    [self getArrayFromServer:FeedInfo_Url path:FeedInfo_Path method:@"POST" parameters:dic xmlParentNode:@"list" success:^(NSMutableArray *result) {
        NSDictionary *dic = (NSDictionary *)[result firstObject];
        NSString *rstVal = [dic objectForKey:@"result"];
        if ([rstVal isEqualToString:@"1"]) {
            [Common showBottomToast:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [Common showBottomToast:@"提交失败"];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

- (BOOL)toCheckCommit {
    if(![self isGoToLogin])
    {
        return FALSE;
    }
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    if (projectId==nil|| [projectId isEqualToString:@""]) {
        [Common showBottomToast:@"请选择小区"];
        return FALSE;
    }
    
    if ([_remarks.text isEqualToString:@""] || [_remarks.text isEqualToString:@"为了方便和您联系，请您留下联系方式。如果您希望更即时的沟通，请拨打客服电话：400-641-1058。"]) {
        [Common showBottomToast:@"请填写改进建议后，再提交"];
        return FALSE;
    }
    
    if(([_suggestTypeLabel.text isEqualToString:@"请选择反馈类型"])) {
        [Common showBottomToast:@"请选择反馈类型后，再提交"];
        return FALSE;
    }
    return TRUE;
}

- (void)toCommitImg {
    if (_imgArray.count == 0) {
        [self toCommitDetail];
    }
    else
    {
        if (_orderId==nil) {
            _orderId = [[Common getUUIDString]lowercaseString];
        }
        UIImage* image =  [_imgArray objectAtIndex:0];
        NSString* fileId = [[Common getUUIDString]lowercaseString];
        [self uploadImageWithUrl:FileManager_Url path:FileManager_Path fileid:fileId  image:image success:^(NSString *result) {
            [self uploadImgPathToServer:FeedInfoUploadFiles_Url path:FeedInfoUploadFiles_Path recordId:_orderId fileId:fileId success:^(NSString *result) {
                [_imgArray removeObjectAtIndex:0];
                [self toCommitImg];// 递归
            } failure:^(NSError *error) {
                [Common showBottomToast:@"图片上传失败"];
            }];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [Common showBottomToast:Str_Comm_FileConnectFailed];
        }];
    }
}

- (void)getImgToArray
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

#pragma mark - 提交按钮点击事件处理函数
- (IBAction)submitBtnClickHandler:(id)sender {
    // 点击check输入数据
    if(![self toCheckCommit])
        return;
    
    [self getImgToArray];
    [self toCommitImg];
   
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
