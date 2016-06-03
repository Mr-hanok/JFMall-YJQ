//
//  JFCommitOrderViewController.m
//  CommunityApp
//
//  Created by yuntai on 16/4/25.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFCommitOrderViewController.h"
#import "JFOrderFooterView.h"
#import "JFOrderHeadView.h"
#import "JFOrderInfoCell.h"
#import "JFAlterView.h"
#import "JFOrderFollowViewController.h"
#import "JFStoreInfoMode.h"
#import "JFGoodsInfoModel.h"
#import "RoadAddressManageViewController.h"
#import "RoadData.h"
#import <AFNetworking.h>
#import <DDXML.h>
#import <DDXMLElement.h>
#import "DDXMLElementAdditions.h"
#import "APIConfirmRequest.h"
#import "APIOrderSubmitRequest.h"
#import "JFIntegralOrderDetailViewController.h"

@interface JFCommitOrderViewController ()<UITableViewDelegate,UITableViewDataSource,APIRequestDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *tableHeader;
/**收货人*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**收货人电话*/
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
/**收货地址*/
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *adressBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *totalIntegralBtn;
@property (nonatomic, strong) APIConfirmRequest *apiConfirm;
@property (nonatomic, strong) APIOrderSubmitRequest *apiOrderSunmit;
@property (nonatomic, copy) NSString *cart_session;
@property (nonatomic, copy) NSString *total_price;
@property (nonatomic, strong) RoadData *roadData;
@property (nonatomic, assign) BOOL isAddressHave;
@end

@implementation JFCommitOrderViewController
#pragma mark - life cycle
- (instancetype)init{
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.tableview.backgroundColor = self.view.backgroundColor;
    CGRect newFrame = self.tableHeader.frame;
    newFrame.size.height = 80.f;
    self.tableHeader.frame = newFrame;
    self.tableview.tableHeaderView = self.tableHeader;
    //收货人信息
    self.nameLabel.text = @"请选择收货人";
    self.phoneLabel.text = @"";
    self.addressLabel.text = @"请选择收货人地址";
    
    if (self.isPrize) {//兑奖品-》提交订单
        [self.commitBtn setTitle:@"马上领取" forState:UIControlStateNormal];
    }else{//正常购物
        [self.commitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    }

    // SectionHeaderNib
    UINib *headerNib = [UINib nibWithNibName:@"JFOrderHeadView" bundle:[NSBundle mainBundle]];
    [self.tableview registerNib:headerNib forHeaderFooterViewReuseIdentifier:@"JFOrderHeadView"];
    
    // SectionFooterNib
    UINib *footerNib = [UINib nibWithNibName:@"JFOrderFooterView" bundle:[NSBundle mainBundle]];
    [self.tableview registerNib:footerNib forHeaderFooterViewReuseIdentifier:@"JFOrderFooterView"];
    
    //获取默认地址
    [self getDefaultUseRoad];
    //需要请求商品信息
    [HUDManager showLoadingHUDView:kWindow];
    self.apiConfirm = [[APIConfirmRequest alloc]initWithDelegate:self];
    [self.apiConfirm setApiParamsWithGoodIds:self.goodsId];
    [APIClient execute:self.apiConfirm];
}
-(void)viewDidLayoutSubviews
{
    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableview setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
#pragma mark -  APIRequestDelegate

- (void)serverApi_RequestFailed:(APIRequest *)api error:(NSError *)error {
    
    [HUDManager hideHUDView];
    [HUDManager showWarningWithText:kDefaultNetWorkErrorString];
}

- (void)serverApi_FinishedSuccessed:(APIRequest *)api result:(APIResult *)sr {
    
    [HUDManager hideHUDView];
    
    if (sr.dic == nil || [sr.dic isKindOfClass:[NSNull class]]) {
        return;
    }
    if (api == self.apiConfirm) {//查询要提交的商品信息
        [self.array removeAllObjects];
        NSArray *stores = [sr.dic objectForKey:@"carts"];
        for (NSDictionary *store in stores) {
            JFStoreInfoMode *storeModel = [JFStoreInfoMode initModelWithDic:store];
            if (storeModel.goodsArray.count>0) {
                [self.array addObject:storeModel];
            }
        }
        self.cart_session = [ValueUtils stringFromObject:[sr.dic objectForKey:@"cart_session"]];
        self.total_price = [ValueUtils stringFromObject:[sr.dic objectForKey:@"total_price"]];
        
        NSString *title = [NSString stringWithFormat:@"总计:%@积分",self.total_price];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:title];
        [str1 addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xEA7E36) range:NSMakeRange(3, title.length-5)];
        [self.totalIntegralBtn setAttributedTitle:str1 forState:UIControlStateNormal];
        
        [self.tableview reloadData];
    }
    if (api == self.apiOrderSunmit) {//提交订单 确定按钮
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交订单成功!前往订单页面查看!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pushWithVCClassName:@"JFIntegralOrderViewController" properties:@{@"title":@"积分订单"}];
        }];
        [alter addAction:cancle];
        [alter addAction:sure];
        [self presentViewController:alter animated:YES completion:nil];
        
    }
}

- (void)serverApi_FinishedFailed:(APIRequest *)api result:(APIResult *)sr {
    
    NSString *message = sr.msg;
    [HUDManager hideHUDView];
    if (message.length == 0) {
        message = kDefaultServerErrorString;
    }
    [HUDManager showWarningWithText:message];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JFStoreInfoMode *store = self.array[section];
    return store.goodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JFOrderInfoCell *cell = [JFOrderInfoCell tableView:self.tableview cellForRowInTableViewIndexPath:indexPath];
    JFStoreInfoMode *store = self.array[indexPath.section];
    [cell configCellWithGoodsInfoModel:store.goodsArray[indexPath.row]];
    return cell;
    
}

#pragma mark - UITableViewDelegate

/**
 *  设置cell高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
// Section Header高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34.f;
}

// Section Footer高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 34.f;
}

// Section Header View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JFStoreInfoMode *store = self.array[section];
    JFOrderHeadView *header = (JFOrderHeadView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JFOrderHeadView"];
    [header configSectionHeadViewWithStoreName:store.storeName];
    return header;
}

// Section Footer View
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{   JFStoreInfoMode *store = self.array[section];
    JFOrderFooterView *footer = (JFOrderFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JFOrderFooterView"];
    [footer configSectionFooterViewWithStoreModel:store];
    return footer;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - event response
/**
 * 提交订单按钮
 */
- (IBAction)commitBtnClick:(UIButton *)sender {
    
        if (!self.isAddressHave) {
            [HUDManager showWarningWithText:@"请选择收货地址!"];
            return;
        }
        NSString *name =self.nameLabel.text;
        NSString *address =self.addressLabel.text ;
        NSString *phone = self.phoneLabel.text;
        
//        if (self.isPrize) {//兑奖品-》提交订单
//            
//            
//           // return;
//        }
        
        JFAlterView *alterview = [[[NSBundle mainBundle]loadNibNamed:@"JFAlterView" owner:nil options:0] firstObject];
        [alterview configAlterViewWithmessage:[NSString stringWithFormat:@"您的订单总计扣减%@积分",self.total_price] title:@"支付确认提醒"];
        alterview.frame =[UIApplication sharedApplication].keyWindow.frame;
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:alterview];
        
        __weak typeof(alterview) weakAlter = alterview;
        alterview.btnClickCallBack = ^(NSInteger tag){
            switch (tag) {
                case 101://取消
                    [weakAlter removeFromSuperview];
                    break;
                    
                case 102://确定
                    self.apiOrderSunmit = [[APIOrderSubmitRequest alloc]initWithDelegate:self];
                    [self.apiOrderSunmit setApiParamsWithGoodIds:self.goodsId
                                                    cart_session:self.cart_session
                                                            name:name
                                                          mobile:phone
                                                         address:address];
                    [APIClient execute:self.apiOrderSunmit];
                    [weakAlter removeFromSuperview];
                    break;
            }
        };

}
/**
 *收货地址按钮
 */
- (IBAction)addressBtnClick:(UIButton *)sender {
    RoadAddressManageViewController *vc = [[RoadAddressManageViewController alloc] init];
    vc.isAddressSel = addressSel_Default;
    [vc setSelectRoadData:^(RoadData *roadData) {
        self.isAddressHave = YES;
        self.addressLabel.text = roadData.address;
        self.phoneLabel.text = roadData.contactTel;
        self.nameLabel.text = roadData.contactName;
    }];
    
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark - private methods
// 取得默认路址
- (void)getDefaultUseRoad {
    
    NSString *userId = [[LoginConfig Instance] userID];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: userId,@"userId",nil];
    
    [self getArrayFromServer:ServiceInfo_Url path:DefaultRoadAddress_path method:@"GET" parameters:dic xmlParentNode:@"buildingLocation" success:^(NSMutableArray *result){
        // 先查看是否有默认地址
        for (NSDictionary *dicResult in result)
        {
            if (dicResult.count > 0) {
                self.roadData = [[RoadData alloc] initWithDictionary:dicResult];
            }
        }
        
        if (self.roadData == nil) {
            // 如果没有默认的地址就查看上次有没有填写过地址
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary *lastAddress = [userDefaults dictionaryForKey:[NSString stringWithFormat:@"lastAddress%@", userId]];
            if (lastAddress != nil) {
                self.roadData = [[RoadData alloc] initWithDictionary:lastAddress];
            }
        }
        
        if (self.roadData.address == nil) {
            self.isAddressHave = NO;
        }
        else {
            self.isAddressHave = YES;
            self.addressLabel.text = _roadData.address;
            self.phoneLabel.text = _roadData.contactTel;
            self.nameLabel.text = _roadData.contactName;
        }
        
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


-(void)getArrayFromServer:(NSString *)url path:(NSString *)path method:(NSString *)method parameters:(NSDictionary *)parameters xmlParentNode:(NSString *)parentNode
                  success:(void (^)(NSMutableArray *result))success failure:(void (^)(NSError *error))failure
{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:Service_URL(url)]];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"application/xml", @"text/json", @"text/javascript",@"text/html", @"text/xml", @"text/plain", nil]];
    
    [manager.requestSerializer setTimeoutInterval:20];
    
    if ([method isEqual:@"GET"])
    {
        [manager GET:path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * operation, id responseObject) {
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (success) {
                success([self getArrayFromXML:str byParentNode:parentNode]);
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
        
    }
    else
    {
        
        [manager POST:path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (success) {
                success([self getArrayFromXML:str byParentNode:parentNode]);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
        
    }
}
-(NSMutableArray *)getArrayFromXML:(NSString *)xmlString byParentNode:(NSString *)parentNode
{
    //    NSLog(@"%@",xmlString);
    
    DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
    NSArray *nodes = [xmlDoc nodesForXPath:[NSString stringWithFormat:@"//%@",parentNode] error:nil];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    for (DDXMLElement *user in nodes)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < user.children.count; i++)
        {
            NSString *key = [[user.children objectAtIndex:i] name];
            NSString *value = [[user elementForName:key] stringValue];
            [dic setValue:value forKey:key];
        }
        
        [resultArray addObject:dic];
    }
    
    return resultArray;
}


@end
