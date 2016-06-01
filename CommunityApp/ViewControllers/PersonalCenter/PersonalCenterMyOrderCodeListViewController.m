//
//  PersonalCenterMyOrderCodeListViewController.m
//  CommunityApp
//
//  Created by lipeng on 16/3/10.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "PersonalCenterMyOrderCodeListViewController.h"

@interface PersonalCenterMyOrderCodeListViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation PersonalCenterMyOrderCodeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看兑换码";
    
    [self setNavBarLeftItemAsBackArrow];
    
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    [self.tableView addGestureRecognizer:longPressGr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        if(indexPath == nil) return ;
        
        if (_goodsExchCodesArray.count > indexPath.row) {
            NSDictionary *dic = _goodsExchCodesArray[indexPath.row];
            [Common showBottomToast:@"兑换码已经复制到剪切板"];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = dic[@"code"];
        }
    }
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _goodsExchCodesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"codeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    
    NSDictionary *dic = _goodsExchCodesArray[indexPath.row];
    
    
    cell.textLabel.text = dic[@"code"];
    cell.detailTextLabel.text = dic[@"price"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

@end
