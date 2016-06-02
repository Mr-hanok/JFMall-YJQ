//
//  HousesServicesHouseDescViewController.m
//  CommunityApp
//
//  Created by iss on 7/3/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "HousesServicesHouseDescViewController.h"
#import "HousesServicesHouseDescTableViewCell.h"
#import "BuildingsServicesBuildingInfoTableViewCell.h"
#import "HousesServicesHouseDescCollectionViewCell.h"
#import "HouseDetailModel.h"
#import "HouseSelectorModel.h"
#import "BaiduMapViewController.h"

static NSString* identify = @"HousesServicesHouseDescTableViewCell";
static NSString* identify1 = @"BuildingsServicesBuildingInfoTableViewCell";
static NSString* identifyCollection = @"HousesServicesHouseDescCollectionViewCell";

@interface HousesServicesHouseDescViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray* array1;
    NSMutableArray* array2;
    HouseDetailModel* houseDetail;
}
@property (strong,nonatomic) IBOutlet UITableView* table;
@property (strong,nonatomic) IBOutlet UIView* tableHead;
@property (strong,nonatomic) IBOutlet UIView* tableFooter;
@property (strong,nonatomic) IBOutlet UILabel* state;
@property (strong,nonatomic) IBOutlet UICollectionView* collection;
@property (strong,nonatomic) IBOutlet UILabel* projectName;
@property (strong,nonatomic) IBOutlet UILabel* price;
@property (strong,nonatomic) IBOutlet UILabel* releaseTime;
@property (strong,nonatomic) IBOutlet UILabel* visitTime;
@property (strong,nonatomic) NSMutableArray*  orientationTypeArray;
@end

@implementation HousesServicesHouseDescViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = Str_HouseAgency;
    [self setNavBarLeftItemAsBackArrow];
    
    array1 = [[NSMutableArray alloc]init];
    array2 = [[NSMutableArray alloc]init];
    
    
    [array1 addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"一室一厅",Str_BuildingsInfo_HouseType,@"1900平方",Str_BuildingsInfo_Area,nil] ];
    [array1 addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"东向",Str_BuildingsInfo_Orientation,@"22/33",Str_BuildingsInfo_Floor,nil] ];
    [array1 addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"普通公寓",Str_BuildingsInfo_Type,@"90年代",Str_Houses_Birthday,nil] ];
    [array1 addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"广州市萝岗区中新广州知识城城南起步区九龙大道中",Str_Houses_Adrress,nil]];
    
//    [array2 addObject:[[NSDictionary alloc]initWithObjectsAndKeys:@"1980年",Str_HousesDescription_Year,nil]];
    [array2 addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"暂无",Str_HousesDescription_Detail,nil]];
    [array2 addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"采光良好",Str_HousesDescription_Light,nil]];
    [array2 addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"金装修",Str_HousesDescription_Decorate,nil]];
    [array2 addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"育英学区房",Str_HousesDescription_Study,nil]];
    [array2 addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"外面有广场",Str_HousesDescription_Spacial,nil]];
    [self registerNib];
    _table.tableFooterView = _tableFooter;
    _table.tableHeaderView = _tableHead;
    [_state.layer  setCornerRadius:3];
    [_state.layer setBorderWidth:0.5f];
    [_state.layer setBorderColor:[UIColor colorWithRed:215.0/255 green:155.0/255 blue:168.0/255.0 alpha:1].CGColor];
    _orientationTypeArray = [[NSMutableArray alloc]init];
    [self getOrientationFromServer];
    
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
#pragma mark --- table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return array1.count ;
    }
    return array2.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 /*& indexPath.row<=2*/) {
        return  30.0f;
    }
    else
    {
        return [self sizeCellHeight:indexPath];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 /*&& indexPath.row <= 2*/)
    {
        HousesServicesHouseDescTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
        [cell loadCellData:[array1 objectAtIndex:indexPath.row]];
        return cell;
    }
    BuildingsServicesBuildingInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify1];
    NSDictionary* data ;
    if(indexPath.section == 0)
    {
        data = [array1 objectAtIndex:indexPath.row];
    }
    else
    {
        data =[array2 objectAtIndex:indexPath.row];
    }
    [cell loadCellData:data];
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 5)];
    [footer setBackgroundColor:[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0f alpha:1]];
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 4, Screen_Width, 1)];
    [img setBackgroundColor:[UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0f alpha:1]];
    [footer addSubview:img];
    UIImageView* img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, Screen_Width, 1)];
    [img1 setBackgroundColor:[UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0f alpha:1]];
    [footer addSubview:img1];
    return footer;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
        return 40.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* head;
    if(section == 0){
        head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 1)];
        head.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        return head;
    }
    head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
    [head setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
    UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 20)];
    title.textColor = [UIColor colorWithRed:57/255.0 green:57/255.0 blue:57/255.0 alpha:1];
    if(section == 2)
    {
        [title setText:Str_BuildingsInfo_VisitTime];
    }
    if(section == 1)
    {
        [title setText:Str_BuildingsInfo_BuildingDesc];
    }

    [head addSubview:title];
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(5, 39, Screen_Width-2*5, 1)];
    [img setBackgroundColor:[UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0f alpha:1]];
    [head addSubview:img];
   
    return head;
}
#pragma mark---UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(houseDetail==nil || houseDetail.picPath==nil || [houseDetail.picPath isEqualToString:@""])
        return 0;
    NSArray* urlArray = [houseDetail.picPath componentsSeparatedByString:@","];
    return urlArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HousesServicesHouseDescCollectionViewCell *cell = (HousesServicesHouseDescCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifyCollection forIndexPath:indexPath];
    NSArray* array = [houseDetail.picPath componentsSeparatedByString:@","];//图片地址(多张，以”,”分开  示例	path1|fileId1,path2|fileId2”)
    NSString* picPath = [array objectAtIndex:indexPath.row];
    [cell loadCellData:[picPath substringToIndex:[picPath rangeOfString:@"|"].location]];
    
    return cell;
    
}


#pragma mark -CollectionViewFlowlayout代理
// 设置CollectionViewCell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = Screen_Width;
    CGFloat height = 135;
    
    CGSize itemSize = CGSizeMake(width, height);
    return itemSize;
}


#pragma mark--other
-(void)registerNib
{
    UINib *nib = [UINib nibWithNibName:identify bundle:[NSBundle mainBundle]];
    [_table registerNib:nib forCellReuseIdentifier:identify];
    UINib *nib1 = [UINib nibWithNibName:identify1 bundle:[NSBundle mainBundle]];
    [_table registerNib:nib1 forCellReuseIdentifier:identify1];
    UINib *nib2 = [UINib nibWithNibName:identifyCollection bundle:[NSBundle mainBundle]];
    [_collection registerNib:nib2 forCellWithReuseIdentifier:identifyCollection];
    
}

-(CGFloat)sizeCellHeight:(NSIndexPath *)indexPath
{
    NSDictionary* data ;
    if(indexPath.section == 0)
        data = [array1 objectAtIndex:indexPath.row];
    else
        data = [array2 objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:15];
    NSString*s = [data objectForKey:[[data allKeys]objectAtIndex:0]];
     

    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect tmpRect = [s boundingRectWithSize:CGSizeMake([BuildingsServicesBuildingInfoTableViewCell textWidth], 2000)  options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    
    //计算实际frame大小，并将label的frame变成实际大小
    //    CGRect tmpRect = [s boundingRectWithSize:CGSizeMake([BuildingsServicesBuildingInfoTableViewCell textWidth], 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    CGFloat height =  tmpRect.size.height+[BuildingsServicesBuildingInfoTableViewCell textHeightOrgin]*2;
    return height;
}


-(void)getHouseDesFromServer
{
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:self.recordId,@"recordId", nil ];
    [self getArrayFromServer:HouseInfo_Url path:HouseDetail_Path method:@"GET" parameters:dic xmlParentNode:@"house" success:^(NSMutableArray *result) {
        for (NSDictionary* houseDic in result) {
            houseDetail = [[HouseDetailModel alloc] initWithDictionary:houseDic];
        }
        if(result.count !=0)
        {
            [self freshPage];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}
-(void) freshPage
{
    [self.projectName setText:houseDetail.projectName];
    [self.state setText:houseDetail.recordTypeName];
    //0:长租1:短租 2:二手房
    if([houseDetail.recordTypeName isEqualToString:@"2"])
    {
         [self.price setText:[NSString stringWithFormat:@"￥%@元",houseDetail.price]];
    }
    else if([houseDetail.recordTypeName isEqualToString:@"1"])
    {
        [self.price setText:[NSString stringWithFormat:@"￥%@元/天",houseDetail.price]];
    }
    else if (([houseDetail.recordTypeName isEqualToString:@"0"]))
    {
        [self.price setText:[NSString stringWithFormat:@"￥%@元/月",houseDetail.price]];
    }
    [self.releaseTime setText:[NSString stringWithFormat:@"发布时间:%@",houseDetail.raleaseTime]];
    [self.visitTime setText:houseDetail.lookTime];
    self.navigationItem.title = houseDetail.title;
    NSDictionary* dicDes = [array2 objectAtIndex:0];
    [dicDes setValue:houseDetail.houseDesc forKey:Str_HousesDescription_Detail];
    NSDictionary* dicLight = [array2 objectAtIndex:1];
    [dicLight setValue:houseDetail.houseLighting forKey:Str_HousesDescription_Light];
    NSDictionary* dicDecor = [array2 objectAtIndex:2];
    [dicDecor setValue:houseDetail.houseDecoration forKey:Str_HousesDescription_Decorate];
    NSDictionary* dicSchool = [array2 objectAtIndex:3];
    [dicSchool setValue:houseDetail.schoolArea forKey:Str_HousesDescription_Study];
    NSDictionary* dicSpacial = [array2 objectAtIndex:4];
    [dicSpacial setValue:houseDetail.advantage forKey:Str_HousesDescription_Spacial];

    
    
    NSDictionary* array1Row1 = [array1 objectAtIndex:0];
    [array1Row1 setValue:houseDetail.roomTypeName forKey: Str_BuildingsInfo_HouseType];
    [array1Row1 setValue:[NSString stringWithFormat:@"%@㎡",houseDetail.houseSize] forKey: Str_BuildingsInfo_Area];
    NSDictionary* array1Row2 = [array1 objectAtIndex:1];
    [array1Row2 setValue:[self getHouseTypeName:houseDetail.orientation] forKey: Str_BuildingsInfo_Orientation];
    [array1Row2 setValue:[NSString stringWithFormat:@"%@/%@",houseDetail.floor,houseDetail.totalFloors] forKey: Str_BuildingsInfo_Floor];

    NSDictionary* array1Row3 = [array1 objectAtIndex:2];
    [array1Row3 setValue:houseDetail.houseTypeName forKey: Str_BuildingsInfo_Type];
    [array1Row3 setValue:[NSString stringWithFormat:@"%@年代",houseDetail.buildingYears] forKey: Str_Houses_Birthday];

    NSDictionary* array1Row4 = [array1 objectAtIndex:3];
    [array1Row4 setValue:houseDetail.buildingAddress forKey: Str_Houses_Adrress];
    [_collection reloadData];
    [_table reloadData];
}

-(NSString*)getHouseTypeName:(NSString*)houseTypeId
{
    for (HouseSelectorModel* model in _orientationTypeArray) {
        if ([model.detailId isEqualToString:houseTypeId]) {
            return model.detailName;
        }
    }
    return @"";
}
-(void)getOrientationFromServer
{
    [self getArrayFromServer:HouseInfo_Url path:HouseSelector_Path method:@"GET" parameters:nil xmlParentNode:@"orientation" success:^(NSMutableArray *result)
     {
         [self.orientationTypeArray removeAllObjects];
         
         for(NSDictionary *dic in result){
             [self.orientationTypeArray addObject:[[HouseSelectorModel alloc] initWithDictionary:dic]];
         }
         [self getHouseDesFromServer];
         
     }
     
    failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
        [self getHouseDesFromServer];
    }];
}

#pragma mark --IBAction
-(IBAction)clickMap:(id)sender
{
    BaiduMapViewController *vc = [[BaiduMapViewController alloc]init];
    [self.navigationController pushViewController:vc animated:TRUE];
}
@end
