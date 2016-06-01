//
//  VisitorAimViewController.m
//  CommunityApp
//
//  Created by 张艳清 on 15/10/13.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "VisitorAimViewController.h"
#import "NewVieitorViewController.h"
@interface VisitorAimViewController ()
{
    NSArray *_arr;
    
    UITableView *tbView;

}
@end



@implementation VisitorAimViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _arr=@[@"送货",@"装修",@"访友",@"维修",@"送餐"];
    //设置导航栏
        [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = @"来访目的";
    
    //创建表格视图
    tbView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //设置代理回调
    tbView.dataSource=self;
    tbView.delegate=self;
    //添加表格试图
    [self.view addSubview:tbView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str=@"strIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        
        //取消选中状态
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        
    }
    //设置主标题
    cell.textLabel.text=_arr[indexPath.row];
    str = cell.textLabel.text;
    return cell;
    
}

#pragma -Mark UITableViewDelegate
//设置指定行的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}

//行点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //让当前对象的代理方接受参数
    [self.delegate parameters:_arr[indexPath.row]];

    [self.navigationController popViewControllerAnimated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
