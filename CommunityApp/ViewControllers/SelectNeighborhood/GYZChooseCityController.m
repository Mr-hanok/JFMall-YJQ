//
//  GYZChooseCityController.m
//  GYZChooseCityDemo
//  选择城市列表
//  Created by wito on 15/12/29.
//  Copyright © 2015年 gouyz. All rights reserved.
//

#import "GYZChooseCityController.h"
//传值
#import "MainViewController.h"
#import "BarCodeScanViewController.h"
#import "Interface.h"
#import "LoginConfig.h"
#import "UserAgent.h"
//布局
#import "GYZCityGroupCell.h"
#import "GYZCityHeaderView.h"

//改进建议
#import "PersonalCenterSuggestViewController.h"
#import "Common.h"


@interface GYZChooseCityController ()<GYZCityGroupCellDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{

    NSString *selectProjectId;//选择项目
    NSString *nearlyProjectId;//最近项目

    UITableView *tbView;
    NSString *lon; 
    NSString *lat;
    NSString *loc;
    //搜索不到小区时的cell中内容
    UILabel *cityLab;
    UILabel *submit;
    NSMutableDictionary *cityDic;
    NSString *isLocation;//后台定位是否打开

}


//首字母数组
@property (nonatomic, strong) NSMutableArray *citySection;
//无冗余首字母数据
@property (nonatomic, strong) NSMutableArray *noChSection;

/**
 *  记录所有城市信息，用于搜索
 */
@property (nonatomic, strong) NSMutableArray *recordCityData;
/**
 *  定位城市
 */
@property (nonatomic, strong) NSMutableArray *commonCityData;
//存右边字母的数组
@property (nonatomic, strong) NSMutableArray *arraySection;
/**
 *  是否是search状态
 */
@property(nonatomic, assign) BOOL isSearch;
/**
 *  搜索框
 */
@property (nonatomic, strong) UISearchBar *searchBar;
/**
 *  搜索城市列表
 */
@property (nonatomic, strong) NSMutableArray *searchCities;
@end

NSString *const cityHeaderView = @"CityHeaderView";
NSString *const cityGroupCell = @"CityGroupCell";
NSString *const cityCell = @"CityCell";

@implementation GYZChooseCityController

-(void)viewDidLoad{
    [super viewDidLoad];

    lon = @"";
    lat = @"";
    loc = @"";


    _cityDatas = [NSMutableArray array];
    _recordCityData = [NSMutableArray array];
    _arraySection = [NSMutableArray array];
    _citySection = [NSMutableArray array];
    _commonCityData = [NSMutableArray array];
    _noChSection = [NSMutableArray array];

    selectProjectId = @"0";
    nearlyProjectId = @"0";
    [self.navigationItem setTitle:@"选择项目"];
    if (!self.isRootVC) {
        [self setNavBarLeftItemAsBackArrow];
    }

    cityDic = [[NSMutableDictionary alloc] init];
    cityLab=[[UILabel alloc] initWithFrame:CGRectMake(Screen_Width/30, 0, Screen_Width-Screen_Width/20, 44)];
    submit=[[UILabel alloc] initWithFrame:CGRectMake(Screen_Width*0.8, 0, Screen_Width/5, 44)];

    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonDown:)];
    [self.navigationItem setLeftBarButtonItem:cancelBarButton];
    self.isSearch = NO;


    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
//    self.searchBar.barStyle     = UIBarStyleDefault;
    self.searchBar.translucent  = YES;
    self.searchBar.delegate     = self;
    self.searchBar.placeholder  = @"请输入项目中文名称";
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    [self.searchBar setBarTintColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
    [self.searchBar.layer setBorderWidth:0.5f];
    [self.searchBar.layer setBorderColor:[UIColor colorWithWhite:0.7 alpha:1.0].CGColor];




    //创建表格视图
    tbView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    //设置代理回调
    tbView.dataSource=self;
    tbView.delegate=self;
    //添加表格试图
    [self.view addSubview:tbView];

    [self getLocationData];//获取小区列表数据

    [tbView setTableHeaderView:self.searchBar];
    [tbView setSectionHeaderHeight:40];
    [tbView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [tbView setSectionIndexColor:[UIColor redColor]];
    [tbView registerClass:[UITableViewCell class] forCellReuseIdentifier:cityCell];
    [tbView registerClass:[GYZCityGroupCell class] forCellReuseIdentifier:cityGroupCell];
    [tbView registerClass:[GYZCityHeaderView class] forHeaderFooterViewReuseIdentifier:cityHeaderView];


//    // 添加手势隐藏键盘
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrentResponse)];
//    tap.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:tap];

}

//刷新按钮
- (void)refreshBtn
{
    YjqLog(@"刷新");
#pragma -mark 12-23 网络连接判断
//    BOOL netWorking = [Common checkNetworkStatus];
//    if (netWorking) {
#pragma -mark 调用等待加载。。。
        self.HUD.hidden = NO;
        if (!self.hudHidden)
        {
            [self.HUD show:YES];
            [self.view bringSubviewToFront:self.HUD];
        }
        [self getLocationData];//加载数据
//    }
//    else
//    {
//        [Common showBottomToast:Str_Comm_RequestTimeout];
//        return;
//    }


}

#pragma mark - 从服务器端获取数据
// 上传数据
- (void)getDataFromService
{
    NSString *userid = [[LoginConfig Instance]userID];//业主ID
    //上传设备信息
    UIDevice *device = [UIDevice currentDevice];
    NSString *model = device.model;      //获取设备的类别
    NSString *type = device.localizedModel; //获取本地化版本
    NSString *systemVersion = device.systemVersion;//获取当前系统的版
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSString *rst = [NSString stringWithFormat:@"%@#@#%@#@#%@#@#%@",model,type,systemVersion,identifierForVendor];
    //因为有汉字要utf8编码
    NSString *rstt = [rst stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *writedict=[[NSDictionary alloc]initWithObjectsAndKeys:rstt,@"rst",selectProjectId,@"selectProjectId",nearlyProjectId,@"nearlyProjectId",lon,@"userLon",lat,@"userLat",userid,@"ownerinfoId",@"1",@"type",nil];
    YjqLog(@"上传结果%@",writedict);
    // 请求服务器获取数据
    [self getArrayFromServer:LocationNeighBoorHood_Url path:LocationNeighBoorHood_Path method:@"POST" parameters:writedict xmlParentNode:@"list" success:^(NSMutableArray *result) {
        YjqLog(@"**%@",result);//返回结果（0:失败，1:成功）
        for (NSDictionary *dic in result) {
            NSString *resultStr = [dic objectForKey:@"result"];
            if ([resultStr isEqual:@"1"]) {
//                [Common showBottomToast:@"上传成功"];
            }
            else
            {
//                [Common showBottomToast:@"上传失败"];
            }
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];

    }];

}

#pragma -mark 定位请求数据
- (void)getLocationData
{

    if (!lon || [lon isEqualToString:@""]) {
        lon = @"";
    }
    if (!lat || [lat isEqualToString:@""]) {
        lon = @"";
    }
    if (!loc || [loc isEqualToString:@""]) {
        loc = @"";
    }
    //取出
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    loc = [userDefaults objectForKey:@"locationCity"];
    lon = [userDefaults objectForKey:@"lon"];
    lat = [userDefaults objectForKey:@"lat"];


//    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[@"", @"1",lon,lat,loc] forKeys:@[@"projectName", @"usePtSetting",@"userLon",@"userLat",@"userCityName"]];//
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"projectName",@"1",@"usePtSetting",lon,@"userLon",lat,@"userLat",loc,@"userCityName", nil];

    [_commonCityData removeAllObjects];
    //     请求服务器获取数据
    [self getOrignStringFromServer:SelectNeighBoorHood_Url path:SelectNeighBoorHood_Path method:@"GET" parameters:dic success:^(NSString *result) {

        [_cityDatas removeAllObjects];
        [_recordCityData removeAllObjects];
        [_arraySection removeAllObjects];
        [_citySection removeAllObjects];
        [cityDic removeAllObjects];
        [_commonCityData removeAllObjects];
        [_noChSection removeAllObjects];


        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithXMLString:result options:0 error:nil];
        //1.数据列表
        NSArray *groupNodes = [xmlDoc nodesForXPath:[NSString stringWithFormat:@"//%@",@"groupByCityName"] error:nil];
        for (DDXMLElement *user in groupNodes)
        {
            NSArray *cityNameArr = [user elementsForName:@"cityName"];
            NSArray *sameCityNameProjects = [user elementsForName:@"sameCityNameProjects"];
            GYZCityGroup *group = [[GYZCityGroup alloc] init];
            NSString *cityNameStr;
            NSString *pinYinShou;
            if (cityNameArr.count > 0) {//10
                DDXMLElement *cityNameE = cityNameArr[0];
                cityNameStr = [cityNameE stringValue];
                //转拼音
                //转成了可变字符串
                NSMutableString *str = [NSMutableString stringWithString:cityNameStr];
                //先转换为带声调的拼音
                CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
                //再转换为不带声调的拼音
                CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
                //转化为带空格的大写拼音
                NSMutableString *pinYin = (NSMutableString*)[str capitalizedString];
                //    //转化为不带空格的大写拼音
                //    [pinYin deleteCharactersInRange:[pinYin rangeOfString:@" "]];
                //获取并返回首字母
                pinYinShou = [pinYin substringToIndex:1];
                group.cityName = cityNameStr;
                group.firstName = pinYinShou;
            }

            if (sameCityNameProjects.count > 0) {//
                DDXMLElement *sameCityNameProjectsE = sameCityNameProjects[0];
                NSString *projectsString = [sameCityNameProjectsE XMLString];//xml 序列化
                NSArray *projects = [self getArrayFromXML:projectsString byParentNode:@"sameCityNameProject"];

                for (NSDictionary * projectDic in projects) {
                    
                    GYZCity *city = [[GYZCity alloc] init];
                    city.projectId = [projectDic objectForKey:@"projectId"];
                    city.projectName = [projectDic objectForKey:@"projectName"];
                    city.initials = pinYinShou;
                    city.shortName = @"shortName";
                    city.pinyin = @"pinyin";

                    [group.arrayCitys addObject:city];
                    [self.recordCityData addObject:city];

                }
                [self.arraySection addObject:group.firstName];//group.groupName
                [self.citySection addObject:group.cityName];
                [_cityDatas addObject:group];
            }

        }

        if(self.arraySection.count>0){
            NSArray *arraySort = [self.arraySection sortedArrayUsingSelector:@selector(compare:)];
            for(int i=0;i<arraySort.count;++i){
                if(![cityDic objectForKey:[arraySort objectAtIndex:i]]){
                    NSMutableArray *chengTable = [[NSMutableArray alloc]init];
                    [self.noChSection addObject:[arraySort objectAtIndex:i]];
                    [chengTable addObject:[NSString stringWithFormat:@"%d",i]];
                    [cityDic setObject:chengTable forKey:[arraySort objectAtIndex:i]];
                }else{
                    NSMutableArray *chengTableTwo =[cityDic objectForKey:[arraySort objectAtIndex:i]];
                    [chengTableTwo addObject:[NSString stringWithFormat:@"%d",i]];
                }
            }
        }

        //2.后台是否打开定位功能
        NSArray *isLocationArr = [xmlDoc nodesForXPath:[NSString stringWithFormat:@"//%@",@"isLocation"] error:nil];
        DDXMLElement *isLocationEle = isLocationArr[0];
        isLocation = [isLocationEle stringValue];
//        isLocation = @"N";
        if ([isLocation isEqual:@"Y"]) {
            //3.定位最近3个小区
            NSArray *disNodes = [xmlDoc nodesForXPath:[NSString stringWithFormat:@"//%@",@"projectBeansByDistance"] error:nil];
            for (DDXMLElement *disUser in disNodes)
            {
                NSArray *distanceArr = [disUser elementsForName:@"distance"];
                NSArray *projectIdArr = [disUser elementsForName:@"projectId"];
                NSArray *projectNameArr = [disUser elementsForName:@"projectName"];
                //            NSArray *qrCodeArr = [disUser elementsForName:@"qrCode"];
                GYZCityGroup *group1 = [[GYZCityGroup alloc] init];
                GYZCity *city = [[GYZCity alloc] init];
                if (distanceArr.count > 0) {
                    for (int i = 0; i < distanceArr.count; i++) {
                        DDXMLElement *nameE = projectNameArr[i];
                        DDXMLElement *idE = projectIdArr[i];
                        DDXMLElement *disE = distanceArr[i];
                        //                DDXMLElement *qrE = qrCodeArr[0];

                        city.projectName = [nameE stringValue];
                        city.projectId = [idE stringValue];
                        city.distance = [disE stringValue];
                        //                city.qrCode = [qrE stringValue];
                        [group1.arrayCitys addObject:city];
                        [self.commonCityData addObject:city];//

                        if ( [nearlyProjectId  isEqual: @"0"]){
                            nearlyProjectId= city.projectId;//最近城市ID
                        }
                    }
                }
            }

        }
        else
        {
//            [Common showBottomToast:@"后台定位服务未开启"];
        }

     [tbView reloadData];//刷新表格

    } failure:^(NSError *error) {
        [_commonCityData removeAllObjects];
        [_cityDatas removeAllObjects];
        [_recordCityData removeAllObjects];
        [_arraySection removeAllObjects];
        [_citySection removeAllObjects];
        [cityDic removeAllObjects];
        [_noChSection removeAllObjects];
        [tbView reloadData];
        [Common showBottomToast:@"请开启网络设置"];
    }];
}


#pragma mark - Getter
- (NSMutableArray *) searchCities
{
    if (_searchCities == nil) {
        _searchCities = [[NSMutableArray alloc] init];
    }
    return _searchCities;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {


    //搜索出来只显示一块
    if (self.isSearch) {
        return 1;
    }
    return self.cityDatas.count+1;
}
// 设置Cell数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearch) {
        if(self.searchCities.count==0){
            return 1;
        }else{
            return self.searchCities.count;
        }
    }

    if (section < 1) {
        //判断后台定位是否开启 开启第一块显示，不开隐藏
        if ([isLocation isEqual:@"N"]) {
            return 0;
        }
        else
        return 1;
    }
    GYZCityGroup *group = [self.cityDatas objectAtIndex:section - 1];
    return group.arrayCitys.count;
}
// 装载Cell元素
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cityLab.text = @"";
    submit.text = @"";
    if (self.isSearch) {

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCell];
        if(self.searchCities.count==0){
            [cell.textLabel setText:@""];
            cityLab.text=@"请提供所在项目信息，我们立即联系物业为您开通";
            cityLab.textAlignment = NSTextAlignmentLeft;
            [cityLab setNumberOfLines:0];
            cityLab.font = [UIFont systemFontOfSize:xuanzebong1];
            [cell.contentView addSubview: cityLab];

            submit.text=@"我要提交";
            submit.textAlignment = NSTextAlignmentLeft;
            submit.textColor=UIColorFromRGB(0x454CF4);
            [submit setNumberOfLines:0];
            submit.font = [UIFont systemFontOfSize:xuanzebong1];
            [cell.contentView addSubview: submit];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置点击cell不变色
        }else{
            GYZCity *city =  [self.searchCities objectAtIndex:indexPath.row];
            [cell.textLabel setText:city.projectName];
        }

        return cell;
    }

    if (indexPath.section < 1 ) {

        //判断后台定位是否打开
            GYZCityGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cityGroupCell];
            if (indexPath.section == 0 || [isLocation isEqual:@"Y"]) {

                [cell.refreshBtn setImage:[UIImage imageNamed:@"refreshImg"] forState:UIControlStateNormal];
                [cell.refreshBtn addTarget:self action:@selector(refreshBtn) forControlEvents:UIControlEventTouchUpInside];
                [cell.locationImg setImage:[UIImage imageNamed:@"localviewImg.png"]];
                cell.titleLabel.text = @"已定位项目";
                if(_commonCityData.count==0){
                    [cell.warnImg setImage:[UIImage imageNamed:@"warnImg.png"]];
                    cell.noDataLabel.text = @"当前城市没有找到项目";
                }
                [cell setCityArray:self.commonCityData];
            }
        
            [cell setDelegate:self];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置点击cell不变色
            return cell;

    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCell];
    GYZCityGroup *group = [self.cityDatas objectAtIndex:indexPath.section -1];
    GYZCity *city =  [group.arrayCitys objectAtIndex:indexPath.row];
    [cell.textLabel setText:city.projectName];
    
    return cell;
}

#pragma mark UITableViewDelegate
//返回表格每块的title
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < 1 || self.isSearch) {
        return nil;
    }
    GYZCityHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cityHeaderView];
    NSString *title = [_citySection objectAtIndex:section - 1];
    headerView.titleLabel.text = title;//表格每块的title
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearch) {
        return 44.0f;
    }
    if (indexPath.section == 0) {
        return [GYZCityGroupCell getCellHeightOfCityArray:self.commonCityData];
    }
    return 44.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < 1 || self.isSearch) {
        return 0.0f;
    }
    return 44.0f;
}
#pragma mark - tableview delegate
//选择小区
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 不加此句时，在二级栏目点击返回时，此行会由选中状态慢慢变成非选中状态。
    // 加上此句，返回时直接就是非选中状态。
    GYZCity *city = nil;

    if (self.isSearch) {
        if(self.searchCities.count!=0){
            city =  [self.searchCities objectAtIndex:indexPath.row];
//            [self didSelctedCity:city];
        }
        else
        {//未搜索到结果
            //跳转到我要提交页
            PersonalCenterSuggestViewController *vc = [[PersonalCenterSuggestViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
    }else{
        if (indexPath.section < 1) {

//            if (indexPath.section == 0 && self.commonCityData.count <= 0) {
////                [self locationStart];
//            }
            return;
        }
        GYZCityGroup *group = [self.cityDatas objectAtIndex:indexPath.section - 1];
        city =  [group.arrayCitys objectAtIndex:indexPath.row];
//        [self didSelctedCity:city];
    }
    [self didSelctedCity:city];//选择小区
    [self getDataFromService];//上传数据

}
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

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.isSearch) {
        return nil;
    }
    return self.noChSection;
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if(cityDic.count>0){
        for(int i=0;i<cityDic.count;++i){
            if([cityDic objectForKey:title]){
                NSArray *chengArray = [cityDic objectForKey:title];
                return [[chengArray objectAtIndex:0] intValue]+1;
            }
        }
    }
    return index-1;
}
#pragma mark searchBarDelegete

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    UIButton *btn=[searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchCities removeAllObjects];
//过滤文本框中的空格
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (searchText.length == 0) {
        self.isSearch = NO;
    }else{
        self.isSearch = YES;
        for (GYZCity *city in self.recordCityData){
            NSRange chinese = [city.projectName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange  letters = [city.pinyin rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange  initials = [city.initials rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (chinese.location != NSNotFound || letters.location != NSNotFound || initials.location != NSNotFound) {
                [self.searchCities addObject:city];
            }

        }
    }
    [tbView reloadData];
}
//添加搜索事件：
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
     [searchBar setShowsCancelButton:NO animated:YES];
     searchBar.text=@"";
    [searchBar resignFirstResponder];
    self.isSearch = NO;
    [tbView reloadData];
}
#pragma mark GYZCityGroupCellDelegate
//选择城市
- (void) cityGroupCellDidSelectCity:(GYZCity *)city
{
    [self didSelctedCity:city];
}

#pragma mark - Event Response
- (void) cancelButtonDown:(UIBarButtonItem *)sender
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(cityPickerControllerDidCancel:)]) {
        [_delegate cityPickerControllerDidCancel:self];
    }
}
#pragma mark - Private Methods
//选择城市
- (void) didSelctedCity:(GYZCity *)city
{
//    if (_delegate && [_delegate respondsToSelector:@selector(cityPickerController:didSelectCity:)]) {
//        [_delegate cityPickerController:self didSelectCity:city];
//    }

    // 获取选中的值，并将选中的值传回给新增路址
    if (self.selectNeighborhoodBlock) {
        self.selectNeighborhoodBlock(city);
    }
    if (_isSaveData) {
        NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:city.projectId forKey:KEY_PROJECTID];
        [userDefault setObject:city.projectName forKey:KEY_PROJECTNAME];
        [userDefault setObject:city.qrCode forKey:KEY_qrCode];//🍎
        selectProjectId = city.projectId;//选择小区的

        [userDefault synchronize];

        [self syncProjectInfoToServer:city.projectId];
    }
    if([self.delegate respondsToSelector:@selector(setSelectedNeighborhoodId:andName:andqrCode:)])//🍎
    {
#pragma mark-代理
        [self.delegate setSelectedNeighborhoodId:city.projectId andName:city.projectName andqrCode:city.qrCode];//🍎
    }
    if (!self.isRootVC) {
        // 设置选择的小区ID，传回主页
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        MainViewController *vc = [[MainViewController alloc] init];
        [Common appDelegate].window.rootViewController = vc;
    }
    selectProjectId = city.projectId;//选择小区的ID
    [self getDataFromService];//上传服务器数据


#pragma -mark ios 修改web view的ua（已选择小区）
    [UserAgent UserAgentMenthd];


}




@end
