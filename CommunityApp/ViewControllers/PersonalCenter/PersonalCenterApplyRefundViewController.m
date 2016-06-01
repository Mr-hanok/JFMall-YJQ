//
//  PersonalCenterApplyRefundViewController.m
//  CommunityApp
//
//  Created by iss on 7/16/15.
//  Copyright (c) 2015 iss. All rights reserved.
//
#define SECTION_REFUND_TYPE 0
#define SECTION_REFUND_REASON SECTION_REFUND_TYPE+1
#define SECTION_TITLE_TAG 11
#define SECTION_HEAD_HEIGHT 20.0f
#import "PersonalCenterApplyRefundViewController.h"
#import "PersonalCenterApplyRefundTableViewCell.h"
#define cellNibName @"PersonalCenterApplyRefundTableViewCell"
#import "AfterSalesReason.h"
#import "MyCouponsRefundApplyViewController.h"
@interface PersonalCenterApplyRefundViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong,nonatomic) IBOutlet UIView* tableHead;
@property (strong,nonatomic) IBOutlet UIView* tableFooter;
@property (strong,nonatomic) IBOutlet UIView* couponsDisabelView;
@property (strong,nonatomic) IBOutlet UITableView* table;
@property (weak, nonatomic) IBOutlet UIView *headerSubView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerSubViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *refundMoneyLabel;

@property (strong,nonatomic) NSArray* refundTypeList;
@property (strong,nonatomic) NSMutableArray* refundReasonList;
@property (assign,nonatomic) NSInteger selSec1Row;
@property (assign,nonatomic) NSInteger selSec2Row;
@end

@implementation PersonalCenterApplyRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selSec1Row = -1;
    _selSec2Row = -1;
    // Do any additional setup after loading the view from its nib.
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Order_ApplyRefund_Title;
    [_tableHead setFrame:CGRectMake(0, 0, Screen_Width, 70+(_selectedTicketsArray.count * 30.0))];
//    [_couponsDisabelView setFrame:CGRectMake(0, 100, Screen_Width, 40)];
//    [_tableHead addSubview:_couponsDisabelView];
    NSInteger index = 0;
    for (ticketModel *model in _selectedTicketsArray) {
        UIView *ticketView = [[UIView alloc] initWithFrame:CGRectMake(0, 40+(30.0*index), Screen_Width, 30)];
        UILabel *ticketNo = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, Screen_Width-25-13, 30)];
        [ticketNo setText:[NSString stringWithFormat:@"团购券编号: %@", model.ticketNo]];
        [ticketNo setTextColor:COLOR_RGB(113, 113, 113)];
        [ticketNo setTextAlignment:NSTextAlignmentLeft];
        [ticketNo setFont:[UIFont systemFontOfSize:13.0]];
        [ticketView addSubview:ticketNo];
        [_headerSubView addSubview:ticketView];
        _headerSubViewHeight.constant += 30.0;
        index++;
    }
    
    _table.tableHeaderView = _tableHead;
    _table.tableFooterView = _tableFooter;
    
    [_refundMoneyLabel setText:_refundMoney];
    
    _refundTypeList = @[@[Order_ApplyRefund_TypeTitle,Order_ApplyRefund_TypeDesc]];
//    _refundReasonList = @[@[Order_ApplyRefund_Reason1],@[Order_ApplyRefund_Reason2],@[Order_ApplyRefund_Reason3],@[Order_ApplyRefund_Reason4],@[Order_ApplyRefund_Reason5],@[Order_ApplyRefund_Reason6],@[Order_ApplyRefund_Reason7]];
    _refundReasonList = [[NSMutableArray alloc]init];
    [_table registerNib:[UINib nibWithNibName:cellNibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellNibName];
    
    [self getRefundReasonDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
#pragma mark --- UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == SECTION_REFUND_TYPE)
    {
        return 1;
    }
    else if (section == SECTION_REFUND_REASON)
    {
        return _refundReasonList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 41.0;
    
    if(indexPath.section == SECTION_REFUND_TYPE)
    {
        height = 70.0;
    }
    else if (indexPath.section == SECTION_REFUND_REASON)
    {
        height = 41.0;
    }
    return height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalCenterApplyRefundTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellNibName];
    NSArray* data;
    if (indexPath.section == SECTION_REFUND_TYPE) {
        data = [_refundTypeList objectAtIndex:indexPath.row];
        [cell loadCellData:data andIsSelect:YES];
    }
    else if(indexPath.section == SECTION_REFUND_REASON)
    {
        AfterSalesReason* resason =  [_refundReasonList objectAtIndex:indexPath.row];
        data = [[NSArray alloc]initWithObjects:resason.afterSalesReasonName, nil];
        [cell loadCellData:data andIsSelect:NO];
    }
    
    if (indexPath.section == SECTION_REFUND_TYPE) {
//        if (_selSec1Row == indexPath.row) {
            [cell setSelected:TRUE];
//        }
//        else
//        {
//            [cell setSelected:FALSE];
//        }
    }
    else if(indexPath.section == SECTION_REFUND_REASON)
    {
        if (_selSec2Row == indexPath.row) {
            [cell setSelected:TRUE];
        }
        else
        {
            [cell setSelected:FALSE];
        }
    }
    
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString* identity = @"tableHeadIdentify";
    UITableViewHeaderFooterView* head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identity];
    if (head == nil) {
        head = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:identity];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, Screen_Width-25, SECTION_HEAD_HEIGHT)];
        [label setTag:SECTION_TITLE_TAG];
        
        [head addSubview:label];
        UIView* bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, SECTION_HEAD_HEIGHT)];
        [bg setBackgroundColor:[UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:243/255.0f]];
        [head setBackgroundView:bg];
        UIImageView* buttomLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, SECTION_HEAD_HEIGHT-1, Screen_Width, 1)];
        [buttomLine setBackgroundColor:[UIColor colorWithRed:212/255.0f green:212/255.0f blue:212/255.0f alpha:1]];
        [head addSubview:buttomLine];
    }
    UILabel* label = (UILabel*)[head viewWithTag:SECTION_TITLE_TAG];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label setTextColor:[UIColor colorWithRed:193.0/255 green:193.0/255 blue:193.0/255 alpha:1]];
    if (section == SECTION_REFUND_TYPE) {
        [label setText:Order_ApplyRefund_Type];
    }
    else if (section == SECTION_REFUND_REASON)
    {
        [label setText:Order_ApplyRefund_Reason];
    }
    [head setFrame:CGRectMake(0, 0, Screen_Width, SECTION_HEAD_HEIGHT)];
    return head;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectTableRedo:indexPath sel:TRUE];
    if(indexPath.section == SECTION_REFUND_TYPE)
    {
//        PersonalCenterApplyRefundTableViewCell* cell = (PersonalCenterApplyRefundTableViewCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selSec1Row inSection:SECTION_REFUND_TYPE]] ;
//        if (cell && _selSec1Row ==indexPath.row ) {
//            [cell setSelected:TRUE];
//        }
    }
    else if(indexPath.section == SECTION_REFUND_REASON)
    {
        PersonalCenterApplyRefundTableViewCell* cell = (PersonalCenterApplyRefundTableViewCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selSec2Row inSection:SECTION_REFUND_REASON]] ;
        if (cell && _selSec2Row==indexPath.row ) {
            [cell setSelected:TRUE];
        }
    }


}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectTableRedo:indexPath sel:TRUE];
    if(indexPath.section == SECTION_REFUND_TYPE)
    {
//        PersonalCenterApplyRefundTableViewCell* cell = (PersonalCenterApplyRefundTableViewCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selSec1Row inSection:SECTION_REFUND_TYPE]] ;
//        if (cell && _selSec1Row!=indexPath.row ) {
//            [cell setSelected:FALSE];
//        }
//        _selSec1Row = indexPath.row ;
    }
    else if(indexPath.section == SECTION_REFUND_REASON)
    {
        PersonalCenterApplyRefundTableViewCell* cell = (PersonalCenterApplyRefundTableViewCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selSec2Row inSection:SECTION_REFUND_REASON]] ;
        if (cell && _selSec2Row!=indexPath.row ) {
            [cell setSelected:FALSE];
        }
        _selSec2Row = indexPath.row ;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEAD_HEIGHT;
}


#pragma mark - 提交退款按钮点击事件处理函数
- (IBAction)submitRefundBtnClickHandler:(id)sender
{
    if(![self isGoToLogin])
    {
        return;
    }

    if (_selSec2Row < 0 || _selSec2Row > _refundReasonList.count) {
        [Common showBottomToast:@"请选择退款原因"];
        return;
    }
    
    AfterSalesReason* reason =  [_refundReasonList objectAtIndex:_selSec2Row];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    NSString *recordId = [[Common getUUIDString] lowercaseString];
    [dic setValue:@"2" forKey:@"afterSalesType"];
    [dic setValue:reason.afterSalesReasonName forKey:@"afterSalesReason"];
    [dic setValue:@"" forKey:@"expressCompany"];
    [dic setValue:@"" forKey:@"waybill"];
    [dic setValue:[[LoginConfig Instance] userID] forKey:@"userid"];
    [dic setValue:_grouponTicket.sellerId forKey:@"sellerId"];
//    [dic setValue:_grouponTicket.goodsId forKey:@"goodsId"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)_selectedTicketsArray.count] forKey:@"returnGoodsNum"];
    [dic setValue:recordId forKey:@"recordId"];
    [dic setValue:_grouponTicket.orderId forKey:@"orderId"];
    [dic setValue:@"" forKey:@"details"];
    [dic setValue:_refundMoney forKey:@"refundAmount"];
    
    NSInteger index = 0;
    NSString *ticketIds = @"";
    for (ticketModel *model in _selectedTicketsArray) {
        ticketIds = [ticketIds stringByAppendingString:model.ticketId];
        index++;
        if (index != _selectedTicketsArray.count) {
            ticketIds = [ticketIds stringByAppendingString:@","];
        }
    }
    [dic setValue:ticketIds forKey:@"allTicketsId"];
    
    [self getArrayFromServer:SaveTbgAfterSale_Url path:SaveTbgAfterSale_Path method:@"POST" parameters:dic xmlParentNode:@"list" success:^(NSMutableArray *result) {
        NSDictionary *dic = (NSDictionary *)[result firstObject];
        NSString *rstVal = [dic objectForKey:@"result"];
        if([rstVal isEqualToString:@"1"])
        {
            [Common showBottomToast:@"提交申请成功"];
            [self toApplyDetail];
        }
        else{
            [Common showBottomToast:@"提交申请失败"];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
    
    
}
-(void)toApplyDetail
{
    MyCouponsRefundApplyViewController* vc = [[MyCouponsRefundApplyViewController alloc]init];
    [vc setApplyOrderId:_grouponTicket.orderId goodsId:_grouponTicket.goodsId];
    [self.navigationController pushViewController:vc animated:TRUE];
}


#pragma  mark---UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
     PersonalCenterApplyRefundTableViewCell* cell = (PersonalCenterApplyRefundTableViewCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selSec2Row inSection:SECTION_REFUND_REASON]] ;
    if (cell) {
        [cell setSelected:FALSE];
    }
    _selSec2Row = -1;
    return TRUE;
}
#pragma mark---other
-(void)selectTableRedo:(NSIndexPath*)index sel:(BOOL)sel
{
    
}

#pragma mark---从服务器获取退款原因数据模型
-(void)getRefundReasonDataFromServer
{
    [self getArrayFromServer:GoodsModuleInfo_Url path:RefundReasonList_Path method:@"GET" parameters:nil xmlParentNode:@"afterSalesReason" success:^(NSMutableArray *result) {
        if(result.count != 0)
        {
            for (NSDictionary* dic in result) {
                [_refundReasonList addObject:[[AfterSalesReason alloc] initWithDictionary:dic]];
            }
            [_table reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}
@end
