//
//  VisitorPassportViewController.m
//  CommunityApp
//
//  Created by iss on 7/1/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "VisitorPassportViewController.h"
#import "VisitorPassportViewControllerTableViewCell.h"
#import "VisitReasonModel.h"
#import "LoginConfig.h"
#import "RoadData.h"
#import "QRCodeGenerator.h"
#import "UIImageView+AFNetworking.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ISSContent.h>
#import "RoadAddressManageViewController.h"

#define REASON_SHEET_TAG 255
#define COUNT_SHEET_TAG REASON_SHEET_TAG+1
#define DAYS_SHEET_TAG COUNT_SHEET_TAG+1
#define SHARE_SHEET_TAG DAYS_SHEET_TAG+1
typedef enum
{
    VisitPassRow_VisitName = 0,
    VisitPassRow_Count  ,
    VisitPassRow_Days,
    VisitPassRow_Reason ,
}VisitPassRow_Type;
@interface VisitorPassportViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    NSArray* array;
    VisitReasonModel* reason;
    NSMutableArray* visitorReasonData;
    NSInteger visitCount;
    NSInteger visitDays;
    NSString* name;
    NSString * maxDateString;
    UIImage*  imageShare;
}
@property (strong,nonatomic) IBOutlet UIView* tableHead;
@property (strong,nonatomic) IBOutlet UIView* tableFooter;
@property (weak, nonatomic) IBOutlet UIImageView *vHeadLine;

@property (strong,nonatomic) IBOutlet UITableView* table;
@property (strong,nonatomic) IBOutlet UIView* contextBg;
@property (strong,nonatomic) IBOutlet UIButton* shareBtn;
@property (strong,nonatomic) IBOutlet UILabel* reasonLabel;
@property (strong,nonatomic) RoadData* roadData;
@property (strong,nonatomic) IBOutlet UILabel* validateLabel;
@property (strong,nonatomic) IBOutlet UILabel* visitAddressLabel;
@property (strong,nonatomic) IBOutlet UILabel* visitNameLabel;
@property (strong,nonatomic) IBOutlet UILabel* visitTelLabel;
@property (strong,nonatomic) IBOutlet UILabel* userNameLabel;
@property (strong,nonatomic) IBOutlet UILabel* visitCountLabel;
@property (strong,nonatomic) IBOutlet UILabel* passTypeLabel;
@property (strong,nonatomic) IBOutlet UILabel* visitAddressText;
@property (strong,nonatomic) IBOutlet UIView*  visitBgView;
@property (strong,nonatomic) IBOutlet UIImageView*  shareImg;
@end

@implementation VisitorPassportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Str_Passport_Title;
    [self setNavBarLeftItemAsBackArrow];
    array=@[@[Str_Passport_Vistor],@[Str_Passport_Count,Str_Passport_CommText],@[Str_Passport_Invalid,Str_Passport_InvalidText],@[Str_Passport_Reason,Str_Passport_CommText]];
    _table.tableHeaderView = _tableHead;
    _table.tableFooterView = _tableFooter;
    _reasonLabel.numberOfLines = 0;
    _reasonLabel.lineBreakMode = NSLineBreakByWordWrapping;
    visitorReasonData = [[NSMutableArray alloc]init];
    [self initBasicDataInfo];
    _visitAddressText.numberOfLines = 0;
    _visitAddressText.lineBreakMode = NSLineBreakByWordWrapping;
    
    [Common updateLayout:_vHeadLine where:NSLayoutAttributeHeight constant:0.5];
    
    // 添加手势隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDefaultRoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identify = @"VisitorPassportViewControllerTableViewCell";
    VisitorPassportViewControllerTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil]lastObject];
    }
    [cell loadCellData:[array objectAtIndex:indexPath.row] textFieldDelegate:self];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == VisitPassRow_Reason)
    {
        [self popReasonSheet];
    }else if(indexPath.row == VisitPassRow_Count)
    {
        [self popCountSheet];
    }else if(indexPath.row == VisitPassRow_Days)
    {
        [self popDaysSheet];
    }
}

#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    // 请求服务器获取周边商家数据
    [self getDataFromServer];
    
}

// 从服务器端获取数据
- (void)getDataFromServer
{
    
    // 请求服务器获取数据
    [self getArrayFromServer:VisitPass_Url path:DownVisitReason_Path method:@"GET" parameters:nil xmlParentNode:@"visitReason" success:^(NSMutableArray *result) {
        for (NSDictionary *dicResult in result)
        {
            [visitorReasonData addObject:[[VisitReasonModel alloc]initWithDictionary:dicResult] ];
            
        }
        [_table reloadData];
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
   
}
-(void)getDefaultRoad
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
        if (self.roadData.buildingId == nil || [self.roadData.buildingId isEqualToString:@""] || [self.roadData.authen isEqualToString:@"0"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请设置默认路址并进行认证" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];

}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        RoadAddressManageViewController* vc = [[RoadAddressManageViewController alloc]init];
        vc.isAddressSel = addressSel_Auth;
        [self.navigationController pushViewController:vc animated:TRUE];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:TRUE];
    }
}

-(void)getVistorPic
{
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:[[LoginConfig Instance] userID],@"ownerId", nil];
    [self getArrayFromServer:VisitPass_Url path:DetailVisitPass_Path method:@"GET" parameters:dic xmlParentNode:@"crmVisitPass" success:^(NSMutableArray *result) {
        if (result.count == 0) {
            return ;
        }
        NSDictionary* dicResult = [result  objectAtIndex:0];
         NSURL *url = [NSURL URLWithString:[Common setCorrectURL:[dicResult objectForKey:@"codePath"]]];
        [_shareImg setImageWithURL:url placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]] ;
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}
- (void)postCommit
{
    NSDate* current = [NSDate date] ;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* maxDate = [[NSDate alloc]initWithTimeInterval:60*60*24*visitDays sinceDate:current];
    maxDateString = [dateFormatter stringFromDate:maxDate];
    NSString* tel = [[NSUserDefaults standardUserDefaults] objectForKey:User_UserAccount_Key];
    NSString *userId = [[LoginConfig Instance] userID];
    NSDictionary* dic =[[NSDictionary alloc]initWithObjectsAndKeys:self.roadData.projectId,@"projectId",
                        userId,@"ownerId",
                        self.roadData.buildingId,@"houseInfoId",
                        tel,@"telephone",name,@"visitor",
                        [NSString stringWithFormat:@"%ld",(long)visitCount],@"availNumber",
                        reason.reasonId,@"visitReason",
                       // destDateString,@"createDate",
                        maxDateString,@"availDate",
                        nil];
    
    // 请求服务器获取数据
    [self getStringFromServer:VisitPass_Url path:saveVisitPass_Path parameters:dic success:^(NSString *result) {
        
        if ([result isEqualToString:@"1"]) {
             [self displayVisit];
             [self getVistorPic];
        }
        else
        {
            [Common showNoticeAlertView:@"请设置默认路址并进行认证"];
        }
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

#pragma mark---other
-(void)displayVisit
{
    [_reasonLabel setText:[NSString stringWithFormat:@"拜访事由:%@",reason.reasonName]];
    [_validateLabel setText:[NSString stringWithFormat:@"有效期至:%@",maxDateString]];
    [_visitAddressLabel setText:@"拜访地址:"];
    [_visitAddressText setText:self.roadData.address];
    CGFloat height = [Common labelDemandHeightWithText:_visitAddressText.text font:_visitAddressText.font size:CGSizeMake(_visitAddressText.bounds.size.width, 2000)];
    [_visitBgView setFrame:CGRectMake(0, 0, _visitBgView.frame.size.width, height)];
    [_visitNameLabel setText:[NSString stringWithFormat:@"访客姓名:%@", name]];
    [_visitTelLabel setText:[NSString stringWithFormat:@"联系电话:%@", self.roadData.contactTel]];
    [_userNameLabel setText:[NSString stringWithFormat:@"用户姓名:%@", self.roadData.contactName]];
    [_visitCountLabel setText:[NSString stringWithFormat:@"可使用次数:%ld", (long)visitCount]];
    [_passTypeLabel setText:@"验证码:非小区住户生成"];
}

#pragma mark - 手势隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)popReasonSheet
{
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles: nil];
    sheet.tag = REASON_SHEET_TAG;
    for (int i=0; i<visitorReasonData.count; i++) {
       VisitReasonModel* data =  [visitorReasonData objectAtIndex:i];
        [sheet addButtonWithTitle:data.reasonName];
    }
    [sheet showInView:self.view];
    
}
-(void)popCountSheet
{
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles: @"1",@"2",@"3",@"4",@"5",nil];
    sheet.tag = COUNT_SHEET_TAG;
    [sheet showInView:self.view];
    
}
-(void)popDaysSheet
{
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles: @"1",@"2",@"3",nil];
    sheet.tag = DAYS_SHEET_TAG;
    [sheet showInView:self.view];
    
}
#pragma mark--UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == REASON_SHEET_TAG)
    {
        if(buttonIndex<=0 || buttonIndex> visitorReasonData.count)
            return;
        reason = [visitorReasonData objectAtIndex:buttonIndex-1];
        NSIndexPath *index = [NSIndexPath indexPathForRow:VisitPassRow_Reason inSection:0 ];
        VisitorPassportViewControllerTableViewCell* cell = (VisitorPassportViewControllerTableViewCell*)[_table cellForRowAtIndexPath:index];
        [cell setContextText:reason.reasonName];
    }
    else if(actionSheet.tag == COUNT_SHEET_TAG && buttonIndex < 5)
    {
        NSString* tmp = [NSString stringWithFormat:@"%ld",(long)(buttonIndex+1)];
        NSIndexPath *index = [NSIndexPath indexPathForRow:VisitPassRow_Count inSection:0 ];
        VisitorPassportViewControllerTableViewCell* cell = (VisitorPassportViewControllerTableViewCell*)[_table cellForRowAtIndexPath:index];
        [cell setContextText:tmp];
        visitCount = buttonIndex+1;
    }
    else if(actionSheet.tag == DAYS_SHEET_TAG)
    {
        NSString* tmp = [NSString stringWithFormat:@"%ld",(long)(buttonIndex+1)];
        NSIndexPath *index = [NSIndexPath indexPathForRow:VisitPassRow_Days inSection:0 ];
        VisitorPassportViewControllerTableViewCell* cell = (VisitorPassportViewControllerTableViewCell*)[_table cellForRowAtIndexPath:index];
        [cell setContextText:tmp];
        visitDays = buttonIndex+1;
    }
    else if(actionSheet.tag == SHARE_SHEET_TAG)
    {
        
    }
}
#pragma mark ---UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}
#pragma mark ---IBAction

-(IBAction)clickCommit:(id)sender
{
    VisitorPassportViewControllerTableViewCell* cell = (VisitorPassportViewControllerTableViewCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:VisitPassRow_VisitName inSection:0]];
    name = [cell getInputText];
 
    if([name isEqualToString:@""] || reason==nil || visitDays == 0 || visitCount == 0)
    {
        [Common showNoticeAlertView:@"请输入拜访者的姓名，并选择可用次数，有效天数和拜访事由"];
        return;
    }
    [self postCommit];
}
-(IBAction)clickShare:(id)sender
{
    if (imageShare ==nil) {
        return;
    }
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles: @"QQ好友",@"微信好友",@"短信",nil];
    sheet.tag = SHARE_SHEET_TAG;
    [sheet showInView:self.view];

}


#define CONTENT NSLocalizedString(@"亿街区分享", @"ShareSDK不仅集成简单、支持如QQ好友、微信、新浪微博、腾讯微博等所有社交平台，而且还有强大的统计分析管理后台，实时了解用户、信息流、回流率、传播效应等数据，详情见官网http://sharesdk.cn @ShareSDK")
#define SHARE_URL @"http://www.mob.com"
/**
 *	@brief	分享全部
 *
 *	@param 	sender 	事件对象
 */
- (IBAction)shareAllButtonClickHandler:(UIButton *)sender
{
    if(_shareImg.image == nil)
        return;
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:IMAGE_NAME ofType:IMAGE_EXT];
    
//    //构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content:CONTENT
//                                       defaultContent:@""
//                                                image:[ShareSDK imageWithPath:imagePath]
//                                                title:@"ShareSDK"
//                                                  url:@"http://www.mob.com"
//                                          description:NSLocalizedString(@"TEXT_TEST_MSG", @"这是一条测试信息")
//                                            mediaType:SSPublishContentMediaTypeNews];
    //加入分享的图片
    id<ISSCAttachment> shareImage = nil;
    SSPublishContentMediaType shareType = SSPublishContentMediaTypeText;
 
    shareImage = [ShareSDK pngImageWithImage:_shareImg.image];
    shareType = SSPublishContentMediaTypeImage;
     
 
    id<ISSContent> publishContent=[ShareSDK content:@"亿街区通行证分享" defaultContent:@"" image:shareImage title:@"亿街区通行证分享" url:@"http://www.sharesdk.cn/" description:nil mediaType:shareType];
    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
    
    NSArray *shareList = [ShareSDK customShareListWithType:
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          nil];

 
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                      thumbImage:INHERIT_VALUE
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
                                         content:INHERIT_VALUE
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                      thumbImage:INHERIT_VALUE
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];

//    // 定制QQ
//    [publishContent addQQUnitWithType:[NSNumber numberWithInt:SSPublishContentMediaTypeImage]
//                              content:INHERIT_VALUE
//                                title:INHERIT_VALUE
//                                  url:INHERIT_VALUE
//                                image:INHERIT_VALUE];
    
   // [publishContent addSMSUnitWithContent:INHERIT_VALUE subject:INHERIT_VALUE attachments:INHERIT_VALUE to:INHERIT_VALUE];

    //结束定制信息
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:[Common appDelegate]];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:NSLocalizedString(@"TEXT_SHARE_TITLE", @"内容分享")
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:YES
                                                        wxSessionButtonHidden:YES
                                                       wxTimelineButtonHidden:YES
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:[Common appDelegate]
                                                          friendsViewDelegate:[Common appDelegate]
                                                        picViewerViewDelegate:nil];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}


@end
