//
//  PersonalCenterAboutViewController.m
//  CommunityApp
//
//  Created by iss on 6/5/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterAboutViewController.h"
#import "PersonalCenterMeCell.h"
#import "PersonalCenterSuggestViewController.h"
typedef enum
{
    toUpdate = 0,
    toSuggest,
    toProtocol,
}aboutToType;
@interface PersonalCenterAboutViewController ()
{
    NSArray* array ;

}
@property(strong,nonatomic)IBOutlet UITableView*    table;
@property(strong,nonatomic)IBOutlet UIView*    tableHead;
@property(strong,nonatomic)IBOutlet UIImageView*    bgImg;
@property(strong,nonatomic)IBOutlet UIView*    tableFooter;
@property (nonatomic, strong) IBOutlet UILabel *versionLabel;
@property (nonatomic,strong) UIWebView *telwebView;
@end

@implementation PersonalCenterAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.



    //设置导航栏
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title=Str_About;
    // 获取 本机 软件版本
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"当前版本：V%@", currentVersion];
 
}
//懒加载
-(UIWebView *)telwebView
{
    if (_telwebView==nil) {
        _telwebView=[[UIWebView alloc]initWithFrame:CGRectZero];
    }
    return _telwebView;
}
-(void)viewDidAppear:(BOOL)animated
{
    CGFloat headHeight =  Screen_Width/5*2;
    [_tableHead setFrame:CGRectMake(0, 0, Screen_Width, headHeight)];
    _table.tableHeaderView = _tableHead;
    _table.tableFooterView = _tableFooter;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)setExtraCellLineHidden: (UITableView *)tableView

{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    
}

 #pragma mark-func
-(IBAction) toSuggest
{
    PersonalCenterSuggestViewController* next = [[PersonalCenterSuggestViewController alloc]init];
    [self.navigationController pushViewController:next animated:YES];
}

- (void)toUpdate {
    NSString *localAppVersion = @"";
    NSString *lastAppVersion = @"";
    
    // 获取 本机 软件版本
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    localAppVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    // 获取 appstore 软件版本
    lastAppVersion = [self getLastAppVersion];
    
    //
    if([localAppVersion isEqual:lastAppVersion])
    {
        [self versionUpAlert:YES];
    }
    else
    {
        [self versionUpAlert:NO];
    }
    

}
#pragma -mark 客服电话
- (IBAction)toTel:(id)sender {
    YjqLog(@"telephone");
    [self.telwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel://4006411058"]]];
}


- (NSString *)getLastAppVersion {
    NSString *lastAppVersion = @"";
    
    
    return lastAppVersion;
}

- (void)versionUpAlert:(BOOL)hasUpdate {
    if(hasUpdate)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"检查更新" message:@"发现新版本，是否升级？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"检查更新" message:@"当前已是最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
            
    }
}

#pragma mark - 与服务器对比版本号
- (void)checkAppVersionFromServer {
    
}

@end