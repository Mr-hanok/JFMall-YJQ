//
//  FleaMarketDetailViewController.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/7.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "FleaMarketDetailViewController.h"
#import "FleaCommodityModel.h"
#import "SDWebImageDownloader.h"
#import "AGImagePickerViewController.h"

@interface FleaMarketDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *hLine1;
@property (weak, nonatomic) IBOutlet UIImageView *hLine2;
@property (weak, nonatomic) IBOutlet UIImageView *hLine3;
@property (weak, nonatomic) IBOutlet UIImageView *hLine4;
@property (weak, nonatomic) IBOutlet UIImageView *hLine5;
@property (weak, nonatomic) IBOutlet UIImageView *hLine6;
@property (weak, nonatomic) IBOutlet UIImageView *hLine7;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *contact;

@property (weak, nonatomic) IBOutlet UIImageView *waresImgView;
@property (weak, nonatomic) IBOutlet UILabel *waresTitle;
@property (weak, nonatomic) IBOutlet UILabel *waresPrice;
@property (weak, nonatomic) IBOutlet UILabel *publishTime;
@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UILabel *surfaceLevel;
@property (weak, nonatomic) IBOutlet UILabel *catagory;

@property (weak, nonatomic) IBOutlet UILabel *waresDesc;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *WaresBtnHightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warePicHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *waresDescHight;
@property (strong,nonatomic) FleaCommodityDetailModel* wareDetail;
//@property(nonatomic,strong)UIWebView*webViewCall;//用来打电话
@end

@implementation FleaMarketDetailViewController
#define TABLEHEADHEIGHT 416
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = @"物品详情";
    [self setNavBarLeftItemAsBackArrow];
    
    [Common updateLayout:_hLine1 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine2 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine3 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine4 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine5 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine6 where:NSLayoutAttributeHeight constant:0.5];
    [Common updateLayout:_hLine7 where:NSLayoutAttributeHeight constant:0.5];
    
    // 计算物品描述需要的显示高度
    CGFloat height = [Common labelDemandHeightWithText:_waresDesc.text font:[UIFont systemFontOfSize:14.0] size:CGSizeMake(Screen_Width-16, LONG_MAX)];
    _waresDescHight.constant = height;
    
    if ((height+56) < (100-20)) {   // 56是描述的起始Y坐标 100是 描述部分最小高度  20是余白
        height = 100;
    }else{
        height = height + 56 + 20;
    }
    
    _headerView.frame = CGRectMake(0, 0, Screen_Width, TABLEHEADHEIGHT);
    _footerView.frame = CGRectMake(0, 0, Screen_Width, height);
    

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_tableView setHidden:TRUE];
    [self getWareDataFromServer];
}
#pragma mark - tableview datasource delegate
// 设置Cell数
-(NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
    //    return self.waresArray.count;
}

// 装载Cell元素
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


#pragma mark - 拨打电话按钮点击事件处理函数
- (IBAction)dialBtnClickHandler:(id)sender
{
    NSString *dialTel = [NSString stringWithFormat:@"tel://%@", _wareDetail.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialTel]];
    //打电话之后可以返回到源程序
//    if (_webViewCall==nil) {
//        _webViewCall=[[UIWebView alloc]initWithFrame:CGRectZero];
//    }
//    [_webViewCall loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dialTel]]];
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---从服务器下载物品详情信息
-(void)getWareDataFromServer
{
    if(_orderId == nil)
    {
        return;
    }
    NSDictionary* dic = [[NSDictionary alloc]initWithObjects:@[_orderId] forKeys:@[@"stId"]];
    [self getArrayFromServer:FleaMarket_Url path:FleaMarketDetail_Path method:@"GET" parameters:dic xmlParentNode:@"trading" success:^(NSMutableArray *result) {
        for(NSDictionary*  detail in result)
        {
            _wareDetail = [[FleaCommodityDetailModel alloc] initWithDictionary:detail];
        }
        if (_wareDetail != nil) {
            [self displayWareDetail];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}
#pragma mark---other
-(void)displayWareDetail
{

     CGFloat height = [Common labelDemandHeightWithText:_wareDetail.desc font:[UIFont systemFontOfSize:14.0] size:CGSizeMake(Screen_Width-16, CGFLOAT_MAX)];
    _waresDescHight.constant = height + 20;
    
    if (height < 21) {   // 56是描述的起始Y坐标 100是 描述部分最小高度  20是余白
        height = 56 + 21 + 20;
    }else{
        height += 56 + 20;
    }
    [_waresDesc setText:_wareDetail.desc];
    
    if (self.wareDetail.picture != nil && self.wareDetail.picture.length > 0) {
        NSArray* imgsArray = [self.wareDetail.picture componentsSeparatedByString:@","];
        if (imgsArray.count > 0) {
            NSString *imgUrl = [imgsArray objectAtIndex:0];
            NSRange rang = [imgUrl rangeOfString:FileManager_Address];
            NSURL *iconUrl ;
#pragma -mark 文件服务器地址 修改图片不显示（图片URL处理）
//            if(rang.length == 0)
//            {
//                iconUrl = [NSURL URLWithString:[Common setCorrectURL:imgUrl]];
//            }
//            else
//            {
                iconUrl = [NSURL URLWithString:imgUrl];
//            }
//            
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:iconUrl options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                UIImage *waresImg = [UIImage imageWithData:data];
                if (waresImg != nil) {
                    UIImage *scaledImg = [Common imageCompressForWidth:waresImg targetWidth:Screen_Width];
                    CGFloat targetHight = scaledImg.size.height;
                    [self.waresImgView setImage:scaledImg];
                    
                    self.warePicHeight.constant = targetHight;
                    self.WaresBtnHightConstraint.constant = targetHight;
                    [self updateViewConstraints];
                    [_headerView setFrame:CGRectMake(0, 0, Screen_Width, TABLEHEADHEIGHT+ targetHight-150)] ;
                    
                }else {
                    [self.waresImgView setImage:[UIImage imageNamed:@"WaresDetailDefaultImg"]];
                }
                _tableView.tableHeaderView = _headerView;
            }];
        }
    }

    _footerView.frame = CGRectMake(0, 0, Screen_Width, height);
    _tableView.tableFooterView = _footerView;
    [_waresTitle setText:_wareDetail.title];
    [_contact setText:[NSString stringWithFormat:@"%@  %@", _wareDetail.person, _wareDetail.phone]];
    [_waresPrice setText:[NSString stringWithFormat:@"￥%@",_wareDetail.price]];
    [_publishTime setText:_wareDetail.createTime];
    [_address setText:_wareDetail.positionName];
    [_surfaceLevel setText:_wareDetail.degree];
    [_catagory setText:_wareDetail.classifyName];
    _tableView.tableHeaderView = _headerView;
    _tableView.tableFooterView = _footerView;
    [_tableView setHidden:FALSE];
}

#pragma mark - 按钮点击事件处理函数
- (IBAction)waresImgBtnClickHandler:(id)sender
{
    //TODO
    NSArray* imgsArray =  [self.wareDetail.picture componentsSeparatedByString:@","];
    if(imgsArray == nil || imgsArray.count == 0)
    {
        return;
    }
    AGImagePickerViewController* vc = [[AGImagePickerViewController alloc]init];
    vc.imgUrlArray = imgsArray;
    [self.navigationController pushViewController:vc animated:TRUE];
    
}
@end
