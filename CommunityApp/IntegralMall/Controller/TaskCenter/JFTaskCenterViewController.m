//
//  TaskCenterViewController.m
//  CommunityApp
//
//  Created by yuntai on 16/4/22.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFTaskCenterViewController.h"
#import "JFTaskCenterCell.h"
#import "APITaskCenterRequest.h"
#import "JFTasKCenterModel.h"

@interface JFTaskCenterViewController ()<UITableViewDataSource,UITableViewDelegate,APIRequestDelegate>
@property (weak, nonatomic) IBOutlet UIView *tableHeadView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UIView *rightNaviView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) APITaskCenterRequest *apiTask;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation JFTaskCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.rightNaviView.frame = CGRectMake(Screen_Width-110, 12, 90, 20);
    [self setNavBarItemRightView:self.rightNaviView];
    self.tableview.tableFooterView = [[UIView alloc]init];
    CGRect newFrame = self.tableHeadView.frame;
    newFrame.size.height = 165.f;
    self.tableHeadView.frame = newFrame;
    self.tableview.tableHeaderView = self.tableHeadView;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.array = [NSMutableArray array];
    [HUDManager showLoadingHUDView:kWindow];
    self.apiTask = [[APITaskCenterRequest alloc]initWithDelegate:self];
    [APIClient execute:self.apiTask];
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
    self.array = [JFTasKCenterModel jsonForModelArrayWithDic:sr.dic];
    [self.tableview reloadData];
    
}

- (void)serverApi_FinishedFailed:(APIRequest *)api result:(APIResult *)sr {
    
    NSString *message = sr.msg;
    [HUDManager hideHUDView];
    if (message.length == 0) message = kDefaultServerErrorString;
    [HUDManager showWarningWithText:message];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JFTaskCenterCell *cell = [JFTaskCenterCell tableView:self.tableview cellForRowInTableViewIndexPath:indexPath];
    [cell configCellDataWithModel:self.array[indexPath.row]];
    return cell;
    
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
#pragma mark - UITableViewDelegate
/**设置cell高度*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JFTasKCenterModel *model = self.array[indexPath.row];
    if ([model.isFinish isEqualToString:@"2"]) {
        [HUDManager showWarningWithText:@"任务已完成,不要再点了!"];
        return;
    }
    [self pushWithVCClassName:[model.className objectForKey:model.key] properties:@{@"":@""}];
}
#pragma mark - 重写导航栏右侧按钮点击事件处理函数

- (IBAction)rightNaviBtnclick:(UIButton *)sender {
    [self pushWithVCClassName:@"JFIntegralRuleViewController" properties:@{@"title":@"积分规则"}];
}
@end
