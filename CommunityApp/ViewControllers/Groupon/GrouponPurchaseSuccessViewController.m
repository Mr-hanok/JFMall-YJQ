//
//  GrouponPurchaseSuccessViewController.m
//  CommunityApp
//
//  Created by issuser on 15/7/23.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GrouponPurchaseSuccessViewController.h"
#import "GrouponTicketTableViewCell.h"
#import "GrouponListViewController.h"

#define GrouponTicketTableViewCellNibName   @"GrouponTicketTableViewCell"
#import "MyCouponsViewController.h"


@interface GrouponPurchaseSuccessViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *couponTableView;
@property (strong, nonatomic) IBOutlet UIView *bottomButtonView;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *grouponTicketNoLabel;
@property (weak, nonatomic) IBOutlet UIButton *couponListButton;
@property (weak, nonatomic) IBOutlet UIButton *shoppingButton;
@end

@implementation GrouponPurchaseSuccessViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_Purchase_Success_Title;
    // 初始化view布局，控件样式。
    [self initViewStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.grouponTicket.ticketsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify  = @"GrouponTicketTableViewCell";
    GrouponTicketTableViewCell *cell = (GrouponTicketTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];

    [cell loadCellData:[self.grouponTicket.ticketsList objectAtIndex:indexPath.row] forRow:indexPath.row];

    return cell;
}

#pragma mark - 初始化控件样式
- (void)initViewStyle {
    // 注册couponViewCell
    UINib *nib = [UINib nibWithNibName:GrouponTicketTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.couponTableView registerNib:nib forCellReuseIdentifier:GrouponTicketTableViewCellNibName];
    
    // 设置table view的footer为：_bottomButtonView
    _couponTableView.tableFooterView = _bottomButtonView;
    
    // 设置两个button边框样式
    [self initUIButtonStyle:_couponListButton.layer];
    [self initUIButtonStyle:_shoppingButton.layer];
}

- (void)initUIButtonStyle:(CALayer *)layer {    
    layer.borderWidth = 1;
    layer.cornerRadius = 5;
    layer.masksToBounds = YES;
    layer.borderColor = Color_Button_Layer_Border.CGColor;
}

// 查看团购券
- (IBAction)goToMyGroupons:(id)sender {
    MyCouponsViewController *vc = [[MyCouponsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 继续购买
- (IBAction)goToContinueBuy:(id)sender {
    if (self.groupBuyListVC) {
        [self.navigationController popToViewController:self.groupBuyListVC animated:YES];
    }
}




@end
