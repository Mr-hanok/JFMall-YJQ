//
//  VisitorDetailViewController.m
//  CommunityApp
//
//  Created by 张艳清 on 15/10/13.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "VisitorDetailViewController.h"
//访客详情cell
#import "VisitorDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Interface.h"

//第三方平台的SDK头文件，根据需要的平台导入。
//以下分别对应微信
#import "WXApi.h"
#import "TapViewController.h"

//存放放大的二维码
#import "TapQRcodeViewController.h"
NSInteger taptimes=1;//二维码被点击的次数
@interface VisitorDetailViewController ()
{
    UITableView *tbView;
    NSArray * leftarray;
    NSArray *rightarray;

}

@end

@implementation VisitorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    leftarray = @[@"姓名",@"来访人数",@"来访目的",@"是否驾车",@"有效时间",@"访客二维码"];

    //设置导航栏
        [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = @"访客详情";
    
    //创建表格视图
    tbView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //设置代理回调
    tbView.dataSource=self;
    tbView.delegate=self;
    //添加表格试图
    [self.view addSubview:tbView];
    
    //向表格中注册xib
    UINib *nib=[UINib nibWithNibName:@"VisitorDetailTableViewCell" bundle:nil];
    [tbView registerNib:nib forCellReuseIdentifier:@"strIdentifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    
    //自定义cell
    VisitorDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"strIdentifier"];
 
    cell.leftlabel.text = leftarray[indexPath.row];
    //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//右边显示箭头
    //取消选中状态
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    if (indexPath.row == 0) {
        cell.rightlabel.text = self.model.visitorName;
    }
    else if (indexPath.row == 1)
    {
        cell.rightlabel.text = [NSString stringWithFormat:@"%d",self.model.total];
    }
    else if (indexPath.row == 2)
    {
        cell.rightlabel.text = self.model.target;
    }
    else if (indexPath.row == 3)
    {
        if (self.model.driveCar == 0) {
            cell.rightlabel.text = @"否";
        }
       else
           cell.rightlabel.text = @"是";
    }
    else if (indexPath.row == 4)
    {
        //设置有效时间🍎
        NSDate *  startdate=[NSDate dateWithTimeIntervalSince1970:self.model.startTime/1000];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *startTime=[dateformatter stringFromDate:startdate];

        UILabel *startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-200, 5, 190, 35)];
        startTimeLabel.textAlignment = NSTextAlignmentRight;
        startTimeLabel.font = [UIFont systemFontOfSize:13];
        [startTimeLabel  setTextColor:[UIColor orangeColor]];//设置字体颜色
        [cell.contentView addSubview:startTimeLabel];
        startTimeLabel.text = startTime;
        
        
        
        NSDate *  enddate=[NSDate dateWithTimeIntervalSince1970:self.model.endTime/1000];
        NSDateFormatter  *dateformatter2=[[NSDateFormatter alloc] init];
        [dateformatter2 setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *endTime=[dateformatter stringFromDate:enddate];
        
        UILabel *endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-200, 40, 190, 35)];
        endTimeLabel.textAlignment = NSTextAlignmentRight;
        endTimeLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:endTimeLabel];
        [endTimeLabel  setTextColor:[UIColor orangeColor]];//设置字体颜色
        endTimeLabel.text = [NSString stringWithFormat:@"至%@",endTime];
    }
    else
    {
        
         self.keyurlView = [[UIImageView alloc] init];
         self.keyurlView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-110,10, 100, 100);
         self.keyurlView.backgroundColor = [UIColor whiteColor];
         self.keyurlView.userInteractionEnabled=YES;
        [ self.keyurlView sd_setImageWithURL:[NSURL URLWithString:self.model.keyUrl]];
        //添加点击手势
        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
        [ self.keyurlView addGestureRecognizer:tap];
        [cell addSubview: self.keyurlView];
    }
    return cell;
}

#pragma mark-点击手势放大图片
- (void)magnifyImage
{
    //传uiimageview

//    TapQRcodeViewController*largeQRVC=[[TapQRcodeViewController alloc]init];
//    UIImageView*imgQR=[[UIImageView alloc]initWithImage:self.keyurlView.image];
////    UIImageView*imgQR=[[UIImageView alloc]init];
////    imgQR.backgroundColor = [UIColor redColor];
////    [imgQR sd_setImageWithURL:[NSURL URLWithString:self.model.keyUrl]];
//    imgQR.frame=CGRectMake(5,100,self.view.frame.size.width-10, self.view.frame.size.height/2);
//    largeQRVC.largeQRimage=imgQR;
//    YjqLog(@"largeQRimage%@",largeQRVC.largeQRimage.image);
//    [self.navigationController pushViewController:largeQRVC animated:YES];

    //传url
    TapQRcodeViewController * largeQRVC = [[TapQRcodeViewController alloc] init];
    largeQRVC.urlStr = self.model.keyUrl;
    [self.navigationController pushViewController:largeQRVC animated:YES];


}


#pragma -Mark UITableViewDelegate
//设置指定行的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==4) {
        return 80;
    }
    else if (indexPath.row == 5)
    {
        return 120;
    }
    else
    return 50;
}

//设置表尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ([UIScreen mainScreen].bounds.size.height-400);
}
//设置表尾
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    //UIView *grayView=[[UIView alloc]initWithFrame:CGRectMake(0, 50*6, 320, 160)];
    UIView *grayView=[[UIView alloc]init];
    grayView.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100,30, 200, 50)];
    [btn setTitle:@"发送给好友" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    btn.backgroundColor = [UIColor orangeColor];
    btn.layer.cornerRadius = 28.0;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:btn];
    
    return grayView;
}
#pragma mark-确认生成按钮
//发送给好友：微信好友 短信
- (void)btnClick:(UIButton *)btn
{
//        //微信分享功能🍎🍎🍎🍎🍎
//    
//                //除去code＝IOD00000的情况
////                if (![dict[@"code"] isEqualToString:@"IOD00000"])  {
////                    return;
////                }
//                NSArray *shareList = [ShareSDK customShareListWithType:
//                                      SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
//                                      SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
//                                      nil];
//        
////                NSString *url = [NSString stringWithFormat:@"%@%@",Service_Address,self.model.visitorName];
////                YjqLog(@"%@",url);
//    
//                id<ISSCAttachment>shareImage = nil;
//                SSPublishContentMediaType shareType = SSPublishContentMediaTypeText;
//        
//                shareType = SSPublishContentMediaTypeNews;
//        
//                id<ISSContent> publishContent=[ShareSDK content:@"欢迎来到远洋社区，使用二维码在门前扫描开门" defaultContent:@"二维码分享" image:nil title:@"亿街区" url:self.model.keyUrl description:nil mediaType:shareType];
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
//                
//        
//        
//       // [self.navigationController popViewControllerAnimated:YES];
//        
//    
//    
//    
//   // 让当前对象的代理方接受参数
//    
//    //[self.delegate parameters:<#(NSString *)#>]
//    
//     //   [self.navigationController popViewControllerAnimated:YES];
}




@end
