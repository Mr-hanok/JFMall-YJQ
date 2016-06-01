//
//  BuildingsServicesBuildingInfoViewController.m
//  CommunityApp
//
//  Created by iss on 6/30/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "HousesServicesBuildingInfoViewController.h"
#import "HousesServicesBuildingInfoViewControllerTableViewCell.h"
#import "HousesDescriptionViewController.h"
#import "SelectNeighborhoodViewController.h"
#import "GYZChooseCityController.h"//////////选择小区
#import "HouseSelectorModel.h"
#import "LoginConfig.h"
#import "HousesLookTimeViewController.h"
#import "HouseDetailModel.h"

typedef enum
{
    HouseProperty_VisitorTime = 2,
    HouseProperty_Layout = 7,
    HouseProperty_Orientation,
    HouseProperty_Type,
    HouseProperty_Property,
    HouseProperty_PropertyInHand,
    HouseProperty_Descript ,
} HousePropertyEnumType;

#define LAYOUT_SHEET_TAG 256
#define ORIENT_SHEET_TAG LAYOUT_SHEET_TAG+1
#define TYPE_SHEET_TAG ORIENT_SHEET_TAG+1
#define PROPERTY_SHEET_TAG TYPE_SHEET_TAG+1
#define PROPERTYINHAND_SHEET_TAG PROPERTY_SHEET_TAG+1
//#define DESC_SHEET_TAG PROPERTYINHAND_SHEET_TAG+1

@interface HousesServicesBuildingInfoViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SelectNeighborhoodDelegate,UIActionSheetDelegate,HousesServicesBuildingInfoViewControllerTableViewCellDelegate,HousesLookTimeDelegate>
{
    NSArray* tableSection1Array1;
    NSArray* tableSection1Array2;
    NSArray* tableSection2Array;
    NSMutableArray* roomTypeArray;
    NSMutableArray* orientationArray;
    NSMutableArray* houseTypeArray;
    NSMutableArray* propertyArray;
    NSMutableArray* propertyInhandeArray;
    NSInteger selRoomType;
    NSInteger selOrientation;
    NSInteger selHouseType;
    NSInteger selProperty;
    NSInteger selPropertyInhande;
    NSArray* descDetail;
    NSMutableArray* picArray;
    HouseDetailModel* houseDetail;
}
@property (strong,nonatomic) IBOutlet UIButton* cam1;
@property (strong,nonatomic) IBOutlet UIButton* cam2;
@property (strong,nonatomic) IBOutlet UIButton* cam3;
@property (strong,nonatomic) IBOutlet UIImageView* img1;
@property (strong,nonatomic) IBOutlet UIImageView* img2;
@property (strong,nonatomic) IBOutlet UIImageView* img3;

@property (strong,nonatomic) IBOutlet UITableView* table;
@property (strong,nonatomic) IBOutlet UIView* tableHead;
@property (strong,nonatomic) IBOutlet UIView* tableEditHead;
@property (strong,nonatomic) IBOutlet UIView* tableFooter;

@property (strong,nonatomic) IBOutlet UILabel* distinct;
@property (strong,nonatomic) IBOutlet UILabel* area;
@property (strong,nonatomic) IBOutlet UITextView* address;
@property (strong,nonatomic) IBOutlet UILabel* areaEdit;
@property (strong,nonatomic) IBOutlet UITextView* addressEdit;

@property (strong,nonatomic) IBOutlet UIButton* longRentBtn;
@property (strong,nonatomic) IBOutlet UIButton* shortRentBtn;
@property (strong,nonatomic) IBOutlet UIButton* sellBtn;
@property (strong,nonatomic) NSString* projectId;
@property (strong,nonatomic) NSArray* sec1Data;
@property (strong,nonatomic) NSArray* sec2Data;
@property (strong,nonatomic) NSString* uuidStr;
@end
static NSString* identify = @"HousesServicesBuildingInfoViewControllerTableViewCell";
@implementation HousesServicesBuildingInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = Str_BuildingsInfo_Title;
    [self setNavBarLeftItemAsBackArrow];
    _sec1Data = @[@"",@"",@"",@"",@"",@"",@""];
    _sec2Data = @[@"",@"",@""];
    tableSection1Array1  =@[@[Str_HouseInfo_RentTitle],@[Str_BuildingsInfo_Rent,@"1",Str_BuildingsInfo_RentUnit],@[Str_BuildingsInfo_Area,@"1",Str_BuildingsInfo_AreaUnit],@[Str_BuildingsInfo_TotalFloor,@"1",Str_BuildingsInfo_FloorUnit],@[Str_BuildingsInfo_Floor,@"1",Str_BuildingsInfo_FloorUnit],@[Str_BuildingsInfo_Building],@[Str_BuildingsInfo_Room],@[Str_BuildingsInfo_HouseType,@"0",Str_BuildingsInfo_HouseTypeUnit],@[Str_BuildingsInfo_Orientation,@"0",Str_BuildingsInfo_OrientationUnit],@[Str_BuildingsInfo_BuildingType,@"0",Str_BuildingsInfo_BuildingTypeUnit],@[Str_BuildingsInfo_BuildingDesc,@"0",Str_BuildingsInfo_BuildingDescUnit]] ;
    
    tableSection1Array2  =
  @[@[Str_HouseInfo_RentTitle],@[Str_BuildingsInfo_Price,@"1",Str_BuildingsInfo_PriceUnit],@[Str_BuildingsInfo_Area,@"1",Str_BuildingsInfo_AreaUnit],@[Str_BuildingsInfo_TotalFloor,@"1",Str_BuildingsInfo_FloorUnit],@[Str_BuildingsInfo_Floor,@"1",Str_BuildingsInfo_FloorUnit],@[Str_BuildingsInfo_Building],@[Str_BuildingsInfo_Room],@[Str_BuildingsInfo_HouseType,@"0",Str_BuildingsInfo_HouseTypeUnit],@[Str_BuildingsInfo_Orientation,@"0",Str_BuildingsInfo_OrientationUnit],@[Str_BuildingsInfo_BuildingType,@"0",Str_BuildingsInfo_BuildingTypeUnit],@[Str_BuildingsInfo_PropertyRight,@"0",Str_BuildingsInfo_PropertyRightUnit],@[Str_BuildingsInfo_PropertyRightOwner,@"0",Str_BuildingsInfo_PropertyRightOwnerUnit],@[Str_BuildingsInfo_BuildingDesc,@"0",Str_BuildingsInfo_BuildingDescUnit]] ;
    
    tableSection2Array  =@[@[Str_BuildingsInfo_Contactor],@[Str_BuildingsInfo_Tel],@[Str_BuildingsInfo_VisitTime,@"0",Str_BuildingsInfo_VisitTimeUnit]] ;
    [_table registerNib:[UINib nibWithNibName:identify bundle:[NSBundle mainBundle]] forCellReuseIdentifier:identify];
    [_longRentBtn setSelected:TRUE];
    _table.tableFooterView = _tableFooter;
    if (_recordId == nil) {
         _table.tableHeaderView = _tableHead;
    }
    else
    {
        _table.tableHeaderView = _tableEditHead;
    }
   
    roomTypeArray = [[NSMutableArray alloc]init];
    orientationArray = [[NSMutableArray alloc]init];
    houseTypeArray = [[NSMutableArray alloc]init];
    propertyArray  = [[NSMutableArray alloc]init];
    propertyInhandeArray = [[NSMutableArray alloc]init];
    
    selRoomType = -1;
    selOrientation= -1;
    selHouseType= -1;
    selProperty= -1;
    selPropertyInhande= -1;
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    _projectId = [userDefault objectForKey:KEY_PROJECTID];
    [_area setText: [userDefault objectForKey:KEY_PROJECTNAME]];
    picArray = [[NSMutableArray alloc]init];
    [self getHouseSelectorFromServer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    if(_recordId ==nil)
        _uuidStr = [[Common getUUIDString] lowercaseString];
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


#pragma mark - 键盘显示、隐藏事件处理函数重写
- (void)keyboardDidShow:(NSNotification *)notification
{
    CGFloat hight = self.keyboardHeight;
    [super keyboardDidShow:notification];
    hight = self.keyboardHeight - hight;
    self.table.contentSize = CGSizeMake(self.table.contentSize.width, self.table.contentSize.height+hight);
}

- (void)keyboardDidHide
{
    self.table.contentSize = CGSizeMake(self.table.contentSize.width, self.table.contentSize.height-self.keyboardHeight);
    [super keyboardDidHide];
}


// 手势隐藏键盘
- (void)hideKeyBoard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --- other
-(NSInteger)getSelId:(NSArray* )data obj:(NSString*)obj
{
    NSInteger sel = -1;
    if(obj == nil)
        return sel;
    for(HouseSelectorModel* model in data)
    {
        sel++;
        if([model.detailId isEqualToString:obj])
        {
            return  sel;
        }
    }
    return -1;
}
-(void)freshPage
{
    _uuidStr = houseDetail.orderId;
    _projectId = houseDetail.projectId;
    [_areaEdit setText: houseDetail.projectName];
    [_addressEdit setText:houseDetail.projectAdress];
    
    
    NSMutableArray *data = [self.sec1Data mutableCopy];
    if (houseDetail.title != nil) {
        data[0] = houseDetail.title;
    }
    if (houseDetail.price != nil) {
        data[1] = houseDetail.price;
    }
    if (houseDetail.houseSize != nil) {
        data[2] = houseDetail.houseSize;
    }
    if (houseDetail.totalFloors != nil) {
        data[3] = houseDetail.totalFloors;
    }
    if (houseDetail.floor != nil) {
        data[4] = houseDetail.floor;
    }
    if (houseDetail.buildNo != nil) {
        data[5] = houseDetail.buildNo;
    }
    if (houseDetail.roomNo != nil) {
        data[6] = houseDetail.roomNo;
    }
    selRoomType = [self getSelId: roomTypeArray obj:houseDetail.roomType];
    selHouseType= [self getSelId: houseTypeArray obj:houseDetail.houseType];
    selOrientation= [self getSelId: orientationArray obj:houseDetail.orientation];
//    data[7] = houseDetail.roomTypeName;
//    data[8] = houseDetail.orientationName;
//    data[9] = houseDetail.houseTypeName;
    if ([houseDetail.recordType isEqualToString:@"2"])//买房
    {
       selProperty = [self getSelId: propertyArray obj:houseDetail.property];
       selPropertyInhande = [self getSelId: propertyInhandeArray obj:houseDetail.propertyInhand];
    }
    self.sec1Data = [data copy];
    NSMutableArray *data2 = [self.sec2Data mutableCopy];
    if (houseDetail.linkman != nil) {
        data2[0] = houseDetail.linkman;
    }
    if (houseDetail.linkPhone != nil) {
        data2[1] = houseDetail.linkPhone;
    }
    if (houseDetail.lookTime != nil) {
        data2[2] = houseDetail.lookTime;
    }
    self.sec2Data = [data2 copy];
    [_table reloadData];
}
-(void)popVisitTimePage
{
    HousesLookTimeViewController* vc = [[HousesLookTimeViewController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:TRUE];
}
-(void)popDecPage
{
    HousesDescriptionViewController* next = [[HousesDescriptionViewController alloc]init];
    next.selecHouseDescriptBlock = ^(NSArray* data){
        descDetail = [NSArray arrayWithArray:data];
    };
    [self.navigationController pushViewController:next animated:TRUE];
}
-(void)popSheet:(NSArray*)array tag:(NSInteger)sheetTag
{
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles: nil];
    sheet.tag = sheetTag;
    for (HouseSelectorModel* selector in array){
        [sheet addButtonWithTitle:selector.detailName];
    }
    [sheet showInView:self.view];
}
-(void)popLayout
{
    [self popSheet:roomTypeArray tag:LAYOUT_SHEET_TAG];
}
-(void)popOrientation
{
   [self popSheet:orientationArray tag:ORIENT_SHEET_TAG];
}
-(void)popType
{
    [self popSheet:houseTypeArray tag:TYPE_SHEET_TAG];
}
-(void)popProperty
{
    [self popSheet:propertyArray tag:PROPERTY_SHEET_TAG];
}
-(void)popPropertyInHand
{
    [self popSheet:propertyInhandeArray tag:PROPERTYINHAND_SHEET_TAG];
}
-(void)getHouseSelectorFromServer
{
    [self getOrignStringFromServer:HouseInfo_Url path:HouseSelector_Path method:@"GET" parameters:nil success:^(NSString *string) {
        if ([string isEqualToString:@""] == FALSE) {
            NSMutableArray* result =  [self getArrayFromXML:string byParentNode:@"roomType"];
            for(NSDictionary* dic in result)
            {
                [roomTypeArray addObject:[[HouseSelectorModel alloc]initWithDictionary:dic ]];
            }
            result =  [self getArrayFromXML:string byParentNode:@"orientation"];
            for(NSDictionary* dic in result)
            {
                [orientationArray addObject:[[HouseSelectorModel alloc]initWithDictionary:dic ]];
            }
            result =  [self getArrayFromXML:string byParentNode:@"houseType"];
            for(NSDictionary* dic in result)
            {
                [houseTypeArray addObject:[[HouseSelectorModel alloc]initWithDictionary:dic ]];
            }
            result =  [self getArrayFromXML:string byParentNode:@"property"];
            for(NSDictionary* dic in result)
            {
                [propertyArray addObject:[[HouseSelectorModel alloc]initWithDictionary:dic ]];
            }
            result =  [self getArrayFromXML:string byParentNode:@"propertyInhande"];
            for(NSDictionary* dic in result)
            {
                [propertyInhandeArray addObject:[[HouseSelectorModel alloc]initWithDictionary:dic ]];
            }
            if(_recordId !=nil)
            {
                [self getHouseDesFromServer];
            }
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}
#pragma mark-- tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1)
    {
        return [tableSection2Array count];
    }
    else
    {
        if(_recordId == nil)
        {
            if (_sellBtn.selected == TRUE) {
                return [tableSection1Array2 count];
            }else
            {
                return [tableSection1Array1 count];
            }
        }
        else
        {
            if ([houseDetail.recordType isEqualToString:@"2"]) {
                return [tableSection1Array2 count];
            }
            else
            {
                return [tableSection1Array1 count];
            }
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        if(indexPath.row == HouseProperty_VisitorTime)
        {
            [self popVisitTimePage];
        }
    }
    else{
        if(indexPath.row == HouseProperty_Descript)
        {
            [self popDecPage];
            
        }else if(indexPath.row == HouseProperty_Layout)
        {
            [self popLayout];
        }
        else if(indexPath.row == HouseProperty_Orientation)
        {
            [self popOrientation];
        }
        else if(indexPath.row == HouseProperty_Property )
        {
            if ( _sellBtn.selected == TRUE) {
                 [self popProperty];
            }
            else
            {
                [self popDecPage];
            }
           
        }
        else if(indexPath.row == HouseProperty_PropertyInHand)
        {
            [self popPropertyInHand];
        }
        else if(indexPath.row == HouseProperty_Type)
        {
            [self popType];
        }
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   HousesServicesBuildingInfoViewControllerTableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:identify owner:self options:nil]lastObject];
    }
    NSMutableArray* array ;
    if(indexPath.section == 0)
    {
        if (_sellBtn.selected == TRUE) {
            array = [[NSMutableArray alloc]initWithArray:[tableSection1Array2 objectAtIndex:indexPath.row]];
            
        }else
        {
            array = [[NSMutableArray alloc]initWithArray:[tableSection1Array1 objectAtIndex:indexPath.row]];
            
        }
    }else
    {
        array = [[NSMutableArray alloc]initWithArray:[tableSection2Array objectAtIndex:indexPath.row]];
    }
    
    if(indexPath.section ==0)
    {
        if(indexPath.row >= HouseProperty_Layout)
        {
            if(indexPath.row == HouseProperty_Layout && selRoomType !=-1)
            {
                HouseSelectorModel* model = [roomTypeArray objectAtIndex:selRoomType];
                [array addObject:model.detailName];
            }
            else if(indexPath.row == HouseProperty_Orientation && selOrientation !=-1)
            {
                HouseSelectorModel* model = [orientationArray objectAtIndex:selOrientation];
                [array addObject:model.detailName];
            }
            else if(indexPath.row == HouseProperty_Type && selHouseType !=-1)
            {
                HouseSelectorModel* model = [houseTypeArray objectAtIndex:selHouseType];
                [array addObject:model.detailName];
            }
            else if(indexPath.row == HouseProperty_Type && selProperty !=-1)
            {
                HouseSelectorModel* model = [propertyArray objectAtIndex:selProperty];
                [array addObject:model.detailName];
            }
            else if(indexPath.row == HouseProperty_PropertyInHand && selPropertyInhande !=-1)
            {
                HouseSelectorModel* model = [propertyInhandeArray objectAtIndex:selPropertyInhande];
                [array addObject:model.detailName];
            }
        }
        else
        {
            [array addObject:[_sec1Data objectAtIndex:indexPath.row]];

        }
    }else if(indexPath.section == 1)
    {
        if (indexPath.row !=2  ||  [_sec2Data[2] isEqualToString:@""]==FALSE)
            [array addObject:[_sec2Data objectAtIndex:indexPath.row]];
        
    }
    
    [cell loadCellData:array];
    if(indexPath.section == 1)
    {
        if(indexPath.row == tableSection2Array.count-1)
        {
            [cell isBottom];
        }
    }
    else
    {
        if (_sellBtn.selected == TRUE) {
            if(indexPath.row == tableSection1Array2.count-1)
            {
               [cell isBottom];
            }
        }else
        {
            if(indexPath.row == tableSection1Array1.count-1)
            {
                [cell isBottom];
            }
        }
    }
    cell.delegate = self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) {
        return 5.0;
    }
    return 1.0f;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 0)
    {
        
        UIView* footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 5)];
        [footer setBackgroundColor:[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0f alpha:1]];
        UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 4, Screen_Width, 1)];
        [img setBackgroundColor:[UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0f alpha:1]];
        [footer addSubview:img];
        return footer;
    }
    return nil;
}
#pragma mark--IBAction
-(IBAction)clickCommit:(id)sender
{
    NSDateFormatter* formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy-MM-dd"];
    NSString* title = [_sec1Data objectAtIndex:0];
    NSString* price = [_sec1Data objectAtIndex:1];
    NSString* size =  [_sec1Data objectAtIndex:2];
    NSString* floor = [_sec1Data objectAtIndex:3];
    NSString* totalFloors =  [_sec1Data objectAtIndex:4];
    NSString* buildNo = [_sec1Data objectAtIndex:5];
    NSString* roomNo = [_sec1Data objectAtIndex:6];
    HousesServicesBuildingInfoViewControllerTableViewCell*cell = (HousesServicesBuildingInfoViewControllerTableViewCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    NSString* linkPhone = [cell getInputText];
    HousesServicesBuildingInfoViewControllerTableViewCell*cell2 = (HousesServicesBuildingInfoViewControllerTableViewCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString* linkMan = [cell2 getInputText];
    HouseSelectorModel* houseModel;
    NSString* roomType =@"";
    if(selRoomType!=-1)
    {
        houseModel =  [roomTypeArray objectAtIndex:selRoomType];
        roomType = houseModel.detailId;

    }
    NSString* houseorientation = @"";
    if(selOrientation!=-1)
    {
        houseModel =  [orientationArray objectAtIndex:selOrientation];
        houseorientation = houseModel.detailId;
        
    }
   NSString* houseType =@"";
    if (selHouseType!=-1) {
        houseModel =  [houseTypeArray objectAtIndex:selHouseType];
        houseType= houseModel.detailId;

    }
    
    NSString* bulidingYears = @"";
    if (descDetail.count) {
        bulidingYears = [descDetail objectAtIndex:0];
    }
    NSString* houseDesc = @"";
    if (descDetail.count) {
        houseDesc = [descDetail objectAtIndex:1];
    }
    NSString* houseLighting = @"";
    if (descDetail.count) {
        houseLighting = [descDetail objectAtIndex:2];
    }
    NSString* houseDecoration = @"";
    if (descDetail.count) {
        houseDecoration = [descDetail objectAtIndex:3];
    }
    NSString* schoolArea = @"";
    if (descDetail.count) {
        schoolArea = [descDetail objectAtIndex:4];
    }
    NSString* advantage = @"";
    if (descDetail.count) {
        advantage = [descDetail objectAtIndex:5];
    }
    NSString* recordType = @"0";
    NSString* priceType = @"2";
    if(_shortRentBtn.selected)
    {
        recordType = @"1";
        priceType = @"1";
    }
    else if(_sellBtn.selected)
    {
        recordType = @"2";
    }
    NSString* lookTime = _sec2Data[2];
//    NSMutableString* picTemp = [[NSMutableString alloc]init];
//    for(NSString* picName in picArray)
//    {
//        [picTemp appendFormat:@"%@.jpg,",picName];
//    }
//    NSString* pic =  [picTemp substringToIndex:picTemp.length-1];
    if(_recordId == nil)
        _recordId = @"";
    NSString* address = @"";
    if(_recordId !=nil)
        address = _addressEdit.text;
    else
        address = _address.text;
    NSDictionary* dic  = [[NSDictionary alloc]initWithObjectsAndKeys:
                          [LoginConfig Instance].userID,@"releaseUserId",[formate stringFromDate:[NSDate date]],@"raleaseTime",linkPhone,@"linkPhone",linkMan,@"linkMan",title,@"title",_projectId,@"projectId",address,@"projectAddress",price,@"price",priceType,@"priceType",size,@"houseSize",floor,@"floor",totalFloors,@"totalFloors",buildNo,@"buildNo",roomNo,@"roomNo",   roomType,@"roomType",houseorientation,@"orientation",houseType,@"houseType",bulidingYears,@"bulidingYears",houseDesc,@"houseDesc",
                            houseLighting,@"houseLighting",houseDecoration,@"houseDecoration",schoolArea,@"schoolArea",advantage,@"advantage",
                          recordType,@"recordType",lookTime,@"lookTime",_uuidStr,@"orderId",_recordId,@"recordId",
                          nil];
    if(_sellBtn.selected)
    {
        NSMutableDictionary * dicTmp = [dic mutableCopy];
        NSString* property = @"";
        if(selProperty != -1)
        {
            houseModel =  [propertyArray objectAtIndex:selProperty];
            property = houseModel.detailId;
        }
        NSString*propertyInhande = @"";
        if(selPropertyInhande!=-1)
        {
            houseModel =  [propertyInhandeArray objectAtIndex:selPropertyInhande];
            propertyInhande = houseModel.detailId;
        }
        [dicTmp setObject:property forKey:@"property"];
        [dicTmp setObject:propertyInhande forKey:@"propertyInhande"];
        dic  = [dicTmp copy];
    }
    [self getStringFromServer:HouseInfo_Url path:UploadHouseInfo_Path parameters:dic success:^(NSString* string) {
        if ([string isEqualToString:@"1"])//register success
        {
            [self.navigationController popViewControllerAnimated:TRUE];
            
        }else
            NSLog(@"修改失败");
        
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];


}
-(IBAction)clickDistinct:(id)sender
{
    SelectNeighborhoodViewController* vc = [[SelectNeighborhoodViewController alloc]init];
//    GYZChooseCityController *vc = [[GYZChooseCityController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:TRUE];
    
}
-(IBAction)clickLongRent:(id)sender
{
    _longRentBtn.selected = TRUE;
    _shortRentBtn.selected = FALSE;
    _sellBtn.selected = FALSE;
    [_table reloadData];
}
-(IBAction)clickShortRent:(id)sender
{
    _longRentBtn.selected = FALSE;
    _shortRentBtn.selected = TRUE;
    _sellBtn.selected = FALSE;
    [_table reloadData];

}
-(IBAction)clickSell:(id)sender
{
    _longRentBtn.selected = FALSE;
    _shortRentBtn.selected = FALSE;
    _sellBtn.selected = TRUE;
    [_table reloadData];

}

-(IBAction)clickCamera:(id)sender
{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles:Str_MyPost_Picker_Take,Str_MyPost_Pick_Album, nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:Str_Comm_Cancel destructiveButtonTitle:nil otherButtonTitles:Str_MyPost_Pick_Album, nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}
#pragma mark--UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 2:
                    // 取消
                    return;
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            } else {
                return;
            }
        }
        
        // 跳转到相机或相册页面
        
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
    else
    {
        if(buttonIndex == 0)
            return;
        NSInteger row = actionSheet.tag-LAYOUT_SHEET_TAG+HouseProperty_Layout;
        
        HousesServicesBuildingInfoViewControllerTableViewCell* cell = (HousesServicesBuildingInfoViewControllerTableViewCell*)[_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row  inSection:0]];
        HouseSelectorModel* selctor;
        NSInteger sel =  buttonIndex-1;
        if(actionSheet.tag == LAYOUT_SHEET_TAG)
        {
            if(buttonIndex > roomTypeArray.count)
            {
              return;
            }
            selRoomType = sel;
            selctor = [roomTypeArray objectAtIndex:selRoomType];
        }
        else if(actionSheet.tag == ORIENT_SHEET_TAG)
        {
            if(buttonIndex > orientationArray.count)
            {
                return;
            }
            selOrientation = sel;
            selctor = [orientationArray objectAtIndex:selOrientation];

        }
        else if(actionSheet.tag == TYPE_SHEET_TAG)
        {
            if(buttonIndex > houseTypeArray.count)
            {
                return;
            }
            selHouseType = sel;
            selctor = [houseTypeArray objectAtIndex:selHouseType];
            
        }
        else if(actionSheet.tag == PROPERTY_SHEET_TAG)
        {
            if(buttonIndex > propertyArray.count)
            {
                return;
            }
            selProperty = sel;
            selctor = [propertyArray objectAtIndex:selProperty];
            
        }
        else if(actionSheet.tag == PROPERTYINHAND_SHEET_TAG)
        {
            if(buttonIndex > propertyInhandeArray.count)
            {
                return;
            }
            selPropertyInhande = sel;
            selctor = [propertyInhandeArray objectAtIndex:selPropertyInhande];
            
        }
        [cell setTextContext:selctor.detailName];
    }
}

#pragma mark---UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(_img1.image == nil)
    {
        [_img1 setHidden:FALSE];
        [_cam1 setHidden:TRUE];
        [_cam2 setHidden:FALSE];
        [ _img1 setImage:image];
        
    }
    else if(_img2.image == nil)
    {
        [_img2 setHidden:FALSE];
        [_cam2 setHidden:TRUE];
        [_cam3 setHidden:FALSE];
        [ _img2 setImage:image];
    }
    else if(_img3.image == nil)
    {
        [_img3 setImage:image];
        [_img3 setHidden:FALSE];
        [_cam3 setHidden:TRUE];
    }
    NSString* fileId = [[Common getUUIDString]lowercaseString];
    [self uploadImageWithUrl:FileManager_Url path:FileManager_Path fileid:fileId  image:image success:^(NSString *result) {
        [self uploadImgPathToServer:ServiceInfo_Url path:MyPostRepairUploadFiles_Path recordId:_uuidStr fileId:fileId success:^(NSString *result) {
             
        } failure:^(NSError *error) {
            [Common showBottomToast:Str_Comm_RequestTimeout];
        }];
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_FileConnectFailed];
    }];
        
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark --- SelectNeighborhoodDelegate
-(void)setSelectedNeighborhoodId:(NSString *)projectId andName:(NSString *)projectName
{
    [_area setText:projectName];
    _projectId = projectId;
}
#pragma mark---HousesServicesBuildingInfoViewControllerTableViewCellDelegate
-(void)textFiledShouldEditEnd:(HousesServicesBuildingInfoViewControllerTableViewCell*)cell inputText:(NSString*)inputText;
{
    NSIndexPath* indexPath = [_table indexPathForCell:cell];
    if(indexPath.section == 1)
    {
        NSMutableArray *data = [self.sec2Data mutableCopy];
        data[indexPath.row] = inputText;
        self.sec2Data = [data copy];
      return;
    }
    
    NSMutableArray *data = [self.sec1Data mutableCopy];
    data[indexPath.row] = inputText;
    self.sec1Data = [data copy];
}
#pragma mark---HousesLookTimeDelegate
-(void)selHousesLookTime:(NSString *)dateString
{
    NSMutableArray *data = [self.sec2Data mutableCopy];
    data[2] = dateString;
    self.sec2Data = [data copy];
    [_table reloadData];
}
@end
