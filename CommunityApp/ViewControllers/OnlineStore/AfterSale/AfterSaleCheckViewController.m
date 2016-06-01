//
//  AfterSaleCheckViewController.m
//  CommunityApp
//
//  Created by issuser on 15/7/16.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "AfterSaleCheckViewController.h"
#import "AfterSaleDetail.h"
#import "AfterSaleHistoryViewController.h"
#import "ExpressNoInsertViewController.h"
#import "PersonalCenterMsgBoardViewController.h"
#import "AfterSaleApplyViewController.h"
#import "GoodsForSaleViewController.h"
#import "AGImagePickerViewController.h"
#import "AfterSaleApplyModel.h"

#define CELLHEIGHT 45.0f

@interface AfterSaleCheckViewController ()
@property (weak, nonatomic) IBOutlet UIView *afterSaleSnapshotView;
@property (weak, nonatomic) IBOutlet UIView *afterSaleHistoryView;

@property (strong, nonatomic) AfterSaleDetail *afterSaleDetail;
@property (copy, nonatomic) NSString *orderId;
@property (copy, nonatomic) NSString *goodId;
@property (weak, nonatomic) IBOutlet UILabel *stateLebel;
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;

@property (weak, nonatomic) IBOutlet UILabel *shopLabel;
@property (weak, nonatomic) IBOutlet UILabel *historyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *historyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (strong,nonatomic) IBOutlet UITableView* table;
@property (strong,nonatomic) IBOutlet UIView* tableHead;
@property (strong,nonatomic) IBOutlet UIView* tableFooter1;
@property (strong,nonatomic) IBOutlet UIView* tableFooter2;
@property (strong,nonatomic) IBOutlet UIView* tableFooter3;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint* headViewHeight;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint* desViewHeight;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint* refundViewHeight;
@property (strong,nonatomic) IBOutlet UIView* refundCountView;


@property (strong,nonatomic) IBOutlet NSLayoutConstraint* refundAmountViewHeight;
@property (strong,nonatomic) IBOutlet UIView* refundAmountView;

@property (strong,nonatomic) IBOutlet NSLayoutConstraint* refunDescViewHeight;
@property (strong,nonatomic) IBOutlet UIView* refunDescView;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint* refundPicViewHeight;
@property (strong,nonatomic) IBOutlet UIView* refundPicView;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint* refundShopViewHeight;
@property (strong,nonatomic) IBOutlet UIView* refundShopView;

@property (strong,nonatomic) IBOutlet UIButton* modifyApplyBtn;
@property (strong,nonatomic) IBOutlet UIButton* toMessageBtn1;
@property (strong,nonatomic) IBOutlet UIButton* toMessageBtn2;
@property (strong,nonatomic) IBOutlet UIButton* toMessageBtn3;
@property (strong,nonatomic) IBOutlet UIButton* delApplyBtn;
@property (strong,nonatomic) IBOutlet UIButton* wayBtn;

@property (strong,nonatomic) IBOutlet UILabel* shopName;
@property (strong,nonatomic) IBOutlet UIImageView* shopRightArrow;
@end

@implementation AfterSaleCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化导航栏信息
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_AfterSale_ApplyInfo_Title;
    [self initWidgetStyle];
    [_refundCountView setHidden:TRUE];
    _refundViewHeight.constant  = 0.0f;
    _headViewHeight.constant -= CELLHEIGHT;
    _detailsLabel.numberOfLines = 0;
    _detailsLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    if([_goodId isEqualToString:@""]==false)//团购券
//    {
//        [_refunDescView setHidden:TRUE];
//        _refunDescViewHeight.constant  = 0.0f;
//        [_refundPicView setHidden:TRUE];
//        _refundPicViewHeight.constant  = 0.0f;
//        [_refundShopView setHidden:TRUE];
//        _refundShopViewHeight.constant  = 0.0f;
//        _headViewHeight.constant -= CELLHEIGHT*3;
//    }
    
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadViewData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化控件样式
- (void)initWidgetStyle {
    [self drawViewLayerBorder:_afterSaleSnapshotView];
    [self drawViewLayerBorder:_afterSaleHistoryView];
    [self drawButtonBorder:_modifyApplyBtn];
    [self drawButtonBorder:_toMessageBtn1];
    [self drawButtonBorder:_toMessageBtn2];
    [self drawButtonBorder:_delApplyBtn];
    [self drawButtonBorder:_wayBtn];
    [self drawButtonBorder:_toMessageBtn3];
    
}

- (void)drawButtonBorder:(UIButton *)button {
    CALayer *viewLayer = button.layer;
    viewLayer.borderWidth = 1;
    viewLayer.cornerRadius = 5;
    viewLayer.masksToBounds = YES;
    viewLayer.borderColor = COLOR_RGB(245, 114, 25).CGColor;
}

// 描画View边框
- (void)drawViewLayerBorder:(UIView *)view {
    CALayer *viewLayer = view.layer;
    viewLayer.borderWidth = 1;
    viewLayer.cornerRadius = 8;
    viewLayer.masksToBounds = YES;
    viewLayer.borderColor = [[UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1] CGColor];
}

// 终端下载售后详情接口
- (void)getTbgAfterSaleDetailOrderId:(NSString *)orderId andGoodsId:(NSString *)goodsId {
    if(self.orderId == nil)
    {
#if 0 //for test
        _table.tableHeaderView = _tableHead;
         _table.tableFooterView = _tableFooter1;
#endif
        return;
    }
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.orderId, self.goodId] forKeys:@[@"orderId", @"goodsId"]];
   // NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.orderId] forKeys:@[@"orderId"]];
    [self getArrayFromServer:TbgAfterSaleDetail_Url path:TbgAfterSaleDetail_Path method:@"GET" parameters:dic xmlParentNode:@"tbgAfterSale" success:^(NSMutableArray *result) {
        if(result.count !=0)
        {
            self.afterSaleDetail = [[AfterSaleDetail alloc] initWithDictionary:[result objectAtIndex:0]];
            [self freshPage];
        }
      
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

- (void)loadViewData {
    [self getTbgAfterSaleDetailOrderId:_orderId andGoodsId:_goodId];
}

- (void)setOrderId:(NSString *)orderId andGoodsId:(NSString *)goodId {
    self.orderId = orderId;
    self.goodId = goodId;
}

#pragma mark---IBAction
-(IBAction)toshop:(id)sender
{
    if (_afterSaleDetail.sellerShop==nil || [_afterSaleDetail.sellerShop isEqualToString:@""])
        return;
    GoodsForSaleViewController *vc = [[GoodsForSaleViewController alloc] init];
    vc.moduleType = self.moduleType;
    vc.sellerId = _afterSaleDetail.sellerShop;
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)toHistory:(id)sender
{
    AfterSaleHistoryViewController*vc =[[AfterSaleHistoryViewController alloc]init];
    vc.afterSalesId = _afterSaleDetail.afterSalesId;
    [self.navigationController pushViewController:vc animated:TRUE];
}

-(IBAction)toMessgae:(id)sender
{
    PersonalCenterMsgBoardViewController *vc = [[PersonalCenterMsgBoardViewController alloc]init];
    vc.afterSalesId = _afterSaleDetail.afterSalesId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)toModify:(id)sender
{
    AfterSaleApplyViewController* vc =[[AfterSaleApplyViewController alloc]init];
    vc.asModel = [[AfterSaleApplyModel alloc]init];
    vc.asModel.details = _afterSaleDetail.details;
    vc.asModel.refundAmount = _afterSaleDetail.refundAmount;
    vc.asModel.afterSaleReasonId = _afterSaleDetail.afterSaleReasonId;
    vc.asModel.afterSalesType = [_afterSaleDetail.afterSalesTypeId intValue];
    vc.asModel.returnGoodsNum = _afterSaleDetail.afterSaleNum;
    vc.asModel.afterSalesId = _afterSaleDetail.afterSalesId;
    [self.navigationController pushViewController:vc animated:TRUE];
}

-(IBAction)toDel:(id)sender
{
    [self getStringFromServer:CancelTbgAfterSaleState_Url path:CancelTbgAfterSaleState_Path method:@"POST" parameters:[[NSDictionary alloc]initWithObjects:@[_afterSaleDetail.afterSalesId] forKeys:@[@"afterSalesId"]] success:^(NSString *result) {
        if([result isEqualToString:@"1"])
        {
            [Common showBottomToast:@"撤销申请成功"];
            [self.navigationController popViewControllerAnimated:TRUE];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:@"撤销申请失败"];
    }];
}

-(IBAction)toWay:(id)sender
{
    ExpressNoInsertViewController* vc = [[ExpressNoInsertViewController alloc]init];
    [vc setExpressTicket:^(ExpressTypeModel *model) {
//        model.ExpressTypeNo;
//        model.ExpressTypeName;
    }];
    [self.navigationController pushViewController:vc animated:TRUE];
}

#pragma mark - 查看图片
- (IBAction)goToLookPic:(id)sender {
    NSLog(@"+++++++++++++%@",self.afterSaleDetail.attachments);
    NSArray* imgsArray =  [self.afterSaleDetail.attachments componentsSeparatedByString:@","];
    
    if(imgsArray == nil || imgsArray.count == 0)
    {
        return;
    }
    
    NSMutableArray *finalArray = [NSMutableArray array];
    for (NSString *pic in imgsArray) {
        if (pic.length > 0) {
            [finalArray addObject:pic];
        }
    }
    
    AGImagePickerViewController* vc = [[AGImagePickerViewController alloc]init];
    vc.imgUrlArray = finalArray;
    [self.navigationController pushViewController:vc animated:TRUE];
}



#pragma mark --- other
-(void)freshPage
{
    [_stateLebel setText:_afterSaleDetail.afterSalesStateName];
    [_typeNameLabel setText:_afterSaleDetail.afterSalesTypeName];
    [_reasonLabel setText:_afterSaleDetail.afterSaleReasonId];
    [_countLabel setText:_afterSaleDetail.afterSaleNum];
    [_historyTitleLabel setText:_afterSaleDetail.latestActionTitle];
    [_amountLabel setText:_afterSaleDetail.refundAmount];
    [_detailsLabel setText:_afterSaleDetail.details];
    
    CGFloat height = [Common labelDemandHeightWithText:_detailsLabel.text font:_detailsLabel.font size:CGSizeMake(_detailsLabel.bounds.size.width, 2000)];
    if([_afterSaleDetail.afterSalesId isEqualToString:@"1"])//只退货
    {
        if(_refundAmountView.hidden == false)
        {
            [_refundAmountView setHidden:TRUE];
            _refundAmountViewHeight.constant = 0.0f;
            _headViewHeight.constant -= CELLHEIGHT;
        }
    }
    if (height<CELLHEIGHT) {
        height = CELLHEIGHT;
    }
    if (height!=_desViewHeight.constant) {
        _headViewHeight.constant += height - _desViewHeight.constant;
        _tableHead.frame = CGRectMake(0, 0, Screen_Width, _headViewHeight.constant+60);
        _desViewHeight.constant = height;
    }
    _table.tableHeaderView = _tableHead;
    
    /*
    
    申请中：修改、撤销、留言
    
    已拒绝：修改、撤销、留言
    
    已通过：快递单号、留言
    
    已完成：无按钮
    
    已撤销：无按钮
     */
   // if([_goodId isEqualToString:@""]==TRUE)//非团购券退款申请
    {
        if ([_afterSaleDetail.afterSalesStateName isEqualToString:@"申请中"] || [_afterSaleDetail.afterSalesStateName isEqualToString:@"已拒绝"] )
        {
            _table.tableFooterView = _tableFooter1;
        }
        else if ([_afterSaleDetail.afterSalesStateName isEqualToString:@"已通过"])
        {
            if([_afterSaleDetail.afterSalesTypeId isEqualToString:@"2"])//只退款
                _table.tableFooterView = _tableFooter3;
            else
                _table.tableFooterView = _tableFooter2;
        }
    }
    if (_afterSaleDetail.sellerShop==nil || [_afterSaleDetail.sellerShop isEqualToString:@""])
    {
        [_shopName setText:@"自营商品"];
        [_shopRightArrow setHidden:TRUE];
    }
    
}
@end
