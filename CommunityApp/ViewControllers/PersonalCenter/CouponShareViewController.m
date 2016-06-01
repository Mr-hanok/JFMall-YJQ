//
//  CouponShareViewController.m
//  CommunityApp
//
//  Created by Andrew on 15/9/17.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "CouponShareViewController.h"
#import <Masonry/Masonry.h>
#import "GrouponTicket.h"
#import "GrouponShop.h"
#import "CouponShareAddressCell.h"
#import "CouponShareCouponCell.h"

@interface CouponShareViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) NSMutableArray *selectTickets;
@property (nonatomic, strong) NSMutableArray *selectAddress;

@end

@implementation CouponShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = @"优惠券分享";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.shareButton];
    [self.view setNeedsUpdateConstraints];
    [self getGrouponOrderAddress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.shareButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-8);
        make.left.equalTo(self.view.mas_left).with.offset(8);
        make.right.equalTo(self.view.mas_right).with.offset(-8);
        make.height.equalTo(@40);
    }];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.shareButton.mas_top).with.offset(-8);
    }];
}

- (void)getGrouponOrderAddress
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjects:@[self.order.goodsId] forKeys:@[@"goodsId"]];
    [self getArrayFromServer:GrouponShopList_Url path:GrouponShopList_Path method:@"GET" parameters:params xmlParentNode:@"shop" success:^(NSMutableArray *result) {
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in result) {
            GrouponShop *shopInfo = [[GrouponShop alloc] initWithDictionary:dic];
            [tmpArray addObject:shopInfo];
        }
        [self.addressArray removeAllObjects];
        [self.addressArray addObjectsFromArray:tmpArray];
        [self.tableView reloadData];
    }failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

- (void)shareButtonClicked:(UIButton *)sender
{
//    if (self.selectTickets.count == 0) {
//        [Common showBottomToast:@"请至少选择一个团购券号码"];
//        return;
//    }
//    if (self.selectAddress.count == 0) {
//        [Common showBottomToast:@"请至少选择一个商家地址"];
//        return;
//    }
//#pragma -mark 11-20 qq占时屏蔽
//    NSArray *shareList = [ShareSDK customShareListWithType:
//                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
//                          /*SHARE_TYPE_NUMBER(ShareTypeQQ),*/
//                          nil];
//    
//    SSPublishContentMediaType shareType = SSPublishContentMediaTypeText;
//
//    NSMutableArray *ticketNumbers = [[NSMutableArray alloc] init];
//    for (ticketModel *ticket in self.selectTickets) {
//        [ticketNumbers addObject:ticket.ticketNo];
//    }
//    NSMutableArray *addresses = [[NSMutableArray alloc] init];
//    for (GrouponShop *shop in self.selectAddress) {
//        NSString *addressInfoStr = [NSString stringWithFormat:@"%@ 地址:%@ 电话:%@", shop.shopName, shop.address, shop.shopTelNo];
//        [addresses addObject:addressInfoStr];
//    }
//    NSString *shareContent = [NSString stringWithFormat:@"分享给你亿街区的团购券：%@，支持的商家有：%@", [ticketNumbers componentsJoinedByString:@"，"], [addresses componentsJoinedByString:@"，"]];
//    id<ISSContent> publishContent=[ShareSDK content:shareContent defaultContent:@"优惠券分享" image:nil title:nil url:@"亿街区优惠券分享" description:nil mediaType:shareType];
//    
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//    [container setIPadContainerWithView:nil arrowDirect:UIPopoverArrowDirectionUp];
//    
//    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                         allowCallback:NO
//                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                          viewDelegate:nil
//                                               authManagerViewDelegate:[Common appDelegate]];
//    
//    //在授权页面中添加关注官方微博
//    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
//    
//    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:NSLocalizedString(@"TEXT_SHARE_TITLE", @"内容分享")
//                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
//                                                               qqButtonHidden:YES
//                                                        wxSessionButtonHidden:YES
//                                                       wxTimelineButtonHidden:YES
//                                                         showKeyboardOnAppear:NO
//                                                            shareViewDelegate:[Common appDelegate]
//                                                          friendsViewDelegate:[Common appDelegate]
//                                                        picViewerViewDelegate:nil];
//    
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:shareList
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:authOptions
//                      shareOptions:shareOptions
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//                                }
//                            }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IOS8) {
        if (indexPath.section == 0) {
            CouponShareCouponCell *cell = (CouponShareCouponCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 0.5f;
        }
        else {
            CouponShareAddressCell *cell = (CouponShareAddressCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 0.5f;
        }
    }
    else {
        if (indexPath.section == 0) {
            return 50.0f;
        }
        else {
            return 105.0f;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.selectTickets addObject:self.order.ticketsList[indexPath.row]];
    }
    else {
        [self.selectAddress addObject:self.addressArray[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.selectTickets removeObject:self.order.ticketsList[indexPath.row]];
    }
    else {
        [self.selectAddress removeObject:self.addressArray[indexPath.row]];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.order.ticketsList.count;
    }
    else {
        return self.addressArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CouponShareCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponShareCouponCell"];
        if (!cell) {
            cell = [[CouponShareCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CouponShareCouponCell"];
        }
        ticketModel *ticket = self.order.ticketsList[indexPath.row];
        cell.ticket = ticket;
        cell.ticketIndex = indexPath.row + 1;
        return cell;
    }
    else {
        CouponShareAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CouponShareAddressCell"];
        if (!cell) {
            cell = [[CouponShareAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CouponShareAddressCell"];
        }
        cell.shopInfo = self.addressArray[indexPath.row];
        return cell;
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.allowsMultipleSelection = YES;
    }
    return _tableView;
}

- (NSMutableArray *)addressArray
{
    if (!_addressArray) {
        _addressArray  = [[NSMutableArray alloc] init];
    }
    return _addressArray;
}

- (UIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"buttonbg"] forState:UIControlStateNormal];
        [_shareButton setTitle:@"分享给好友" forState:UIControlStateNormal];
        [_shareButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

- (NSMutableArray *)selectTickets
{
    if (!_selectTickets) {
        _selectTickets = [[NSMutableArray alloc] init];
    }
    return _selectTickets;
}

- (NSMutableArray *)selectAddress
{
    if (!_selectAddress) {
        _selectAddress = [[NSMutableArray alloc] init];
    }
    return _selectAddress;
}

@end
