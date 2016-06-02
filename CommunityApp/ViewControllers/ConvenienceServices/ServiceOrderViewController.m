 //
//  ServiceOrderViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//  预约画面

#import "ServiceOrderViewController.h"
#import "ShoppingCartViewController.h"
#import "DBOperation.h"
#import "ImageDetailViewController.h"
#import "RoadAddressManageViewController.h"
#import "CouponSelectViewController.h"
#import "PersonalCenterMyOrderViewController.h"
#import "RoadData.h"
#import "PayMethodViewController.h"
#import "Coupon.h"
#import "CommitResultViewController.h"

@interface ServiceOrderViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIGestureRecognizerDelegate,ImageDetailViewDelegate,PayMethodViewDelegate>

@property (strong,nonatomic) IBOutlet UIView *displayView;
@property (strong,nonatomic) IBOutlet UIImageView* img1;
@property (strong,nonatomic) IBOutlet UIImageView* img2;
@property (strong,nonatomic) IBOutlet UIImageView* img3;


@property (strong,nonatomic)IBOutlet UITextView* remarks;
@property (strong,nonatomic)IBOutlet UITableView* table;
@property (strong,nonatomic)IBOutlet UIView* tableHead;
@property (strong,nonatomic)IBOutlet UIView* tableFoot;
@property (strong,nonatomic)IBOutlet UIButton* dateImm;
@property (strong,nonatomic)IBOutlet UIButton* dateAppoint;
@property (strong,nonatomic)IBOutlet UIView* datePickView;
@property (strong,nonatomic)IBOutlet UIView* datePickBg;
@property (strong,nonatomic)IBOutlet UIDatePicker * datePick;
@property (strong,nonatomic)IBOutlet UILabel * dateLabel;

@property(strong,nonatomic)IBOutlet UIButton* dateCancelBtn;
@property(strong,nonatomic)IBOutlet UIButton* dateOkBtn;
@property(strong,nonatomic)IBOutlet UIButton* datePickSwitchBtn;
@property (assign,nonatomic)CGFloat remarkTextHeight;
@property (strong,nonatomic) NSMutableArray* picArray;
@property (assign,nonatomic) NSInteger selImageTag;


@property (weak, nonatomic) IBOutlet UILabel *servicePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactTelLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@property (weak, nonatomic) IBOutlet UIView *servicePriceView;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UIView *totalPriceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *servicePriceViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalPriceViewHeight;

@property (strong,nonatomic) RoadData* roadData;
@property (copy,nonatomic) NSString* orderId;
@property (copy,nonatomic) NSString* orderNo;
@property (strong,nonatomic) Coupon* useCoupon;
@property (assign,nonatomic)CGFloat discount;
@property (strong,nonatomic) NSMutableArray* imgArray;
@property (assign,nonatomic) NSInteger picCount;
@property (nonatomic, copy) NSString            *couponIds;
@end


@implementation ServiceOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 初始化导航栏信息
    self.navigationItem.title = Str_Order_Immediately;
    [self setNavBarLeftItemAsBackArrow];
    
    // 初始化基本信息
    [self initBasicDataInfo];
   
    // 添加手势
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrentResponse)]];
    [self hideDatePickView];
    _picArray = [[NSMutableArray alloc]init];
    [_img3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    [_img1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    [_img2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)]];
    [self getDefaultUser];
   // [self defaultRoad];
    [self freshDiscount];
}
-(void)displayContact
{
    if (self.roadData != nil) {
        if(self.roadData.address!=nil)
            [_contactAddrLabel setText:self.roadData.address];
        if(self.roadData.contactName!=nil)
            [_contactNameLabel setText:self.roadData.contactName];
        if(self.roadData.contactTel!=nil)
            [_contactTelLabel setText:self.roadData.contactTel];
    }
}
-(void)getDefaultUser
{
    NSString *userId = [[LoginConfig Instance] userID];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: userId,@"userId",nil];
    
    [self getArrayFromServer:ServiceInfo_Url path:DefaultRoadAddress_path method:@"GET" parameters:dic xmlParentNode:@"buildingLocation" success:^(NSMutableArray *result){
        for (NSDictionary *dicResult in result)
        {
            if (dicResult.count > 0) {
                self.roadData = [[RoadData alloc] initWithDictionary:dicResult];
            }
        }
        [self displayContact];
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}
#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    if ([self.serviceDetail.payService isEqualToString:@"先付费"]) {
        [self.servicePriceLabel setText:self.serviceDetail.servicePrice];
        [self.servicePriceView setHidden:NO];
        [self.couponView setHidden:NO];
        [self.totalPriceView setHidden:NO];
        _tableHead.frame = CGRectMake(0, 0, Screen_Width, 60);
        _tableFoot.frame = CGRectMake(0, 0, Screen_Width, 415);
    }else {
        [self.servicePriceView setHidden:YES];
        [self.couponView setHidden:YES];
        [self.totalPriceView setHidden:YES];
        
        self.servicePriceViewHeight.constant = 0;
        self.couponViewHeight.constant = 0;
        self.totalPriceViewHeight.constant = 0;
         _tableHead.frame = CGRectMake(0, 0, Screen_Width, 60);
        _tableFoot.frame = CGRectMake(0, 0, Screen_Width, 296);
    }
    
    _remarkTextHeight = 60.0f;
  
    _table.tableHeaderView = _tableHead;
    _table.tableFooterView = _tableFoot;
    [_dateAppoint setSelected:YES];
    _imgArray = [[NSMutableArray alloc]init];
}

-(void)payOk
{
   if(_orderId == nil)
       return;
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: _orderId,@"orderId",nil];
    
    [self getStringFromServer:SubmitOrder_Url path:PaySuccessServiceOrder_Path method:@"POST" parameters:dic success:^(NSString *result) {
        if ([result isEqualToString:@"0"]) {
            [Common showBottomToast:@"提交订单失败"];
            return ;
        }
        [self toOrderList];
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}
#pragma mark---PayMethodViewDelegate
-(void)paymentOkTodo
{
    [self payOk];
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
    _selImageTag = delIndex;
    if (_imgArray.count < _selImageTag) {
        return;
    }
    _picCount --;
    [_imgArray removeObjectAtIndex:_selImageTag];
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
-(void)toPay
{
    PayMethodViewController* vc = [[PayMethodViewController alloc]init];
    vc.delegate = self;
    vc.orderId = self.orderNo;
    NSString *orderPrice =  [_totalPrice.text substringFromIndex:1];
    vc.amount = [orderPrice floatValue];
    [self.navigationController pushViewController:vc animated:TRUE];
    
}
#pragma mark--IBAction
//提交服务订单
-(BOOL)toCheckCommit
{
    if(![self isGoToLogin])
    {
        return FALSE;
    }
    
    if (_remarks.text.length > 200) {
        [Common showBottomToast:@"详情描述不能超过200字"];
        return FALSE;
    }
    
    if (_dateLabel.text ==nil || [_dateLabel.text isEqualToString:@"请选择"]) {
        [Common showBottomToast:@"请选择预约时间"];
        return FALSE;
    }
    
    if(_contactTelLabel.text == nil || _contactAddrLabel.text == nil || [_contactAddrLabel.text isEqualToString:@""] || _contactNameLabel.text == nil || [_contactNameLabel.text isEqualToString:@""] || [_contactAddrLabel.text isEqualToString:@"请选择联系地址"] || [_contactNameLabel.text isEqualToString:@"请选择联系人"])
    {
        [Common showBottomToast:@"请选择联系人"];
        return FALSE;
    }
    NSString* serviceId = _serviceDetail.serviceId;
    if (serviceId == nil || [serviceId isEqualToString:@""]) {
        [Common showBottomToast:@"服务信息不正，请联系商家或物业"];
        return FALSE;
    }
    return TRUE;
}
//#pragma mark-获取默认地址
//-(void)defaultRoad
//{
//    UserModel* user = [[Common appDelegate].userArray objectAtIndex:0];
//    // 请求服务器获取数据
//    NSString *userId = user.userId;
//    
//    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:   userId,@"userId",nil];
//    [self getArrayFromServer:ServiceInfo_Url path:@"getBuildLocation" method:@"GET" parameters:dic xmlParentNode:@"buildingLocation" success:^(NSMutableArray *result)
//     {
//         for (NSDictionary *dicResult in result)
//         {
//             RoadData *roadData = [[RoadData alloc] initWithDictionary:dicResult];
//             
//#pragma mark-设置提交订单的默认联系人和地址
//             [_contactAddrLabel setText:[NSString stringWithFormat:@"%@  %@",roadData.projectName, roadData.address]];
//             [_contactNameLabel setText:roadData.contactName];
//             [_contactTelLabel setText:roadData.contactTel];
//             
//         }
//         
//     }
//                     failure:^(NSError *error)
//     {
//         [Common showBottomToast:Str_Comm_RequestTimeout];
//     }];
//    
//}
//
-(void) toCommitDetail
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:KEY_PROJECTID];
    NSString *projectName = [userDefault objectForKey:KEY_PROJECTNAME];
    
    
    self.serviceDetail.serviceTime = _dateLabel.text;
    NSMutableString* picUrl = [[NSMutableString alloc]initWithString:@""];
    for (NSString* pic in _picArray) {
        [picUrl appendString:pic];
        [picUrl appendFormat:@","];
    }
    if(_picArray.count!=0)
        self.serviceDetail.servicePicUrl = [picUrl copy];
    // 初始化参数
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString* serviceId = _serviceDetail.serviceId;
    
    [dic setObject:serviceId forKey:@"gmId"];
    if(_serviceDetail.servicePrice !=nil)
    {
        [dic setObject:_serviceDetail.servicePrice forKey:@"price"];
    }
    NSString *orderPrice =  [_totalPrice.text substringFromIndex:1];
    [dic setObject:orderPrice forKey:@"totalMoney"];
    
    [dic setObject:projectId forKey:@"projectId"];
    [dic setObject:projectName forKey:@"projectName"];
    [dic setObject:_dateLabel.text forKey:@"reserveTime"];
    [dic setObject:[[LoginConfig Instance] userID] forKey:@"userId"];
    [dic setObject:_contactNameLabel.text forKey:@"receiver"];
    [dic setObject:_contactTelLabel.text forKey:@"linkNumber"];
    [dic setObject:_contactAddrLabel.text forKey:@"receiveAddress"];
    if (_couponIds == nil) {
        [dic setObject:@"" forKey:@"couponsId"];
    }else {
        [dic setObject:_couponIds forKey:@"couponsId"];
    }
    
    if(_remarks.text !=nil)
    {
        [dic setObject:_remarks.text forKey:@"remark"];
    }
    
    // 请求服务器提交数据
    [self getStringFromServer:SubmitOrder_Url path:ServiceSubmit_Path method:@"POST" parameters:dic success:^(NSString *result) {
        if ([result isEqualToString:@"error"]) {
            [Common showBottomToast:@"订单提交失败"];
        }
        else {
            NSArray* dataArray = [result componentsSeparatedByString:@"#"];
            if (dataArray.count!=0) {
                _orderId = [dataArray objectAtIndex:0];
                _orderNo = [dataArray objectAtIndex:1];
            }
            [self toCommitOther];
           
        }
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        
    }];
    //    if ([[DBOperation Instance] insertServiceData:self.serviceDetail]) {
    //        ShoppingCartViewController* car = [[ShoppingCartViewController alloc]init];
    //        car.eFromType = E_CartViewFromType_Push;
    //        [self.navigationController pushViewController:car animated:TRUE];
    //    }

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
-(void)toCommitOther
{
    [self getImgToArray];
    [self toCommitImg];
}
-(void)toCommitImg
{
    if (_imgArray.count==0) {
        NSString *orderPrice =  [_totalPrice.text substringFromIndex:1];
        CGFloat price = [orderPrice floatValue];
        if([self.serviceDetail.payService isEqualToString:@"先付费"]){
            if (price - 0.0099 > 0) {
                [self toPay];
            }else {
                [self payOk];
            }
        }else {
            CommitResultViewController *vc = [[CommitResultViewController alloc] init];
            vc.eFromViewID = E_ResultViewFromViewID_SubmitServiceOrder;
            vc.resultTitle = @"下单成功";
            vc.resultDesc = [NSString stringWithFormat:@"您已成功提交订单"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        UIImage* image =  [_imgArray objectAtIndex:0];
        NSString* fileId = [[Common getUUIDString]lowercaseString];
        [self uploadImageWithUrl:FileManager_Url path:FileManager_Path fileid:fileId  image:image success:^(NSString *result) {
            [self uploadImgPathToServer:ServiceInfo_Url path:MyPostRepairUploadFiles_Path recordId:_orderId fileId:fileId success:^(NSString *result) {
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

-(IBAction)clickCommit:(id)sender
{

    if ([self toCheckCommit ] == FALSE) {
        return;
    }
    
    [self toCommitDetail];
    
}
-(void)toOrderList
{
    PersonalCenterMyOrderViewController* vc = [[PersonalCenterMyOrderViewController alloc]init];
    vc.orderType = OrderType_Service;
    [self.navigationController pushViewController:vc animated:TRUE];
}
-(IBAction)clickImgPicker:(id)sender
{
    [self hideDatePickView];
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



-(IBAction)clickImm:(id)sender
{
    [self hideDatePickView];
    [_dateImm setSelected:TRUE];
    [_dateAppoint setSelected:FALSE];
    [_datePickSwitchBtn setHidden:TRUE];
    [_dateLabel setText:@"半小时内"];
    self.serviceDetail.appointmentType = 1;
    
}
-(IBAction)clickAppoint:(id)sender
{
    [_dateImm setSelected:FALSE];
    [_dateAppoint setSelected:TRUE];
    [_datePickSwitchBtn setHidden:FALSE];
    [_dateLabel setText:@"请选择时间"];
    self.serviceDetail.appointmentType = 2;
}
-(IBAction)clickSwitch:(id)sender
{
    
    [self showDatePickView];
}
-(IBAction)clickDatePickCancel:(id)sender
{
    [self hideDatePickView];
    
}
-(IBAction)clickDatePickOk:(id)sender
{
    NSString* time = [self stringFromDate:_datePick.date formateString:nil];
    [_dateLabel setText:time];
    [self hideDatePickView];

}

// 联系人信息选择--跳转到楼址管理画面
- (IBAction)contactInfoClickhandler:(id)sender
{
    RoadAddressManageViewController *vc = [[RoadAddressManageViewController alloc] init];
    vc.isAddressSel = addressSel_Default;
    vc.showType = ShowDataTypeAll;
    [vc setSelectRoadData:^(RoadData *road) {
        _roadData = road;
        [self displayContact];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

// 优惠券选择--跳转到选择优惠券画面
- (IBAction)selectCouponBtnClickHandler:(id)sender
{
    CouponSelectViewController* vc = [[CouponSelectViewController alloc]init];
    vc.goodsId = _serviceDetail.serviceId;
//    [vc setSelectCouponBlock:^(Coupon *coupon) {
//        _useCoupon = coupon;
//        [self freshDiscount];
//    }];
    
    [vc setSelectCouponsBlock:^(NSArray *coupons) {
        CGFloat discount = 0.0;
        if (coupons.count == 1) {
            Coupon *coupon = [coupons objectAtIndex:0];
            if (![coupon.ticketstype isEqualToString:@"4"]) {
                discount = [coupon getDiscountMoneyWithPrice:([_serviceDetail.servicePrice floatValue])];
            }
            _couponIds = coupon.cpId;
        }else if (coupons.count > 1) {
            for (Coupon *coupon in coupons) {
                discount += [coupon.preferentialPrice floatValue];
                _couponIds = [_couponIds stringByAppendingString:[NSString stringWithFormat:@"%@,", coupon.cpId]];
            }
            if (_couponIds.length > 0) {
                _couponIds = [_couponIds substringWithRange:NSMakeRange(0, _couponIds.length-1)];
            }
            if ((discount - [_serviceDetail.servicePrice floatValue])>=0) {
                discount = [_serviceDetail.servicePrice floatValue];
            }
        }
        [Common showBottomToast:@"多余金额不退换"];
        _discount = discount;
        [self freshDiscount];
    }];
    vc.selectCouponIds = [_couponIds componentsSeparatedByString:@","];
    [self.navigationController pushViewController:vc animated:TRUE];
}
-(void)freshDiscount{
//    if(_useCoupon)
//        _discount = [_useCoupon billByCouponWithNum: 1 price:[[_serviceDetail servicePrice] floatValue]];
    [_couponLabel setText:[NSString stringWithFormat:@"-￥%.2f",_discount]];
    [_totalPrice setText:[NSString stringWithFormat:@"￥%.2f", [[_serviceDetail servicePrice] floatValue]-_discount]];
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
    _picCount ++;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - ContactSelectDelegate


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
    [self hideDatePickView];
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
-(void)resignCurrentResponse
{
    [_remarks resignFirstResponder];
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

-(void)showDatePickView
{
    [self setDatePickConstraint];
    [_datePickView setHidden:FALSE];
}
-(void)hideDatePickView
{
    if(_datePickView.hidden == FALSE)
        [_datePickView setHidden:TRUE];
}
-(void)setDatePickConstraint
{
    NSDate* current = [NSDate date];
    NSDate* minDate = [[NSDate alloc]initWithTimeInterval:60*30 sinceDate:current];
    [_datePick setMinimumDate:minDate];
    _datePick.date = minDate;
    NSMutableString* today = [[NSMutableString alloc]initWithString:[self stringFromDate:minDate formateString:@"yyyy-MM-dd"]];
    [today appendString:@" 23:59:59"];
    NSDate* todayDate = [self dateFromString:today formateString:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval interval = [todayDate timeIntervalSinceDate:minDate]+6*60*60*24+1;
    
    NSDate* maxDate = [[NSDate alloc]initWithTimeInterval:interval sinceDate:minDate];
    [_datePick setMaximumDate:maxDate];
}
- (NSString *)stringFromDate:(NSDate *)date formateString:(NSString*)string{
   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    

    if(string == nil)
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    else
    {
        [dateFormatter setDateFormat:string];
    }
    
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}
- (NSDate *)dateFromString:(NSString *)dateString formateString:(NSString*)string{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if(string == nil)
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    else
    {
        [dateFormatter setDateFormat:string];
    }

    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}



#pragma mark - 内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
