//
//  AfterSaleApplyViewController.m
//  CommunityApp
//
//  Created by issuser on 15/8/3.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "AfterSaleApplyViewController.h"
#import "AfterSaleReasonViewController.h"
#import "AfterSalesReason.h"
#import "ImageDetailViewController.h"

@interface AfterSaleApplyViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,ImageDetailViewDelegate,UITextViewDelegate>
@property (strong,nonatomic) IBOutlet UIView *displayView;
@property (strong,nonatomic) IBOutlet UIImageView* img1;
@property (strong,nonatomic) IBOutlet UIImageView* img2;
@property (strong,nonatomic) IBOutlet UIImageView* img3;
@property (weak, nonatomic) IBOutlet UILabel *asTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *asReasonLabel;
@property (weak, nonatomic) IBOutlet UIView *expressCompanyView;
@property (weak, nonatomic) IBOutlet UIView *expressNoView;

// Button


// UITextField / UITextView

@property (weak, nonatomic) IBOutlet UITextField *asGoodsNumTextField;
@property (weak, nonatomic) IBOutlet UILabel *asAmountLabel;
@property (weak, nonatomic) IBOutlet UITextView *asDetailTextView;
@property (weak, nonatomic) IBOutlet UIView *goodsNumView;

@property (weak, nonatomic) IBOutlet UITextField *expressCompanyTextField;
@property (weak, nonatomic) IBOutlet UITextField *expressNoTextField;
@property (weak, nonatomic) IBOutlet UIView *commentView;
// Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsNumViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expressCompanyViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expressNoViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewConstraint;
@property (strong,nonatomic) NSMutableArray *newimgArray;
@property (strong,nonatomic) NSMutableArray* imgArray;
@property (strong,nonatomic) NSMutableArray* picArray;
//UUID
@property (strong,nonatomic) NSString* recoreId;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property (strong,nonatomic) NSLayoutConstraint* scrollHeight;
@property (assign,nonatomic) NSInteger picCount;
@end

@implementation AfterSaleApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_AfterSale_Apply_Title;
    [self initViewBaseData];
    self.goodsNumViewConstraint.constant = 0;
    _goodsNumView.hidden = YES;
    
    _imgArray  = [[NSMutableArray alloc]init];
    [_img3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    [_img1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    [_img2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    _picArray = [[NSMutableArray alloc]init];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrResponse)];
    [self.view addGestureRecognizer:tap];
}

-(void)resignCurrResponse
{
    [[[UIApplication sharedApplication]keyWindow]endEditing:TRUE];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:Str_AfterSale_Remark_Default]) {
        textView.text = @"";
        [textView setTextColor:[UIColor colorWithRed:57.0/255 green:57.0/255 blue:57.0/255 alpha:1]];
     }
    return TRUE;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化View数据
- (void)initViewBaseData {
    // 设置售后类型
    switch (self.asModel.afterSalesType) {
/*        case OnlyReturn:
//            [self.asTypeLabel setText:@"只退货"];
//            break;*/
        case OnlyRefund:
            [self.asTypeLabel setText:@"只退款"];
            [_expressCompanyView setHidden:YES];
            [_expressNoView setHidden:YES];
            _expressCompanyViewConstraint.constant = 0;
            _expressNoViewConstraint.constant = 0;
            break;
        default:
            [self.asTypeLabel setText:@"退货并退款"];
            break;
    }
    // 设置退货金额
    [self.asAmountLabel setText:self.asModel.refundAmount];
    if(_asModel.afterSaleReasonId)
        [self.asReasonLabel setText:self.asModel.afterSaleReasonId];
    if(_asModel.details)
    {
        [self.asDetailTextView setText:_asModel.details];
    }
}

- (IBAction)clickAsTypeBtn:(id)sender {
//    if(_asModel.afterSalesType)
//        return;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:/*@"只退货",*/ @"只退款", @"退货并退款", nil];
    actionSheet.tag = 255;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255){
        if (buttonIndex == 0 || buttonIndex ==1) {
            if (buttonIndex == 0 ) {
//            [self.asTypeLabel setText:@"只退货"];
//                _asModel.afterSalesType = OnlyReturn;
                [self.asTypeLabel setText:@"只退款"];
                _asModel.afterSalesType = OnlyRefund;
                self.expressCompanyViewConstraint.constant = 0;
                _expressCompanyView.hidden = YES;
                _expressNoView.hidden = YES;
                self.expressNoViewConstraint.constant = 0;

            }else
            {
              [self.asTypeLabel setText:@"退货并退款"];
              _asModel.afterSalesType = ReturnAndRefund;
                
                _expressCompanyView.hidden = NO;
                self.expressCompanyViewConstraint.constant = 45;
                _expressNoView.hidden = NO;
                self.expressNoViewConstraint.constant = 45;
            }

        }
//        else if (buttonIndex == 1) {
//            [self.asTypeLabel setText:@"只退款"];
//           
//            self.expressCompanyViewConstraint.constant = 0;
//            _expressCompanyView.hidden = YES;
//            _expressNoView.hidden = YES;
//            self.expressNoViewConstraint.constant = 0;
//            _asModel.afterSalesType = OnlyRefund;
//            
//        }
        if(buttonIndex == 0)//1  *2
            self.scrollViewConstraint.constant = 529-45*3;
        else
        {
           self.scrollViewConstraint.constant = 529; 
        }
    }
    else if (actionSheet.tag == 256) {
        
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

- (void)showGoodsNumView:(UIView *)view {
    if (view.hidden == YES) {
        view.hidden = NO;
        self.goodsNumViewConstraint.constant = 45;
    }
}
//售后原因
- (IBAction)clickAsReasonBtn:(id)sender {
    [self resignCurrResponse];
    AfterSaleReasonViewController *vc = [[AfterSaleReasonViewController alloc] init];
    [vc setAsReasonModel:^(AfterSalesReason *reason) {
        [self.asReasonLabel setText:reason.afterSalesReasonName];
        _asModel.afterSaleReasonId = reason.afterSalesReasonName;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickAsMinusBtn:(id)sender {
    NSInteger goodsNum =  _asGoodsNumTextField.text.intValue - 1;
    [self setAsGoodsNum:goodsNum];
    [self resignCurrResponse];
}

- (IBAction)clickAsPlusBtn:(id)sender {
    NSInteger goodsNum =  _asGoodsNumTextField.text.intValue + 1;
    [self setAsGoodsNum:goodsNum];
    [self resignCurrResponse];
}

- (void)setAsGoodsNum:(NSInteger)goodsNum {
    [_asGoodsNumTextField setText:[NSString stringWithFormat:@"%ld",(long)goodsNum]];
}

- (IBAction)clickAsFileBtn:(id)sender {
}

- (IBAction)clickAsSubmitBtn:(id)sender {
    AfterSaleReasonViewController *vc = [[AfterSaleReasonViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(BOOL)toCheckCommit
{
    [self resignCurrResponse];
    if (![self isGoToLogin]) {
        return FALSE;
    }
    if(_asModel.afterSalesType == OnlyUnKnown)
    {
        [Common showBottomToast:@"请选择售后类型"];
        return FALSE;
    }
    if(_asModel.afterSaleReasonId==nil || [_asModel.afterSaleReasonId isEqualToString:@""])
    {
        [Common showBottomToast:@"请选择售后原因"];
        return FALSE;
    }
 
    if((_asModel.afterSalesType == OnlyReturn || _asModel.afterSalesType == ReturnAndRefund) &&( _expressCompanyTextField.text.length == 0 || _expressNoTextField.text.length == 0))
    {
        [Common showBottomToast:@"请填写快递公司和快递单号"];
        return FALSE;
    }
    return TRUE;
}
-(void)toCommitDetail
{
   
    NSString* expressCompany = @"";
    NSString* expressNo = @"";
    if((_asModel.afterSalesType == OnlyReturn || _asModel.afterSalesType == ReturnAndRefund) &&( _expressCompanyTextField.text.length == 0 || _expressNoTextField.text.length == 0))
    {
        [Common showBottomToast:@"请填写快递公司和快递单号"];
        return;
    }
    else
    {
        expressCompany = _expressCompanyTextField.text;
        expressNo = _expressNoTextField.text;
    }
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    NSString* url = SaveTbgAfterSale_Url;
    NSString*path = SaveTbgAfterSale_Path;
    if (_asModel.afterSalesId) {
        [dic setValue:[NSString stringWithFormat:@"%@",_asModel.afterSalesId] forKey:@"afterSalesId"];
        url = UpdateTbgAfterSale_Url;
        path = UpdateTbgAfterSale_Path;
        [dic setValue:_asModel.returnGoodsNum forKey:@"returnGoodsNum"];
    }
    else
    {
        [dic setValue:_asModel.orderId  forKey:@"orderId"];
        [dic setValue:@"" forKey:@"sellerId"];
        [dic setValue:@"" forKey:@"goodsId"];
        [dic setValue:@"" forKey:@"returnGoodsNum"];
        [dic setValue:expressCompany forKey:@"expressCompany"];
        [dic setValue:expressNo forKey:@"waybill"];
    }
    [dic setValue:[NSString stringWithFormat:@"%u",_asModel.afterSalesType] forKey:@"afterSalesType"];
    [dic setValue:[NSString stringWithFormat:@"%@",_asModel.afterSaleReasonId] forKey:@"afterSalesReason"];
    
    [dic setValue:[[LoginConfig Instance] userID] forKey:@"userid"];
    [dic setValue:_asModel.refundAmount forKey:@"refundAmount"];
    if(_recoreId==nil)
        [dic setValue:@"" forKey:@"recordId"];
    else
        [dic setValue:_recoreId forKey:@"recordId"];
    
    //recordsid orderid
    NSString* remark = @"";
    if (_asDetailTextView.text) {
        remark = _asDetailTextView.text;
    }
    [dic setValue:remark forKey:@"details"];
    [self getArrayFromServer:url path:path method:@"POST" parameters:dic xmlParentNode:@"list" success:^(NSMutableArray *result) {
        NSDictionary* resultDic = [result objectAtIndex:0];
        if([[resultDic  objectForKey:@"result"] isEqualToString:@"1"])
        {
            [Common showBottomToast:@"提交申请成功"];
            [self.navigationController popViewControllerAnimated:TRUE];
        }
        else{
            [Common showBottomToast:[resultDic  objectForKey:@"msg"]];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}
-(void)toCommitImg
{
    if([self toCheckCommit ]==FALSE)
        return;
    if (_imgArray.count == 0) {
        [self toCommitDetail];
    }
    else
    {
        if ((_asModel.afterSalesId==nil || [_asModel.afterSalesId isEqualToString:@""]) && _recoreId==nil) { 
            _recoreId = [[Common getUUIDString] lowercaseString];
        }
        UIImage* image =  [_imgArray objectAtIndex:0];
        NSString* fileId = [[Common getUUIDString]lowercaseString];
        [self uploadImageWithUrl:FileManager_Url path:FileManager_Path fileid:fileId  image:image success:^(NSString *result) {
            [self uploadImgPathToServer:UploadAfterSaleFiles_Url path:UploadAfterSaleFiles_Path recordId:_recoreId fileId:fileId success:^(NSString *result) {
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
- (IBAction)  saveTbgAfterSale {
#if 0
    [_picArray removeAllObjects];
    for(UIImage* image in _imgArray)
    {
        NSString* fileId = [[Common getUUIDString]lowercaseString];
        [self uploadImageWithUrl:FileManager_Url path:FileManager_Path fileid:fileId image:image success:^(NSString *result) {
            [self uploadImgPathToServer: UploadAfterSaleFiles_Url path:UploadAfterSaleFiles_Path recordId:_recoreId fileId:fileId];
            [_picArray addObject:fileId];
            if(_picArray.count == _imgArray.count)
            {
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
- (IBAction)clickImgPicker:(id)sender
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
    
    sheet.tag = 256;
    
    [sheet showInView:self.view];
}


#pragma mark---UIGestureRecognizerDelegate
-(void)handleSingleFingerEvent:(UITapGestureRecognizer *)tapGesture
{
    [self resignCurrResponse ];
    if([tapGesture view].tag>_imgArray.count)
    {
        [self clickImgPicker:[tapGesture view]];
        return;
    }
    ImageDetailViewController* vc = [[ImageDetailViewController alloc]init];

    [vc setImageDetail:_imgArray];
    vc.currentSelectedPage = [tapGesture view].tag-1;
    
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:TRUE];
    
}
-(void)clickDel:(NSInteger)delIndex
{
 
    if (_imgArray.count < delIndex) {
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
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if(_imgArray.count == 0)
    {
        [ _img1 setImage:image];
        [_img2 setHidden:FALSE];
    }
    else  if(_imgArray.count == 1)
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
#pragma mark---UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[[UIApplication sharedApplication] keyWindow]endEditing:TRUE];
    return TRUE;
}
#define SCROLLCONTENTHEIGHT 529
-(void)keyboardDidShow:(NSNotification *)notification
{
    [super keyboardDidShow:notification];
    _scroll.contentSize  = CGSizeMake(Screen_Width, SCROLLCONTENTHEIGHT+self.keyboardHeight);
}
-(void)keyboardDidHide
{
    _scroll.contentSize  = CGSizeMake(Screen_Width, SCROLLCONTENTHEIGHT );
    [super keyboardDidHide];
}
@end
