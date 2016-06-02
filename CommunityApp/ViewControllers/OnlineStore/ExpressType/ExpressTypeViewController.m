//
//  ExpressTypeViewController.m
//  CommunityApp
//
//  Created by issuser on 15/8/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ExpressTypeViewController.h"
#import "ExpressTypeTableViewCell.h"
#import "ExpressTypeModel.h"

#define ExpressTypeTableViewCellNibName @"ExpressTypeTableViewCell"

@interface ExpressTypeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ExpressTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_Select_Express_Type_Title;
    
    // 注册cell
    UINib *nibForExpressTypeService = [UINib nibWithNibName:ExpressTypeTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForExpressTypeService forCellReuseIdentifier:ExpressTypeTableViewCellNibName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.expressList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpressTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ExpressTypeTableViewCellNibName forIndexPath:indexPath];
    [cell loadCellData:[self.expressList objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectExpressTypeBlock) {
        ExpressTypeModel * model = [self.expressList objectAtIndex:indexPath.row];
        self.selectExpressTypeBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
