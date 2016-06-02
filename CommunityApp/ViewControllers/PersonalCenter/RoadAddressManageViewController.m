#import "RoadAddressManageViewController.h"
#import "RoadManageCellTableViewCell.h"
#import "UserModel.h"
#import "PersonalCenterAuthenticationViewController.h"
#import "NewNormalAddressViewController.h"
#import "PersonalCenterBindTelViewController.h"
#pragma mark - 宏定义区
#define RoadManageCellTableViewCellNibName          @"RoadManageCellTableViewCell"
#define Str_One         @"1"
#define Str_Two         @"2"
#define Str_Three       @"3"
#define Str_Fore        @"4"

@interface RoadAddressManageViewController ()

//@property (strong,nonatomic) IBOutlet UIButton *myButton;
@property (retain,nonatomic) IBOutlet UITableView *roadAddressTable;
@property (retain, nonatomic) IBOutlet UIView *footerView;
@property (nonatomic, strong) IBOutlet UIButton *addAddressButton;

//地址数据
@property (retain, nonatomic) NSMutableArray *roadDataArray;
@property(nonatomic,strong)NSArray*authenStatusarray;

@end

@implementation RoadAddressManageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavBarLeftItemAsBackArrow];
    
    self.roadDataArray = [[NSMutableArray alloc] init];
    if (self.showType == ShowDataTypeAuth) {
        self.navigationItem.title =  Str_MyAuth_RoadAddr;
        [self.addAddressButton setTitle:@"新增认证地址" forState:UIControlStateNormal];
    }
    else {
        self.navigationItem.title = Str_Road_Manager;
        [self.addAddressButton setTitle:@"新增地址" forState:UIControlStateNormal];
    }
    
    [self initBasicDataInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.showType == ShowDataTypeAll) {//显示全部
        [self requestData];
    }
    else {
        [self requestAuthenData];
    }
}

#pragma mark - tableview datasoure delegate
-(NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.roadDataArray.count == 0 && self.showType == ShowDataTypeAuth) {
        return 1;
    }
    return self.roadDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.roadDataArray.count == 0 && self.showType == ShowDataTypeAuth) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.text = @"亲，您还没有进行住户认证哦~";
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    RoadManageCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RoadManageCellTableViewCellNibName forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:RoadManageCellTableViewCellNibName owner:self options:nil]lastObject];
    }
    
    [cell loadCellData:[self.roadDataArray objectAtIndex:indexPath.row]   isModify:_isAddressSel?FALSE:TRUE ];
    
    cell.myButton.tag = indexPath.row;
    
    [cell.myButton addTarget:self action:@selector(myButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

/**
 *  点击事件
 */
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.roadDataArray.count == 0 && self.showType == ShowDataTypeAuth) {
        return;
    }
    if(_isAddressSel == addressSel_Edit)
    {
        RoadData *roadData = self.roadDataArray[indexPath.row];
        if (roadData.buildingId.length == 0) {
            NewNormalAddressViewController *next = [[NewNormalAddressViewController alloc] init];
            next.roadData = roadData;
            next.titleName = @"更新地址";
            [self.navigationController pushViewController:next animated:YES];
        }
        /*
        else {
            NewAddRoleInfoViewController *next = [[NewAddRoleInfoViewController alloc] init];
            
            next.roadData = roadData;
            next.titleName = @"更新地址";
            [self.navigationController pushViewController:next animated:YES];
        }
         */
    }
//    else if(_isAddressSel == addressSel_Auth)
//    {
//            RoadData* road = [_roadDataArray objectAtIndex:indexPath.row];
//            if([road.authen isEqualToString:@"1"])已认证
//            {
//                [Common showBottomToast:@"已认证过"];
//               return;
//            }
//            PersonalCenterAuthenticationViewController* vc = [[PersonalCenterAuthenticationViewController alloc]init];
//            vc.roadData = road;
//        [self.navigationController pushViewController:vc animated:TRUE];
//    }
    else
    {
        RoadData* road = [_roadDataArray objectAtIndex:indexPath.row];
 
        if (self.selectAddressProjectIdAndBuildingId) {
            NSString* addr = [NSString stringWithFormat:@"%@  %@",road.projectName,road.address];
            self.selectAddressProjectIdAndBuildingId(addr, road.projectId, road.buildingId);
            [self.navigationController popViewControllerAnimated:TRUE];
            
        }
        else if (self.selectRoadData) {
            self.selectRoadData(road);
            [self.navigationController popViewControllerAnimated:TRUE];
        }
    }
}


//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.roadDataArray.count == 0 && self.showType == ShowDataTypeAuth) {
        return NO;
    }
    RoadData *roadData  = [self.roadDataArray objectAtIndex:indexPath.row];
    //已认证的地址不能删除
    if ([roadData.authen isEqualToString:@"1"]) {
        return NO;
    }
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setEditing:YES animated:YES];
    //return UITableViewCellEditingStyleDelete;
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"commitEditingStyle");
        
        RoadData *roadData  = [self.roadDataArray objectAtIndex:indexPath.row];
        
        [self deleteRoadData:roadData.relateId];
    }
}

/**
 * 为button添加点击事件
 */
- (void)myButtonClicked:(UIButton *)button
{
    //点击先将数据删除，然后再将数据放到第一个
    RoadData *data = [self.roadDataArray objectAtIndex:button.tag];
    
    UserModel* user = [[Common appDelegate].userArray objectAtIndex:0];
    // 请求服务器获取数据
    NSString *userId = user.userId;
    [self setDefaultAddressRoadAddress:data.relateId userid: userId];
}

#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    //获取用户数据
    // NSMutableArray *userInfoArray=[Common appDelegate].userArray;
    
    //if (userInfoArray.count == 0)
    //{
    //    return;
    //}

    //UserModel *userInfoDic = [userInfoArray objectAtIndex:0];

    // 注册TableViewCell Nib
    UINib *nibForRoad = [UINib nibWithNibName:RoadManageCellTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.roadAddressTable registerNib:nibForRoad forCellReuseIdentifier:RoadManageCellTableViewCellNibName];
    
    self.footerView.frame = CGRectMake(0, 0, Screen_Width, 64);
    self.roadAddressTable.tableFooterView = self.footerView;
}

#pragma mark - 服务器获取数据
- (void)requestData
{
    [self.roadDataArray removeAllObjects];
    if([[LoginConfig Instance] userLogged]== FALSE) 
    return;
    UserModel* user = [[Common appDelegate].userArray objectAtIndex:0];
    // 请求服务器获取数据
    NSString *userId = user.userId;
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:   userId,@"userId",nil];
    [self getArrayFromServer:ServiceInfo_Url path:GetRoadAddressList_Path method:@"GET" parameters:dic xmlParentNode:@"buildingLocation" success:^(NSMutableArray *result)
     {
         for (NSDictionary *dicResult in result)
         {
             RoadData *roadData = [[RoadData alloc] initWithDictionary:dicResult];
             [self.roadDataArray addObject:roadData];
         }
         
         for (int i =0; i<self.roadDataArray.count; ++i)
         {
             RoadData *data = [self.roadDataArray objectAtIndex:i];
             if ([data.isDefault isEqual:@"1"])
             {
                 [self.roadDataArray removeObjectAtIndex:i];
                 [self.roadDataArray insertObject:data atIndex:0];
             }
         }
          
         [_roadAddressTable reloadData];
     }
                     failure:^(NSError *error)
     {
         [Common showBottomToast:Str_Comm_RequestTimeout];
     }];
}

- (void)requestAuthenData
{
    [self.roadDataArray removeAllObjects];
    if([[LoginConfig Instance] userLogged]== FALSE)
        return;
    UserModel* user = [[Common appDelegate].userArray objectAtIndex:0];
    // 请求服务器获取数据
    NSString *userId = user.userId;
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:   userId,@"userId",nil];
    NSUserDefaults*defaultsAuthen=[NSUserDefaults standardUserDefaults];
    [self getArrayFromServer:ServiceInfo_Url path:@"getBuildLocation" method:@"GET" parameters:dic xmlParentNode:@"buildingLocation" success:^(NSMutableArray *result)
     {
         NSMutableArray*array=[[NSMutableArray alloc]init];
         //没有数据的时候认证状态保存为空
         if (result.count==0) {
             //认证状态保存到本地
             [defaultsAuthen setObject:@"" forKey:@"authenStatus"];
         }
         for (NSDictionary *dicResult in result)
         {
             RoadData *roadData = [[RoadData alloc] initWithDictionary:dicResult];
             //所有的认证状态添加到数据
             [array addObject:dicResult[@"authen"]];
//             if ([roadData.authen isEqualToString:@"1"]) {
//                 [self.roadDataArray addObject:roadData];
//             }
             [self.roadDataArray addObject:roadData];
         }
         //所有的认证状态保存到数组
         self.authenStatusarray=[NSArray arrayWithArray:array];
         //消除认证状态的冗余并且封装新字典
         NSMutableDictionary *autnenDict = [[NSMutableDictionary alloc] init];
         for (NSString*str in self.authenStatusarray) {
             if ([str isEqualToString:Str_One]) {//已认证
                 if(![autnenDict objectForKey:Str_One]){
                     [autnenDict setObject:Str_One forKey:Str_One];
                 }
                 //存在 有认证的地址，认证状态保存到本地
                 
             }else if ([str isEqualToString:Str_Two]){//待认证
                 if(![autnenDict objectForKey:Str_Two]){
                     [autnenDict setObject:Str_Two forKey:Str_Two];
                 }
             }else if ([str isEqualToString:Str_Three]){///3 以拒绝
                 if(![autnenDict objectForKey:Str_Three]){
                     [autnenDict setObject:Str_Three forKey:Str_Three];
                 }
             }else{
                 if(![autnenDict objectForKey:Str_Fore]){
                     [autnenDict setObject:Str_Fore forKey:Str_Fore];
                 }
             }
         }
         //根据认证优先级，储存认证状态
         if ([autnenDict objectForKey:Str_One]) {//1 已认证
                 [defaultsAuthen setObject:@"YES" forKey:@"authenStatus"];
             //存在 有认证的地址，认证状态保存到本地
             
         }
         if ([autnenDict objectForKey:Str_Two]){//2 待认证
             if(![autnenDict objectForKey:Str_One]){
                 [defaultsAuthen setObject:@"MID" forKey:@"authenStatus"];
             }
         }
         if ([autnenDict objectForKey:Str_Three]){///3 以拒绝
             if(![autnenDict objectForKey:Str_One] && ![autnenDict objectForKey:Str_Two]){
                 [defaultsAuthen setObject:@"NO" forKey:@"authenStatus"];
             }
         }
         if ([autnenDict objectForKey:Str_Fore]){///4 异常
             if(![autnenDict objectForKey:Str_One] && ![autnenDict objectForKey:Str_Two] && ![autnenDict objectForKey:Str_Three]){
                 [defaultsAuthen setObject:@"CANCLE" forKey:@"authenStatus"];
             }
         }
//         NSLog(@"+++++++++++%@",[defaultsAuthen objectForKey:@"authenStatus"]);
         /*
          for (int i =0; i<self.roadDataArray.count; ++i)
          {
          RoadData *data = [self.roadDataArray objectAtIndex:i];
          if ([data.isDefault isEqual:@"1"])
          {
          [self.roadDataArray removeObjectAtIndex:i];
          [self.roadDataArray insertObject:data atIndex:0];
          }
          }
          */
         [_roadAddressTable reloadData];
     }
                     failure:^(NSError *error)
     {
         [Common showBottomToast:Str_Comm_RequestTimeout];
     }];
}

/**
 * 删除数据
 */
-(void) deleteRoadData:(NSString *)relateId
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: relateId,@"relateId",nil];
    
    [self getStringFromServer:ServiceInfo_Url path: DeleteRoadAddress_path method:@"post" parameters:dic success:^(NSString *result)
     {
         NSLog(@"%@",result);
         
         if([result isEqualToString:@"1"])
         {
             //重新获取数据
             if (self.showType == ShowDataTypeAll) {
                 [self requestData];
             }
             else {
                 [self requestAuthenData];
             }
         }
     }
     failure:^(NSError *error)
     {
         [Common showBottomToast:Str_Comm_RequestTimeout];
     }];

}

/**
 * 设置默认地址
 */
-(void) setDefaultAddressRoadAddress:(NSString *)relateId userid:(NSString *)userId
{
     NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys: userId,@"userId",relateId,@"relateId",nil];

    [self getStringFromServer:ServiceInfo_Url path: SetDefaultLocation_Path method:@"post" parameters:dic success:^(NSString *result)
    {
         NSLog(@"%@",result);
        
        if([result isEqualToString:@"1"])
        {
            if (self.showType == ShowDataTypeAll) {
                [self requestData];
            }
            else {
                [self requestAuthenData];
            }
        }
    }
    failure:^(NSError *error)
    {
        [Common showBottomToast:Str_Comm_RequestTimeout];

    }];
}
#pragma mark-* 跳转到新增页面

/**
* 跳转到新增页面
*/
- (IBAction)addRoadBtnClickHandler:(id)sender
{
#pragma -mark 12-30 网络连接判断
    BOOL netWorking = [Common checkNetworkStatus];
    if (netWorking) {
        //跳转到新增地址页面
        if (self.showType == ShowDataTypeAuth) {
#pragma mark-添加新增认证地址，没有绑定手机，不再跳到手机绑定页面
            //        NSString* bindTel = [[LoginConfig Instance]getBindPhone];
            //        if (bindTel==nil) {
            //            PersonalCenterBindTelViewController *vc = [[PersonalCenterBindTelViewController alloc] init];
            //
            //            [self.navigationController pushViewController:vc animated:YES];
            //        }
            //        else
            //        {
            NewAddRoleInfoViewController *next = [[NewAddRoleInfoViewController alloc]init];
            next.authen = YES;
            next.titleName = @"新增认证地址";
            [self.navigationController pushViewController:next animated:YES];
            //  }
        }
        else {
            NewNormalAddressViewController *next = [[NewNormalAddressViewController alloc] init];
            next.titleName = @"新增地址";
            [self.navigationController pushViewController:next animated:YES];
        }

    }
    else
    {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        return;
    }
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
