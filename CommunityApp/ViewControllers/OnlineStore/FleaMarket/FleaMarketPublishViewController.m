//
//  FleaMarketPublishViewController.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/7.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "FleaMarketPublishViewController.h"
#import "PersonalCenterAreaSelectViewController.h"
#import "GoodsCatagoryViewController.h"
#import "ImageDetailViewController.h"

#import "FleaMarketListViewController.h"

@interface FleaMarketPublishViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate,ImageDetailViewDelegate,UIGestureRecognizerDelegate>
@property (strong,nonatomic) IBOutlet UIView *displayView;
@property (strong,nonatomic) IBOutlet UIImageView* img1;
@property (strong,nonatomic) IBOutlet UIImageView* img2;
@property (strong,nonatomic) IBOutlet UIImageView* img3;
@property (strong,nonatomic) IBOutlet UIImageView* img4;
@property (strong,nonatomic) IBOutlet UIImageView* img5;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint* scrollContextViewHeight;
@property (strong,nonatomic) DistinctModel* pro;
@property (strong,nonatomic) DistinctModel* city;
@property (strong,nonatomic) IBOutlet UILabel* address;
@property (strong,nonatomic) IBOutlet UILabel* loss;
@property (strong,nonatomic) IBOutlet UILabel* type;
@property (strong,nonatomic) IBOutlet UITextField* linkName;
@property (strong,nonatomic) IBOutlet UITextField* linkTel;
@property (strong,nonatomic) NSArray* lossArray;
@property (strong,nonatomic) NSString* lossText;
@property (strong,nonatomic) IBOutlet UITextField* wareTitle;
@property (strong,nonatomic) IBOutlet UITextField* warePrice;
@property (strong,nonatomic) IBOutlet UITextView* wareDesc;
@property (strong,nonatomic) GoodsCategoryModel* goodsCategory;
@property (strong,nonatomic) NSMutableArray* picArray;
@property (strong,nonatomic) NSMutableArray* imgArray;
@property (strong,nonatomic) NSString*  recordId;
@property (nonatomic,retain) NSString* coverPicId;
@property (assign,nonatomic) NSInteger picCount;
@property (assign,nonatomic) NSInteger picIndex;

@end

@implementation FleaMarketPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 初始化导航栏信息
    self.navigationItem.title = Str_FleaMarket_Dispatch;
    [self setNavBarLeftItemAsBackArrow];
    
    _picIndex = 0;
    [self initPageData];
    
}
-(void)initPageData
{
    [self addTap];
    _lossArray = [[NSArray alloc]initWithObjects: @"全新",@"九成新",@"八成新",@"七成新",@"六成新",@"五成以下", nil];
    if ([[LoginConfig Instance] userLogged]==FALSE) {
        [Common showBottomToast:@"亲,你还没有登录"];
        return;
    }
    
    NSString *lineTel = [[LoginConfig Instance]getOwnerPhone];
    NSString *lineName = [[LoginConfig Instance]userName];
   
    if (lineTel != nil && lineTel.length>0 ) {
        [_linkTel setText:lineTel];
    }
    
    if (lineName != nil && lineName.length>0) {
        [_linkName setText:lineName];
    }
    
    _wareTitle.delegate = self;
    _wareDesc.delegate = self;
    _warePrice.delegate = self;

    //<1>在init时候注册notification：
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_wareTitle];
//    [_wareTitle addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _picArray = [[NSMutableArray alloc]init];
    _imgArray = [[NSMutableArray alloc]init];
    [_img5 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    [_img4 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    [_img3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    [_img1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    [_img2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
}

//<2>实现监听方法：
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;

    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 10) {
                textField.text = [toBeString substringToIndex:10];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{

        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 10) {
            textField.text = [toBeString substringToIndex:10];
        }
    }
}
//<3>在dealloc里注销掉监听方法，切记！
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:_wareTitle];
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
    _picCount --;
    for (int i=0;i<_imgArray.count;i++) {
        UIImageView* imgView = (UIImageView*)[self.view viewWithTag:i+1];
        [imgView setImage:[_imgArray objectAtIndex:i]];
    }
    UIImageView* imgView = (UIImageView*)[self.view viewWithTag:_imgArray.count+1];
    [imgView setHidden:FALSE];
    [imgView setImage:[UIImage imageNamed:@"PlusIconNor"]];
    for(int i=5;i>_imgArray.count+1;i--)
    {
        UIView* View =  [self.view viewWithTag:i];
        [View setHidden:TRUE];
    }
}


-(void)addTap
{
 
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrentResponse)];
    [self.view addGestureRecognizer:tap];
}
-(void)resignCurrentResponse
{
      [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(IBAction)toSelLoss:(id)sender
{
    [self resignCurrentResponse];
    UIActionSheet *sheet;
    
    sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString* lossText in _lossArray) {
        [sheet addButtonWithTitle:lossText];
    }

    sheet.tag = 256;
    
    [sheet showInView:self.view];
}
-(IBAction)toSelDiscinct:(id)sender
{
    [self resignCurrentResponse];
    PersonalCenterAreaSelectViewController* vc = [[PersonalCenterAreaSelectViewController alloc]init];
    [vc setDistinctData:^(DistinctModel *pro, DistinctModel *city) {
        _pro = ( DistinctModel*)[pro copy];
        _city = ( DistinctModel*)[city copy];
        [_address setText:[NSString stringWithFormat:@"%@ %@",_pro.cityName,_city.cityName]];
    }];
    [self.navigationController pushViewController:vc animated:TRUE];
}
-(IBAction)toSelCategory:(id)sender
{
    [self resignCurrentResponse];
    GoodsCatagoryViewController* vc = [[GoodsCatagoryViewController alloc]init];
    vc.eGoodsCategoryModule = E_GoodsCategoryModule_FleaMarket;
    [vc setSelectGoodsCategoryBlock:^(GoodsCategoryModel *category) {
        _goodsCategory = category;
        [_type setText:_goodsCategory.categoryName];
    }];
    [self.navigationController pushViewController:vc animated:TRUE];
}
-(BOOL)toCheckCommit
{
    NSString *projectId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PROJECTID];
    
    if (![self isGoToLogin]) {
        return FALSE;
    }
    
    if(projectId == nil)
    {
        [Common showBottomToast:@"请选择小区"];
        return FALSE;
    }
    NSString* userId = [[LoginConfig Instance] userID];
    if(userId == nil)
    {
        [Common showBottomToast:@"用户账户不存在"];
        return FALSE;
    }
//    if(_wareTitle.text == nil || _warePrice.text == nil || _lossText == nil || _linkName.text == nil||_linkTel.text == nil || _address.text == nil || _city == nil || _goodsCategory == nil)
         if(_wareTitle.text == nil || _warePrice.text == nil || _lossText == nil || _linkName.text == nil||_linkTel.text == nil || _goodsCategory == nil)
    {
        [Common showBottomToast:@"请填写完整二手物品信息"];
        return FALSE;
    }
    
    if (![Common checkPhoneNumInput:_linkTel.text]) {
        [Common showBottomToast:@"请填写正确的手机号码"];
        return FALSE;
    }
    
    if (_wareDesc.text.length > 200) {
        [Common showBottomToast:@"亲，详情描述不能超过200字"];
        return FALSE;
    }
    
    return TRUE;
}
-(void)toCommitDetail
{
    /*
     title：			标题
     price：			价格
     degree：			新旧程度
     phone：			发布人电话
     person：			发布人
     personId :        发布人Id
     description：		详情描述
     picture ：		封面图片ID
     pictures :			详情图片ID
     gcId：			商品分类ID(如：电子产品>移动设备>手机，这个“分类ID”是“手					机类别ID”)
     cityId：			地区ID(如：江苏省>无锡市>江阴市，这个“地区ID”是“江阴市ID”)
     proectId			小区Id ( 项目Id )
     */
    NSString *projectId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PROJECTID];
    NSString* userId = [[LoginConfig Instance] userID];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_wareTitle.text forKey:@"title"];
    [dic setValue:_warePrice.text forKey:@"price"];
    [dic setValue:_lossText forKey:@"degree"];
    [dic setValue:_linkTel.text forKey:@"phone"];
    [dic setValue:_linkName.text forKey:@"person"];
    [dic setValue:userId forKey:@"personId"];
    if(_wareDesc.text != nil && [_wareDesc.text isEqualToString:@"物品详情补充(200字以内)"]==FALSE)
    {
        [dic setValue:_wareDesc.text forKey:@"description"];
    }
    else
    {
        [dic setValue:@"" forKey:@"description"];
    }
    if (_coverPicId) {
        [dic setValue:_coverPicId forKey:@"picture"];
    }else {
        [dic setValue:@"" forKey:@"picture"];
    }
    
    if(_recordId)
    {
        [dic setValue:_recordId forKey:@"pictures"];
    }else
    {
        [dic setValue:@"" forKey:@"pictures"];
    }
    [dic setValue:_goodsCategory.categoryId forKey:@"gcId"];
    [dic setValue:_city.cityId forKey:@"cityId"];
    [dic setValue:projectId forKey:@"projectId"];
    [self getStringFromServer:FleaMarket_Url path:FleaMarketUpdate_Path method:@"POST" parameters:dic success:^(NSString *result) {
        if ([result isEqualToString:@"1"]) {
            //[Common showBottomToast:@"提交成功"];
            UIAlertView*ale=[[UIAlertView alloc]initWithTitle:@"提交成功" message:@"提交成功，待管理员审核通过后方可在跳蚤市场显示，您也可以在我的跳蚤市场查看个人提交的物品详情。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [ale show];
            FleaMarketListViewController *vc = [[FleaMarketListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
//            [self.navigationController popViewControllerAnimated:TRUE];

        }
        else
        {
            [Common showBottomToast:@"提交失败"];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];

}
-(void)toCommitImg
{
    if([self toCheckCommit]==FALSE)
        return;
    if (_imgArray.count == 0) {
        [self toCommitDetail];
    }
    else
    {
        if (_coverPicId==nil) {
            _coverPicId = [[Common getUUIDString]lowercaseString];
        }
        if(_recordId==nil)
        {
            _recordId = [[Common getUUIDString]lowercaseString];
        }
        
        NSString *picId = _coverPicId;
        if (_picIndex > 0) {
            picId = _recordId;
        }
        _picIndex++;
        
        UIImage* image =  [_imgArray objectAtIndex:0];
        NSString* fileId = [[Common getUUIDString]lowercaseString];
        [self uploadImageWithUrl:FileManager_Url path:FileManager_Path fileid:fileId  image:image success:^(NSString *result) {
            [self uploadImgPathToServer:ServiceInfo_Url path:FleaMarketFiles_Path recordId:picId fileId:fileId success:^(NSString *result) {
                [_imgArray removeObjectAtIndex:0];
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
-(IBAction)clickCommit
{
    [self resignCurrentResponse];
    [_picArray removeAllObjects];
#if 0
    for(UIImage* image in _imgArray)
    {
        NSString* fileId = [[Common getUUIDString]lowercaseString];
        [self uploadImageWithUrl:FileManager_Url path:FileManager_Path fileid:fileId image:image success:^(NSString *result) {
            [_picArray addObject:fileId];
            if (_picArray.count == _imgArray.count) {
                [self toCommitDetail];
            }
        } failure:^(NSError *error) {
            [Common showBottomToast:Str_Comm_FileConnectFailed];
        }];
    }
#else
    [self getImgToArray];
    [self toCommitImg];
#endif
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
    if (actionSheet.tag == 256) {
        if (buttonIndex == 0 || buttonIndex>_lossArray.count) {
            return;
        }
        _lossText = [_lossArray objectAtIndex:buttonIndex-1];
        [_loss setText:_lossText];
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
        [ _img3 setHidden:FALSE];
    }
    else if(_imgArray.count==2)
    {
        [_img3 setImage:image];
        [ _img4 setHidden:FALSE];
    }
    else if(_imgArray.count==3)
    {
        [_img4 setImage:image];
        [ _img5 setHidden:FALSE];
    }
    else if(_imgArray.count==4)
    {
        [_img5 setImage:image];

    }
    [_imgArray addObject:image];
    _picCount ++;

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark---UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:Str_FleaMarket_Desc_Default] == TRUE) {
        textView.text = @"";
    }
    
    return TRUE;
}
//2016.03.24
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>200) {
        textView.text = [textView.text substringToIndex:200];
    }
}

#pragma mark --- UITextFieldDelegate
/*由于联想输入的时候，函数textView:shouldChangeTextInRange:replacementText:无法判断字数，
 因此使用textViewDidChange对TextView里面的字数进行判断
 */
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.wareTitle) {
        if (textField.text.length > 15) {
            textField.text = [textField.text substringToIndex:15];
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}
 

//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [self.view setFrame:CGRectMake(0, Navigation_Bar_Height, self.view.bounds.size.width, self.view.bounds.size.height)];
//    
//}
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if([textField isEqual:_linkTel] || [textField isEqual:_linkName])
//    {
//        CGFloat hight = 252;
//        [self.view setFrame:CGRectMake(0, Navigation_Bar_Height-hight, self.view.bounds.size.width, self.view.bounds.size.height)];
//    }
//}
#define SCROLLVIEWHEIGHT 614
-(void)keyboardDidShow:(NSNotification *)notification
{
 
    [super keyboardDidShow:notification];
    self.scrollContextViewHeight.constant = 614+    self.keyboardHeight;
}
- (void)keyboardDidHide
{
    self.scrollContextViewHeight.constant = 614;
    [super keyboardDidHide];
}
@end
