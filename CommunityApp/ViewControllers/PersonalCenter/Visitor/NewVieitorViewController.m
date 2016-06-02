//
//  NewVieitorViewController.m
//  CommunityApp
//
//  Created by 张艳清 on 15/10/13.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "NewVieitorViewController.h"
#import "VisitorDetailTableViewCell.h"//新访客cell
#import "VisitorAimViewController.h"
#import <AFNetworking.h>
#import "Interface.h"

#import "TimeViewController.h"
#import "PersonalCenterViewController.h"//获取项目ID：projectId
//二维码
//#import "QRCodeGenerator.h"
#import "UIImageView+WebCache.h"
#import "TapQRcodeViewController.h"
#import "MyVisitorViewController.h"
//定时提示
#import "Common.h"
#import "ShareHelper.h"
#import "IQKeyboardManager.h"

#define currentMonth [currentMonthString integerValue]
@interface NewVieitorViewController ()</*UIPickerViewDataSource,UIPickerViewDelegateui,UIActionSheetDelegate,*/UITextFieldDelegate,backTimer>
{
    BOOL _wasKeyboardManagerEnabled;//是否适用键盘
    UITableView *tbView;
    NSArray *leftarray;
    NSArray *rightarray;
    
    VisitorAimViewController *_aimVC;
    UILabel *_aimLabel;

    UITextField *_nameField;//visitorName
    UITextField *_numberField;//total

    UIButton *_endTimeBtn;//endTime
    UIButton *_startTimeBtn;
    UIDatePicker *datePicker;//时间控件

    BOOL share;
    NSString *_keyStr;//key
    NSString *_keyUrl;//二维码图片url
    
    NSString *projectIdStr ;//项目ID，现在未使用
    
    NSDictionary *  dict ;
    UISwitch *swithBtn;
    int numClick;
    
}
@property (nonatomic,copy)NSString *IsdriveCar;
@end

@implementation NewVieitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    share = NO;//设置初始值

     leftarray = @[@"姓名",@"来访人数",@"来访目的",@"是否驾车",@"有效时间"];
        //设置导航栏
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_NewVisitor_title;



    //创建表格视图
    //tbView=[[UITableView alloc]initWithFrame:CGRectMake(0, 22, self.view.frame.size.width, self.view.frame.size.height -49)];
    tbView=[[UITableView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    tbView.backgroundColor = [UIColor purpleColor];
    //设置代理回调
    tbView.dataSource=self;
    tbView.delegate=self;
    tbView.scrollEnabled = NO;
    //添加表格试图
    [self.view addSubview:tbView];
    TimeViewController *timeVC = [[TimeViewController alloc] init];
    timeVC.delegate=self;

#pragma mark-设置开始和结束的默认时间
 
    //获取当前系统时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *  currentTimeString=[dateformatter stringFromDate:senddate];
    
    NSDate *  nextsenddate=[NSDate dateWithTimeInterval:86400 sinceDate:senddate];
    NSDateFormatter  *nextdateformatter=[[NSDateFormatter alloc]init];
    [nextdateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString*nextDayString=[nextdateformatter stringFromDate:nextsenddate];
    
    //创建开始和结束按钮
     _startTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-200, 0, 180, 40)];
    [_startTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    _endTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-215, 40, 195, 40)];
     [_endTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

//设置默认时间
    self.startTimeStr=currentTimeString;
    self.endTimeStr=[NSString stringWithFormat:@"至%@",nextDayString];

    [_startTimeBtn setTintColor:[UIColor orangeColor]];
    [_endTimeBtn setTintColor:[UIColor orangeColor]];
    [_startTimeBtn setTitle:self.startTimeStr forState:UIControlStateNormal];
    [_endTimeBtn setTitle:self.endTimeStr forState:UIControlStateNormal];

}

//返回从新加载
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager]isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];


    UIViewController *uivc = (MyVisitorViewController *)[self.navigationController.viewControllers lastObject];
    if ([uivc isKindOfClass:[MyVisitorViewController class]]) {
        MyVisitorViewController *myvc  = (MyVisitorViewController *)uivc;
        [myvc visitorList];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager]setEnable:_wasKeyboardManagerEnabled];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return leftarray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str=@"strIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];

        //取消选中状态
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    //设置主标题
    cell.textLabel.text=leftarray[indexPath.row];
    if (indexPath.row == 0) {
        _nameField = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-120, 0, 100, 50)];
        _nameField.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:_nameField];
        _nameField.placeholder = @"请输入";
        //设置默认值为空
        _nameField.text = @"";
    }
    else if (indexPath.row == 1)
    {
        //显示右边箭头
        //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        _numberField = [[UITextField alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-120, 0, 100, 50)];
        //设置来访人数点击调用数字键盘
        _numberField.keyboardType = UIKeyboardTypeDecimalPad;
        _numberField.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:_numberField];
        _numberField.placeholder = @"请输入";
        //设置默认值为空
        _numberField.text = @"";
//        _numberField.delegate=self;

        
    }
    else if (indexPath.row == 2)
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        //代理传值
        _aimLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-130, 100, 100, 50)];
        _aimLabel.textAlignment = NSTextAlignmentRight;
        _aimLabel.textColor = [UIColor blackColor];
        [tableView addSubview:_aimLabel];
        //设置默认值为空
        _aimLabel.text = @"";
        
    }
    else if (indexPath.row == 3)
    {
        //添加开关
        swithBtn = [[UISwitch alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-70, 160, 70, 30)];
        [tableView addSubview:swithBtn];
       [swithBtn setOn:NO];
        self.IsdriveCar=@"否";//默认选择否
        [swithBtn addTarget:self action:@selector(switchBtn:) forControlEvents:UIControlEventValueChanged];

    }
    //有效时间
    else
    {
       cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
//        _startTimeBtn.tag = 1000;
        [_startTimeBtn addTarget:self action:@selector(TimeBtnClick1:) forControlEvents:UIControlEventTouchUpInside];
        //开始时间按钮添加到cell
        [cell.contentView addSubview:_startTimeBtn];

        
//        _endTimeBtn.tag = 2000;
        [_endTimeBtn addTarget:self action:@selector(TimeBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
        //结束时间添加到按钮
        [cell.contentView addSubview:_endTimeBtn];

    }
    return cell;
    
}
//是否驾车
-(void)switchBtn:(UISwitch *)swBt
{
    if (swBt.isOn) {
        _IsdriveCar = @"是";
        
    }else
    {
        _IsdriveCar = @"否";
    }
}

#pragma mark-设置开始时间和结束时间
//🍎设置开始时间和结束时间
- (void)TimeBtnClick1:(id)sender
{

    TimeViewController *timeVC = [[TimeViewController alloc] init];

    timeVC.selectTime = ^(NSString *str){
        [_startTimeBtn setTitle:str forState:UIControlStateNormal];
        //将值赋值给属性，从而传给服务器
        self.startTimeStr =_startTimeBtn.titleLabel.text;
    };

    [self.navigationController pushViewController:timeVC animated:YES];

}
- (void)TimeBtnClick2:(id)sender
{
    TimeViewController *timeVC = [[TimeViewController alloc] init];

    timeVC.selectTime = ^(NSString *str){
        NSString *strr = [NSString stringWithFormat:@"至%@",str];//给结束时间前加‘至’
        [_endTimeBtn setTitle:strr forState:UIControlStateNormal];
        self.endTimeStr =_endTimeBtn.titleLabel.text;
    };

    [self.navigationController pushViewController:timeVC animated:YES];
}
#pragma -Mark UITableViewDelegate
//设置指定行的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==4) {
        return 80;
    }
    else
    {
        return 50;
    }

}
//设置表尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ([UIScreen mainScreen].bounds.size.height-280);
}

//设置表尾
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //UIView *grayView=[[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-280, [UIScreen mainScreen].bounds.size.width,280)];
    UIView *grayView=[[UIView alloc]init];
    grayView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100,30, 200, 50)];
    [btn setTitle:@"确认生成并发送" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    btn.backgroundColor = [UIColor orangeColor];
    btn.layer.cornerRadius = 28.0;
    btn.tag = 100;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:btn];

    
    
    return grayView;
}
#pragma mark-确认生成按钮
//确认生成并发送
- (void)btnClick:(UIButton *)btn
{
//#pragma -mark 2015-11-24添加生成并发送的权限
//    if (_nameField.text.length == 0) {
//        //提示：请输入有效的姓名
//        [Common showBottomToast:@"请输入有效的姓名"];
//    }
//    if (_numberField.text == nil) {
//        //提示：请输入来访人数
//        [Common showBottomToast:@"请输入来访人数"];
//    }
//    if (_aimLabel.text == nil) {
//        //提示：请选择来访目的
//        [Common showBottomToast:@"请选择来访目的"];
//    }
//    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970];
//    long long int nowdate = (long long int)nowtime;
    
    [MobClick event:@"visitor_send"];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *startDayDate = [dateformatter dateFromString:self.startTimeStr];
    NSTimeInterval startTime=[startDayDate timeIntervalSince1970];
    long long int startDate = (long long int)startTime;
    
    NSString *endStr = [self.endTimeStr substringFromIndex:1];
    NSDate *endDayDate = [dateformatter dateFromString:endStr];
    NSTimeInterval endTime=[endDayDate timeIntervalSince1970];
    long long int endDate = (long long int)endTime;
    
    //获取当前系统时间
    NSDate *  senddate=[NSDate date];
    NSTimeInterval sendTime=[senddate timeIntervalSince1970];
    long long int sendDate = (long long int)sendTime;


    if(endDate<startDate || endDate <sendDate){
        [Common showBottomToast:@"所选时间无效，请重新选择～"];
        return;
    }
    //生成二维码
    if (!share) {
        //🍎AFNetWorking解析数据
        AFHTTPSessionManager  *_manager
        =[AFHTTPSessionManager manager];
        _manager.responseSerializer=[AFHTTPResponseSerializer serializer];

        NSString *userid = [[LoginConfig Instance]userID];//业主ID
        YjqLog(@"userid:%@",userid);
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        self.projectId = [userDefault objectForKey:KEY_PROJECTID];//获取项目ID
        YjqLog(@"projectid:%@",self.projectId);

        //上传设备信息
        UIDevice *device = [UIDevice currentDevice];
        // NSString *name = device.name;       //获取设备所有者的名称
        NSString *model = device.model;      //获取设备的类别
        NSString *type = device.localizedModel; //获取本地化版本
        // NSString *systemName = device.systemName;   //获取当前运行的系统
        NSString *systemVersion = device.systemVersion;//获取当前系统的版
        NSString *rst = [NSString stringWithFormat:@"%@#@#%@#@#%@",model,type,systemVersion];
        //因为有汉子要utf8编码
        NSString *rstt = [rst stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        //parameters:dic上传给服务器的参数
        NSString *tr = self.IsdriveCar;

    YjqLog(@"%@",tr);
#pragma mark-上传参数给服务器

    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:userid,@"ownerId",self.projectId,@"projectId",_nameField.text,@"visitorName",_numberField.text,@"total",_aimLabel.text,@"target",tr,@"driveCar",@"1",@"times",self.startTimeStr,@"startTime",self.endTimeStr,@"endTime",VersionNumber,@"version",rstt,@"rst", nil];
        YjqLog(@"dic:%@",dic);



        [_manager POST:VisitorURL parameters:dic success:^(NSURLSessionDataTask *operation, id responseObject) {

            //解析数据
            dict=[NSJSONSerialization JSONObjectWithData:responseObject  options:NSJSONReadingMutableContainers error:nil];
            YjqLog(@"dict:%@",dict);
            //声请成功
            if ([dict[@"code"] isEqualToString:@"IOD00000"]) {

                share = YES;

                NSDictionary *bodyDict = dict[@"body"];
                _keyStr = bodyDict[@"key"];
                YjqLog(@"keyStr:%@",_keyStr);
                _keyUrl = bodyDict[@"keyUrl"];
                YjqLog(@"keyUrl:%@",_keyUrl);

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邀请访客成功!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                [alert show];
                [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1.5];

#pragma mark-生成二维码  在确认按钮下边加二维码图片
                self.keyurlView = [[UIImageView alloc] init];
                self.keyurlView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-75,280+50+50, 150, 150);

                self.keyurlView.backgroundColor = [UIColor whiteColor];
                self.keyurlView.userInteractionEnabled=YES;
                [ self.keyurlView sd_setImageWithURL:[NSURL URLWithString:_keyUrl]];
                //添加点击手势
                UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
                [ self.keyurlView addGestureRecognizer:tap];
                [self.view addSubview: self.keyurlView];
            
            }
            else if ([dict[@"code"] isEqualToString:@"IOD0010"])
            {
                if ([dict[@"subCode"] isEqualToString:@"IOD0010.1"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"业主申请访客二维码已达最大次数!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:3.0];
                    [alert show];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"业主申请访客二维码失败!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:3.0];
                    [alert show];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"业主邀请访客失败!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                
                [alert show];
                [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:3.0];

            }
//            else if ([dict[@"subCode"] isEqualToString:@"IOD0010.1"])
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"业主申请访客二维码已达最大次数!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//                [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:3.0];
//
//                [alert show];
//            }
//            else
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"业主邀请访客失败!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//
//                [alert show];
//                [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:3.0];
//            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络无连接！" delegate:nil  cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:3.0];//3m后消失
            [alert show];

        }];


    }
    //发送给好友
    else
    {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]])
            {
                [MobClick event:@"visitor_wechat"];
                numClick = 1;
                [self clickSuggestBtn];
//                //除去code＝IOD00000的情况
//                //                if (![dict[@"code"] isEqualToString:@"IOD00000"])  {
//                //                    return;
//                //                }
//                UIImage *img=[UIImage imageNamed:@"saveLocation"];
//                id<ISSShareActionSheetItem>myItem=[ShareSDK shareActionSheetItemWithTitle:@"保存到本地" icon:img clickHandler:^{
//                    // 写到相册
//                    [MobClick event:@"visitor_save"];
//
//                    UIImageWriteToSavedPhotosAlbum(self.keyurlView.image, nil, nil, NULL);
//                    UIAlertView*aler=[[UIAlertView alloc]initWithTitle:nil message:@"已保存到本地相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [aler show];
////                    [Common showBottomToast:@"已保存到本地相册"];
//                }];
//                NSArray *shareList = [ShareSDK customShareListWithType:
//                                      SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
//                                      myItem,nil];
//                
//                NSString *url = [NSString stringWithFormat:@"%@%@",Service_Address,_nameField.text];
//                YjqLog(@"%@",url);
//                
////                id<ISSCAttachment> shareImage = nil;
//                SSPublishContentMediaType shareType = SSPublishContentMediaTypeText;
//                
//                shareType = SSPublishContentMediaTypeNews;
//                
//                id<ISSContent> publishContent=[ShareSDK content:@"欢迎来到远洋社区，使用二维码在门前扫描开门" defaultContent:@"二维码分享" image:nil title:@"" url:_keyUrl description:nil mediaType:shareType];
//                
//                //结束定制信息
//                
//                //创建弹出菜单容器
//                id<ISSContainer> container = [ShareSDK container];
//                [container setIPadContainerWithView:nil arrowDirect:UIPopoverArrowDirectionUp];
//                
//                id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                                     allowCallback:NO
//                                                                     authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                                      viewDelegate:nil
//                                                           authManagerViewDelegate:[Common appDelegate]];
//                
//                //在授权页面中添加关注官方微博
//                [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                                SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                                [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                                SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                                nil]];
//                
//                id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:NSLocalizedString(@"TEXT_SHARE_TITLE", @"内容分享")
//                                                                          oneKeyShareList:[NSArray defaultOneKeyShareList]
//                                                                           qqButtonHidden:YES
//                                                                    wxSessionButtonHidden:YES
//                                                                   wxTimelineButtonHidden:YES
//                                                                     showKeyboardOnAppear:NO
//                                                                        shareViewDelegate:[Common appDelegate]
//                                                                      friendsViewDelegate:[Common appDelegate]
//                                                                    picViewerViewDelegate:nil];
//                
//                //弹出分享菜单
//                [ShareSDK showShareActionSheet:container
//                                     shareList:shareList
//                                       content:publishContent
//                                 statusBarTips:YES
//                                   authOptions:authOptions
//                                  shareOptions:shareOptions
//                                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                            
//                                            if (state == SSResponseStateSuccess)
//                                            {
//                                                YjqLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
//                                            }
//                                            else if (state == SSResponseStateFail)
//                                            {
//                                                YjqLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//                                            }
//                                        }];
            }
           else
            {
//                UIAlertView*aler=[[UIAlertView alloc]initWithTitle:nil message:@"需要安装微信客户端" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [aler show];
                numClick = 2;
                [self clickSuggestBtn];
//                UIImage *img=[UIImage imageNamed:@"saveLocation"];
//                id<ISSShareActionSheetItem>myItem=[ShareSDK shareActionSheetItemWithTitle:@"保存到本地" icon:img clickHandler:^{
//                    // 写到相册
//                    UIImageWriteToSavedPhotosAlbum(self.keyurlView.image, nil, nil, NULL);
//                    UIAlertView*aler=[[UIAlertView alloc]initWithTitle:nil message:@"已保存到本地相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                    [aler show];
////                    [Common showBottomToast:@"已保存到本地相册"];
//                }];
//                NSArray *shareList = [ShareSDK customShareListWithType:
//                                      myItem,nil];
//              //创建弹出菜单容器
//                id<ISSContainer> container = [ShareSDK container];
//                [container setIPadContainerWithView:nil arrowDirect:UIPopoverArrowDirectionUp];
//                //弹出分享菜单
//                [ShareSDK showShareActionSheet:container shareList:shareList content:nil statusBarTips:YES authOptions:nil shareOptions:nil result:nil];
            }
    }
}
- (IBAction)clickSuggestBtn{
    NSString *wenjia;
    NSString *wenjian;
    if(numClick==1){
        wenjian = @"微信好友";
       wenjia = @"保存到本地";
    } else if(numClick==2){
        wenjian = @"保存到本地";
        wenjia = nil;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:wenjian, wenjia, nil];
    //
    if(numClick==1){
        actionSheet.tag = 255;
    } else if(numClick==2){
        actionSheet.tag = 256;
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}
#pragma mark--UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 255) {
        if (buttonIndex == 0) {
            //微信分享功能🍎🍎🍎🍎🍎
            [ShareHelper shareWithTitle:@"亿街区" text:@"欢迎来到远洋社区，使用二维码在门前扫描开门" imageUrl:_keyUrl resentedController:self];
        }else if (buttonIndex == 1) {
            UIImageWriteToSavedPhotosAlbum(self.keyurlView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        }
    }else if (actionSheet.tag == 256) {
        if (buttonIndex == 0) {
            UIImageWriteToSavedPhotosAlbum(self.keyurlView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"";
    if (!error) {
        [Common showBottomToast:@"已保存到本地相册"];
    }else
    {
        message = [error description];
    }
}
#pragma mark-点击手势放大图片
- (void)magnifyImage
{
    //传url
    TapQRcodeViewController * largeQRVC = [[TapQRcodeViewController alloc] init];
    largeQRVC.urlStr = _keyUrl;
    [self.navigationController pushViewController:largeQRVC animated:YES];


}


- (void) dimissAlert:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        //[alert release];
    }
}

//行点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {

    }
    else if (indexPath.row == 1)
    {
    }
    
    else if (indexPath.row == 2)
    {
        _aimVC = [[VisitorAimViewController alloc] init];
        _aimVC.title = @"来访目的";
        _aimVC.delegate = self;
        [self.navigationController pushViewController:_aimVC animated:YES];
        [[[UIApplication sharedApplication]keyWindow]endEditing:NO];
    }
    else if (indexPath.row == 3)
    {
        
    }
    else if (indexPath.row == 4)
    {
        TimeViewController *vc = [[TimeViewController alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
     }
}
#pragma mark-textField代理方法
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==_numberField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
}
-(void)parameters:(NSString *)str
{
    _aimLabel.text=str;
}


@end
