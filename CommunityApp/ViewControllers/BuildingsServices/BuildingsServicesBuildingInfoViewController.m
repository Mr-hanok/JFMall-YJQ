//
//  BuildingsServicesBuildingInfoViewController.m
//  CommunityApp
//
//  Created by iss on 6/30/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BuildingsServicesBuildingInfoViewController.h"
#import "BuildingsServicesBuildingInfoTableViewCell.h"
#import "BuildingsServicesBuildingInfoLayoutCollectionViewCell.h"
#import "BuildingDetailModel.h"
#import "HousesServicesHouseDescCollectionViewCell.h"
#define FOOTHEIGHT 10.0f
static NSString* identify = @"BuildingsServicesBuildingInfoTableViewCell";
static NSString* identifyCollection = @"BuildingsServicesBuildingInfoLayoutCollectionViewCell";

@interface BuildingsServicesBuildingInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray* tableSection1Data;
    NSMutableArray* tableSection2Data;
    NSMutableArray* collectionData;
    BuildingDetailModel * buildingDetail;
    
}
@property (strong,nonatomic) IBOutlet UILabel* state;
@property (strong,nonatomic) IBOutlet UITableView* table;
@property (strong,nonatomic) IBOutlet UICollectionView* collection;
@property (strong,nonatomic) IBOutlet UIView* tableHead;
@property (strong,nonatomic) IBOutlet UIView* tableFooter;
@property (strong,nonatomic) IBOutlet UICollectionView* imgCollection;
@property (strong,nonatomic) IBOutlet UILabel* projectName;
@property (strong,nonatomic) IBOutlet UILabel* price;
@property (strong,nonatomic) IBOutlet UILabel* tel;
@property (strong,nonatomic) IBOutlet UIImageView * defaultBg;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint * collectionHeight;
@end

@implementation BuildingsServicesBuildingInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Str_BuildingsInfo_BuildingTitle;
    [self setNavBarLeftItemAsBackArrow];
    tableSection1Data = [[NSMutableArray alloc]init];
    tableSection2Data = [[NSMutableArray alloc]init];

    [tableSection1Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_Area,@"title",@"82-173㎡",@"text",nil] ];
    [tableSection1Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_Discount,@"title",@"参团享受95折",@"text",nil] ];
    [tableSection1Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_Open,@"title",@"2015-06-25",@"text",nil] ];
    [tableSection1Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_Builed,@"title",@"2016-06-25",@"text",nil] ];
    [tableSection1Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_Address,@"title",@"[黄埔 萝岗] 中新广州知识城南起步区九龙大道中（新知识城规划展示厅对面）",@"text",nil] ];
 

    
    [tableSection2Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_Type,@"title",@"高层",@"text",nil] ];
    [tableSection2Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_PropertyType,@"title",@"住宅",@"text",nil] ];
    [tableSection2Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_DecordateType,@"title",@"精装修",@"text",nil] ];
    [tableSection2Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_OwnerYears,@"title",@"70年",@"text",nil] ];
    [tableSection2Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_Convinients,@"title",@"暂无数据",@"text",nil] ];
    [tableSection2Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_PlotRatio,@"title",@"2.59",@"text",nil] ];
    [tableSection2Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_GreenRatio,@"title",@"40.1%",@"text",nil] ];
    [tableSection2Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_TotalUsers,@"title",@"2200户（总户数2200户）",@"text",nil] ];
    [tableSection2Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_RowsInfo,@"title",@"总共由24栋24-32层高层住宅，以及约20套联排别墅组成",@"text",nil] ];
    [tableSection2Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_TotalArea,@"title",@"10000",@"text",nil] ];
    [tableSection2Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_BuildArea,@"title",@"356000",@"text",nil] ];
    [tableSection2Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_Progress,@"title",@"在建中，竣工2015-06-29",@"text",nil] ];
    [tableSection2Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_PropertyFee,@"title",@"住宅3.18元/平米/月",@"text",nil] ];
    [tableSection2Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_PropertyCompany,@"title",@"广州市粤华物业管理有限公司",@"text",nil] ];
    [tableSection2Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_Builder,@"title",@"天韵（广州）房地产开发有限公司",@"text",nil] ];
    [tableSection2Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_Invester,@"title",@"星桥集团，永泰集团",@"text",nil] ];
    [tableSection2Data addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:Str_BuildInfo_SellAdress,@"title",@"广州市萝岗区中新广州知识城城南起步区九龙大道中（新知识城规划展示厅对面，14号线中新知识城南站上盖",@"text",nil] ];
    
    
    [self registerNib];
    [_state.layer  setCornerRadius:3];
    [_state.layer setBorderWidth:0.5f];
    [_state.layer setBorderColor:[UIColor colorWithRed:199.0/255 green:21.0/255 blue:85.0/255.0 alpha:1].CGColor];
    
    _table.tableHeaderView = _tableHead;
  // _table.tableFooterView = _tableFooter;
    [self getBuildDetailFromServer];
    // Do any additional setup after loading the view from its nib.
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
#pragma mark--table view
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
        UIView* footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, FOOTHEIGHT)];
        [footer setBackgroundColor:[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0f alpha:1]];
        UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(0, FOOTHEIGHT-1, Screen_Width, 1)];
        [img setBackgroundColor:[UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0f alpha:1]];
        [footer addSubview:img];
        UIImageView* img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 1)];
        [img1 setBackgroundColor:[UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0f alpha:1]];
        [footer addSubview:img1];
        return footer;
 
 
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView* head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 1)];
    [head setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0f alpha:1]];
    
    return head;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FOOTHEIGHT;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return [tableSection1Data count];
    }
    else
    {
        return tableSection2Data.count ;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildingsServicesBuildingInfoTableViewCell* cell = (BuildingsServicesBuildingInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identify];
    NSDictionary* data ;
    if(indexPath.section == 0)
        data = [tableSection1Data objectAtIndex:indexPath.row];
    else
        data = [tableSection2Data objectAtIndex:indexPath.row];
    [ cell loadCellData:data];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self sizeCellHeight:indexPath];
}

#pragma mark---UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == _imgCollection)
    {
        if(buildingDetail==nil || [buildingDetail.picPath isEqualToString:@""])
            return 0;
        NSArray* imgUrl = [buildingDetail.picPath componentsSeparatedByString:@","];
        return imgUrl.count;
    }
    else
    {
        if(buildingDetail==nil || [buildingDetail.apartments isEqualToString:@""])
            return 0;
        NSArray* apartment = [buildingDetail.apartments componentsSeparatedByString:@","];
        return apartment.count;
    }
   
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _imgCollection)
    {
        HousesServicesHouseDescCollectionViewCell* cell = [[HousesServicesHouseDescCollectionViewCell alloc]init];
        NSArray* array = [buildingDetail.picPath componentsSeparatedByString:@","];
        [cell loadCellData:[array objectAtIndex:indexPath.row]];
        return cell;
        
    }
    
        BuildingsServicesBuildingInfoLayoutCollectionViewCell *cell = (BuildingsServicesBuildingInfoLayoutCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifyCollection forIndexPath:indexPath];
        
        //[cell setCell: [PropertyArray objectAtIndex:indexPath.row]];
        return cell;
    
}


#pragma mark -CollectionViewFlowlayout代理
// 设置CollectionViewCell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = collectionView== _imgCollection?Screen_Width:115;
    CGFloat height = collectionView== _imgCollection?130:120;
    
    CGSize itemSize = CGSizeMake(width, height);
    return itemSize;
}


#pragma mark---other
-(void)registerNib
{
    UINib *nib = [UINib nibWithNibName:identify bundle:[NSBundle mainBundle]];
    [_table registerNib:nib forCellReuseIdentifier:identify];
    UINib *nibCollection = [UINib nibWithNibName:identifyCollection bundle:[NSBundle mainBundle]];
    [_collection registerNib:nibCollection forCellWithReuseIdentifier:identifyCollection];


}
-(CGFloat)sizeCellHeight:(NSIndexPath *)indexPath
{
    NSDictionary* data ;
    if(indexPath.section == 0)
        data = [tableSection1Data objectAtIndex:indexPath.row];
    else
         data = [tableSection2Data objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:15];
    NSString* s = [data objectForKey:@"text"];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect tmpRect = [s boundingRectWithSize:CGSizeMake([BuildingsServicesBuildingInfoTableViewCell textWidth], 2000)  options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    
    //计算实际frame大小，并将label的frame变成实际大小
//    CGRect tmpRect = [s boundingRectWithSize:CGSizeMake([BuildingsServicesBuildingInfoTableViewCell textWidth], 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    CGFloat height =  tmpRect.size.height+[BuildingsServicesBuildingInfoTableViewCell textHeightOrgin]*2;
    return height>=44?height:44.0f;
}
-(void)getBuildDetailFromServer
{
    NSDictionary* dic = [[NSDictionary alloc]initWithObjectsAndKeys:_projectId,@"projectId", nil];
    [self getArrayFromServer:ProjectInfo_Url path:ProjectDetail_Path method:@"GET" parameters:dic xmlParentNode:@"project" success:^(NSMutableArray *result) {
        for (NSDictionary* buildDic in result){
            buildingDetail = [[BuildingDetailModel alloc]initWithDictionary:buildDic];
        }
        if(result.count!=0)
        {
            [self freshPage];
        }
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}

-(void)freshPage
{
    [_projectName setText:buildingDetail.projectName];
    if([buildingDetail.averagePrice isEqualToString:@""])
    {
         [_price setText:@""];
    }
    else
    {
        [_price setText:[NSString stringWithFormat:@"均价%@元/㎡",buildingDetail.averagePrice]];
    }
    if([buildingDetail.salesStatusName isEqualToString:@""] == FALSE)
    {
        [_state setText:buildingDetail.salesStatusName];
        [_state setHidden:FALSE];
    }
    
//    [_tel setText:[NSString stringWithFormat:@"联系售楼处:%@",]];
    NSDictionary* sec1Row1 = [tableSection1Data objectAtIndex:0];
    [sec1Row1 setValue:buildingDetail.houseSize forKey:@"text"];
     NSDictionary* sec1Row2 = [tableSection1Data objectAtIndex:1];
    [sec1Row2 setValue:buildingDetail.discount forKey:@"text"];
     NSDictionary* sec1Row3 = [tableSection1Data objectAtIndex:2];
    [sec1Row3 setValue:buildingDetail.openTime forKey:@"text"];
     NSDictionary* sec1Row4 = [tableSection1Data objectAtIndex:3];
    [sec1Row4 setValue:buildingDetail.tradeTime forKey:@"text"];
    NSDictionary* sec1Row5 = [tableSection1Data objectAtIndex:4];
    [sec1Row5 setValue:buildingDetail.address forKey:@"text"];
    
    NSDictionary* sec2Row1 = [tableSection2Data objectAtIndex:0];
    [sec2Row1 setValue:buildingDetail.buildingType forKey:@"text"];
    NSDictionary* sec2Row2 = [tableSection2Data objectAtIndex:1];
    [sec2Row2 setValue:buildingDetail.propertyType forKey:@"text"];
    NSDictionary* sec2Row3 = [tableSection2Data objectAtIndex:2];
    [sec2Row3 setValue:buildingDetail.decorationStandard forKey:@"text"];
    NSDictionary* sec2Row4 = [tableSection2Data objectAtIndex:3];
    [sec2Row4 setValue:buildingDetail.propertyRight forKey:@"text"];
    NSDictionary* sec2Row5 = [tableSection2Data objectAtIndex:4];
    [sec2Row5 setValue:buildingDetail.aroundConfig forKey:@"text"];
    NSDictionary* sec2Row6 = [tableSection2Data objectAtIndex:5];
    [sec2Row6 setValue:buildingDetail.floorAreaRatio forKey:@"text"];
    NSDictionary* sec2Row7 = [tableSection2Data objectAtIndex:6];
    [sec2Row7 setValue:buildingDetail.greeningRate forKey:@"text"];
    NSDictionary* sec2Row8 = [tableSection2Data objectAtIndex:7];
    if([buildingDetail.planningUsers isEqualToString:@""])
    {
        [sec2Row8 setValue:@"" forKey:@"text"];
    }
    else
    {
         [sec2Row8 setValue:[NSString stringWithFormat:@"%@户",buildingDetail.planningUsers ] forKey:@"text"];
    }
    NSDictionary* sec2Row9 = [tableSection2Data objectAtIndex:8];
    [sec2Row9 setValue:buildingDetail.floorCondition forKey:@"text"];
    NSDictionary* sec2Row10 = [tableSection2Data objectAtIndex:9];
    [sec2Row10 setValue:buildingDetail.landArea forKey:@"text"];
    NSDictionary* sec2Row11 = [tableSection2Data objectAtIndex:10];
    [sec2Row11 setValue:buildingDetail.buildCountArea forKey:@"text"];
    
    NSDictionary* sec2Row12 = [tableSection2Data objectAtIndex:11];
    [sec2Row12 setValue:buildingDetail.projectSchedule forKey:@"text"];
    NSDictionary* sec2Row13 = [tableSection2Data objectAtIndex:12];
    if([buildingDetail.propertyCost isEqualToString:@""])
    {
         [sec2Row13 setValue:@"" forKey:@"text"];
        
    }else
    {
       [sec2Row13 setValue:[NSString stringWithFormat:@"%@元/平米/月",buildingDetail.propertyCost] forKey:@"text"];
    }
   
    NSDictionary* sec2Row14 = [tableSection2Data objectAtIndex:13];
    [sec2Row14 setValue:buildingDetail.propertyEnterprise forKey:@"text"];
    NSDictionary* sec2Row15 = [tableSection2Data objectAtIndex:14];
    [sec2Row15 setValue:buildingDetail.projectDeveloper forKey:@"text"];
    NSDictionary* sec2Row16 = [tableSection2Data objectAtIndex:15];
    [sec2Row16 setValue:buildingDetail.projectInvestors forKey:@"text"];
    NSDictionary* sec2Row17 = [tableSection2Data objectAtIndex:16];
    [sec2Row17 setValue:buildingDetail.salesAddr forKey:@"text"];
    [_table reloadData];
    [_imgCollection reloadData];
     NSArray* imgUrl = [buildingDetail.picPath componentsSeparatedByString:@","];
    if(imgUrl.count == 0 || [buildingDetail.picPath isEqualToString:@""])
    {
        [_defaultBg setHidden:FALSE];
    }
    NSArray* imgUrlArray = [buildingDetail.apartments componentsSeparatedByString:@","];
    if(imgUrlArray.count == 0 || [[imgUrl objectAtIndex:0] isEqualToString:@""])//隐藏户型图界面
    {
        _collectionHeight.constant = 20.f;
        _tableFooter.frame = CGRectMake(0, 0, Screen_Width, 210-125+20);
    }
    _table.tableFooterView = _tableFooter;

    [_collection reloadData];
}
@end
