//
//  SelectNeighborhoodViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/9.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "SelectNeighborhoodViewController.h"
#import "MainViewController.h"
#import "BarCodeScanViewController.h"
#import "Interface.h"
#import "LoginConfig.h"
#import "UserAgent.h"
//定位
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#pragma mark - 宏定义区
#define NeighBoorHoodViewCellTableViewCellNibName       @"NeighBoorHoodViewCellTableViewCell"


@interface SelectNeighborhoodViewController ()<UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate,CLLocationManagerDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *searchBorderView;
@property (retain, nonatomic) IBOutlet UITextField *searchTextField;

// 小区数据数组
@property (retain, nonatomic) NSMutableArray    *neighborhoodData;
@property (retain ,nonatomic) UserAgent *userAgent;
@property(nonatomic,retain)CLLocationManager *locationManager;
@end

@implementation SelectNeighborhoodViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self locationStart];//开始定位
    
    // 初始化导航栏信息
    self.navigationItem.title = @"选择小区";
    
    if (!self.isRootVC) {
        [self setNavBarLeftItemAsBackArrow];
    }



    //[self setNavBarItemRightViewForNorImg:@"BarCodeScanIconNor" andPreImg:@"BarCodeScanIconNor"];
    
    [self initBasicDataInfo];
    self.searchBorderView.layer.borderColor = COLOR_RGB(200, 200, 200).CGColor;
    self.searchBorderView.layer.borderWidth = 1.0;
    self.searchBorderView.layer.cornerRadius = 4.0;
    
    // 添加手势隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrentResponse)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}
#pragma -mark 开始定位
-(void)locationStart{
    //判断定位操作是否被允许

    if([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init] ;
        self.locationManager.delegate = self;
        //设置定位精度
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;//每隔多少米定位一次（这里的设置为每隔百米)
        if (IOS8) {
            //使用应用程序期间允许访问位置数据
            [self.locationManager requestWhenInUseAuthorization];
        }
        // 开始定位
        [self.locationManager startUpdatingLocation];
    }else {
        //提示用户无法进行定位操作
   //    NSLog(@"%@",@"定位服务当前可能尚未打开，请设置打开！");

    }
}
#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [self.locationManager stopUpdatingLocation];
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];

    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count >0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //经纬度
             CLLocationDegrees latitude = placemark.location.coordinate.latitude;
             CLLocationDegrees longitude = placemark.location.coordinate.longitude;
             NSLog(@"didUpdateUserLocation lat %f,long %f",latitude,longitude);//经纬度didUpdateUserLocation lat 39.921963,long 116.497621 didUpdateUserLocation lat 39.915826,long 116.490991
             //获取城市
             NSString *currCity = placemark.locality;
             if (!currCity) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 currCity = placemark.administrativeArea;
             }
//             if (self.localCityData.count <= 0) {
//                 GYZCity *city = [[GYZCity alloc] init];
//                 city.cityName = currCity;
//                 city.shortName = currCity;
//                 [self.localCityData addObject:city];
//
//                 [self.tableView reloadData];
//             }

         } else if (error ==nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }else if (error !=nil)
         {
             NSLog(@"An error occurred = %@", error);
         }

     }];

}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error.code ==kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }

}


#pragma mark - tableview datasource delegate
// 设置Cell数
-(NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    return self.neighborhoodData.count;
}

// 装载Cell元素
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NeighBoorHoodViewCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NeighBoorHoodViewCellTableViewCellNibName forIndexPath:indexPath];
  
    [cell loadCellData:[self.neighborhoodData objectAtIndex:indexPath.row]];
    
    return cell;
}
//设置每行cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark - tableview delegate
//选择小区
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取选中的值，并将选中的值传回给新增路址
    NeighBorHoodModel *model = [_neighborhoodData objectAtIndex:indexPath.row];
    if (self.selectNeighborhoodBlock) {
        self.selectNeighborhoodBlock(model);
    }
    if (_isSaveData) {
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:model.projectId forKey:KEY_PROJECTID];
        [userDefault setObject:model.projectName forKey:KEY_PROJECTNAME];
        [userDefault setObject:model.qrCode forKey:KEY_qrCode];//🍎

        [userDefault synchronize];
        
        [self syncProjectInfoToServer:model.projectId];
    }

    if([self.delegate respondsToSelector:@selector(setSelectedNeighborhoodId:andName:andqrCode:)])//🍎
    {
    #pragma mark-代理
        [self.delegate setSelectedNeighborhoodId:model.projectId andName:model.projectName andqrCode:model.qrCode];//🍎
    }
    if (!self.isRootVC) {
        // 设置选择的小区ID，传回主页
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        MainViewController *vc = [[MainViewController alloc] init];
        [Common appDelegate].window.rootViewController = vc;
    }
#pragma -mark ios 修改web view的ua（已选择小区）
    [UserAgent UserAgentMenthd];
}


#pragma mark - 按钮点击事件处理函数
// 搜索按钮事件
- (IBAction)searchBtnClickHandler:(id)sender
{
    [self getDataFromServer];
}

#pragma mark--textfield delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self getDataFromServer];
    return TRUE;
}


#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    self.neighborhoodData = [[NSMutableArray alloc] init];
    
    //请求服务器获取小区数据
    [self getDataFromServer];
    
    // 注册TableViewCell Nib
    UINib *nib = [UINib nibWithNibName:NeighBoorHoodViewCellTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:NeighBoorHoodViewCellTableViewCellNibName];
}


// 从服务器端获取数据
- (void)getDataFromServer
{
//    // 初始化参数
//    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[@"", @"1",@"116",@"39",@"北京市"] forKeys:@[@"projectName", @"usePtSetting",@"userLon",@"userLat",@"userCityName"]];//self.searchTextField.text
//    
//    // 请求服务器获取数据
//    [self getOrignStringFromServer:SelectNeighBoorHood_Url path:SelectNeighBoorHood_Path method:@"GET" parameters:dic success:^(NSString *result) {
//        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithXMLString:result options:0 error:nil];
//        NSArray *nodes = [xmlDoc nodesForXPath:[NSString stringWithFormat:@"//%@",@"groupByCityName"] error:nil];
//
//        for (DDXMLElement *user in nodes)
//        {
//            NSArray *cityNameArr = [user elementsForName:@"cityName"];
//            NSArray *sameCityNameProjects = [user elementsForName:@"sameCityNameProjects"];
//            if (cityNameArr.count > 0) {//10
//                DDXMLElement *cityNameE = cityNameArr[0];
//                NSString *cityName = [cityNameE stringValue];
//            }
//
//            if (sameCityNameProjects.count > 0) {//
//                DDXMLElement *sameCityNameProjectsE = sameCityNameProjects[0];
//                NSString *projectsString = [sameCityNameProjectsE XMLString];//xml 序列化
//                NSArray *projects = [self getArrayFromXML:projectsString byParentNode:@"sameCityNameProject"];
//                for (NSDictionary * projectDic in projects) {
//                    NSString *projectId = [projectDic objectForKey:@"projectId"];
//                    NSString *projectName = [projectDic objectForKey:@"projectName"];
//                    YjqLog(@"1:%@ 2%@",projectId,projectName);
//                }
//            }
//
//        }
//
//    } failure:^(NSError *error) {
//
//    }];

    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.searchTextField.text, @"1"] forKeys:@[@"projectName", @"usePtSetting"]];

    // 请求服务器获取数据
    [self getArrayFromServer:SelectNeighBoorHood_Url path:SelectNeighBoorHood_Path method:@"GET" parameters:dic xmlParentNode:@"project" success:^(NSMutableArray *result) {
        [self.neighborhoodData removeAllObjects];
        for (NSDictionary *dic in result) {
            [self.neighborhoodData addObject:[[NeighBorHoodModel alloc] initWithDictionary:dic]];
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


#pragma mark - 手势隐藏键盘
-(void)resignCurrentResponse
{
    [_searchTextField resignFirstResponder];
}

#pragma mark - 重写导航栏右侧按钮点击事件处理函数
//- (void)navBarRightItemClick
//{
//    BarCodeScanViewController *vc = [[BarCodeScanViewController alloc] init];
//    [vc setScanCode:^(NSString *code) {
//        NSLog(@"code:%@",code);//@"http://weixin.qq.com/q/rUwoUVPmuaDAf1OzAGQu"
//        NeighBorHoodModel *model;
//        for (NeighBorHoodModel *neighborHood in self.neighborhoodData) {
//            NSLog(@"1111%@",neighborHood.qrCode);
//            if ([code rangeOfString:neighborHood.qrCode].location != NSNotFound) {
//                model = neighborHood;
//                NSLog(@"%@",neighborHood);
//            }
//        }
//        if (model) {
//            if (self.selectNeighborhoodBlock) {
//                self.selectNeighborhoodBlock(model);
//            }
//            if (_isSaveData) {
//                NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
//                [userDefault setObject:model.projectId forKey:KEY_PROJECTID];
//                [userDefault setObject:model.projectName forKey:KEY_PROJECTNAME];
//                [userDefault synchronize];
//
//                [self syncProjectInfoToServer:model.projectId];
//            }
//
//            if([self.delegate respondsToSelector:@selector(setSelectedNeighborhoodId:andName:andqrCode:)])//🍎
//            {
//                [self.delegate setSelectedNeighborhoodId:model.projectId andName:model.projectName andqrCode:model.qrCode];//🍎
//            }
//            if (!self.isRootVC) {
//                // 设置选择的小区ID，传回主页
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//            else {
//                MainViewController *vc = [[MainViewController alloc] init];
//                [Common appDelegate].window.rootViewController = vc;
//            }
//
//        }
//        else {
//            [Common showBottomToast:@"未知项目信息"];
//        }
//    }];
//    [self.navigationController pushViewController:vc animated:YES];
//}


//if ([code isEqualToString:sss]) {
//#pragma mark - 重写导航栏右侧按钮点击事件处理函数
//- (void)navBarRightItemClick
//{
//    BarCodeScanViewController *vc = [[BarCodeScanViewController alloc] init];
//    [vc setScanCode:^(NSString *code) {
//        NSArray *projectInfo = [code componentsSeparatedByString:@"@"];
//       //🍎
//        for (NeighBorHoodModel *model in self.neighborhoodData) {
//            if ([code rangeOfString:model.qrCode].location != NSNotFound) {
//                if (projectInfo.count == 3 && ([[projectInfo objectAtIndex:2] isEqualToString:@"07"])) {
//                    // 获取选中的值，并将选中的值传回给新增路址
//                    NeighBorHoodModel *model = [[NeighBorHoodModel alloc] init];
//                    model.projectId = [projectInfo objectAtIndex:0];
//                    model.projectName = [projectInfo objectAtIndex:1];
//                    model.qrCode = [projectInfo objectAtIndex:2];//
//                    if (self.selectNeighborhoodBlock) {
//                        self.selectNeighborhoodBlock(model);
//                    }
//                    if (_isSaveData) {
//                        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
//                        [userDefault setObject:model.projectId forKey:KEY_PROJECTID];
//                        [userDefault setObject:model.projectName forKey:KEY_PROJECTNAME];
//                        [userDefault setObject:model.qrCode forKey:KEY_qrCode];
//                        [userDefault synchronize];
//                        [self syncProjectInfoToServer:model.projectId];
//                        NSLog(@"Qrcode:%@",model.qrCode);
//                    }
//                    if([self.delegate respondsToSelector:@selector(setSelectedNeighborhoodId:andName:)])//
//                    {
//                        [self.delegate setSelectedNeighborhoodId:model.projectId andName:model.projectName];
//                    }
//                    if (!self.isRootVC) {
//                        // 设置选择的小区ID，传回主页
//                        [self.navigationController popViewControllerAnimated:YES];
//                    }
//                    else {
//                        MainViewController *vc = [[MainViewController alloc] init];
//                        [Common appDelegate].window.rootViewController = vc;
//                    }
//                }
//            }
//        }
//
//        //}
//    }];
//    [self.navigationController pushViewController:vc animated:YES];
//}


#pragma mark - 同步小区信息到服务器
- (void)syncProjectInfoToServer:(NSString *)projectId
{
    if (![[LoginConfig Instance] userLogged]) {
        return;
    }
    
    NSString *userId = [[LoginConfig Instance] userID];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[projectId, userId] forKeys:@[@"projectId", @"userId"]];
    
    [self getArrayFromServer:SyncProject_Url path:SyncProject_Path method:@"GET" parameters:dic xmlParentNode:@"serviceType" success:^(NSMutableArray *result) {
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
