//
//  SearchAddressViewController.m
//  CommunityApp
//
//  Created by Andrew on 15/8/29.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "SearchAddressViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface SearchAddressViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *table;
    IBOutlet UIButton *searchButton;
    IBOutlet UITextField *buildNumberField;
    IBOutlet UITextField *unitNumberField;
    IBOutlet UITextField *floorNumberField;
    IBOutlet UITextField *roomNumberField;
    NSString *pageIndex;
    MJRefreshFooter *refreshFooter;
}

@property (nonatomic, strong) NSMutableArray *searchResultArray;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation SearchAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"地址认证";
    [self setNavBarLeftItemAsBackArrow];
    table.tableFooterView = [[UIView alloc] init];
    pageIndex = @"1";
    refreshFooter = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        pageIndex = [NSString stringWithFormat:@"%li", [pageIndex integerValue] + 1];
        [self searchButtonClicked:nil];
    }];
    table.footer = refreshFooter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideKeyboard
{
    [buildNumberField resignFirstResponder];
    [unitNumberField resignFirstResponder];
    [floorNumberField resignFirstResponder];
    [roomNumberField resignFirstResponder];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    [self.view addGestureRecognizer:self.tapGesture];
}

- (void)keyboardDidHide
{
    [self.view removeGestureRecognizer:self.tapGesture];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == buildNumberField) {
        [unitNumberField becomeFirstResponder];
    }
    if (textField == unitNumberField) {
        [floorNumberField becomeFirstResponder];
    }
    if (textField == floorNumberField) {
        [roomNumberField becomeFirstResponder];
    }
    if (textField == roomNumberField) {
        pageIndex = @"1";
        [self searchButtonClicked:nil];
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - ButtonClickedAction
- (IBAction)searchButtonClicked:(UIButton *)sender
{
    /*
     houseBuiding 楼栋
     houseCell 单元
     houseFloor楼层号
     houseRoom 房间号
     projectId 项目ID
     pageNum   页数
     perSize 每页大小
     
     */
    if (sender) {
        pageIndex = @"1";
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[Common vaildString:buildNumberField.text] forKey:@"houseBuiding"];
    [params setValue:[Common vaildString:unitNumberField.text] forKey:@"houseCell"];
    [params setValue:[Common vaildString:floorNumberField.text] forKey:@"houseFloor"];
    [params setValue:[Common vaildString:roomNumberField.text] forKey:@"houseRoom"];
    [params setValue:self.projectId forKey:@"projectId"];
    [params setValue:pageIndex forKey:@"pageNum"];
    [params setValue:@"10" forKey:@"perSize"];
    [self getArrayFromServer:ServiceInfo_Url path:SearchAddress method:@"POST" parameters:params xmlParentNode:@"houseInfo" success:^(NSMutableArray *result) {
        if (result.count > 0) {
            if ([pageIndex isEqualToString:@"1"]) {
                [self.searchResultArray removeAllObjects];
            }
            [self.searchResultArray addObjectsFromArray:result];
        }
        else {
            [Common showBottomToast:@"已加载全部数据"];
        }
        [refreshFooter endRefreshing];
        [table reloadData];
    } failure:^(NSError *error) {
        [refreshFooter endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didFinishSelectAddress) {
        self.didFinishSelectAddress(self.searchResultArray[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITabelViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifeir = @"SearchAddressTableViewCellReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifeir];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifeir];
    }
    NSDictionary *addressInfoDic = self.searchResultArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = addressInfoDic[@"address"];
    return cell;
}

#pragma mark - Get Method
- (NSMutableArray *)searchResultArray
{
    if (!_searchResultArray) {
        _searchResultArray = [[NSMutableArray alloc] init];
    }
    return _searchResultArray;
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    }
    return _tapGesture;
}

@end
