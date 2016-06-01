//
//  CustomerServiceCenterViewController.m
//  CommunityApp
//
//  Created by iss on 6/29/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "CustomerServiceCenterViewController.h"
#import "PersonalCenterHotlineViewController.h"
#import "CustomerServiceCenterCollectionViewCell.h"
#import "CustomerServiceCenterCollectionMsgViewCell.h"
#import "CustomerServicePropertyHeadView.h"
#import "CustomerServiceMsgHeadView.h"
#import "SurroundBusinessViewController.h"
#import "MessageViewController.h"
//#import "CategorySelectedViewController.h"
#import "PostRepairEditViewController.h"
#import "PersonalCenterSuggestViewController.h"
static NSString* identifyPropertyCell = @"CustomerServiceCenterCollectionViewCell";
static NSString* identifyMsgCell = @"CustomerServiceCenterCollectionMsgViewCell";
static NSString* MsgHeaderViewNibName = @"CustomerServiceMsgHeadView";
static NSString* PropertyHeaderViewNibName = @"CustomerServicePropertyHeadView";
 static NSString* detail = @"家里的卫生如果不搞好，往往会为细菌、病毒提供生存空间，给自己和家人的健康带来威胁!但你知道吗?我们家里有好些个“癌症死角”，经常被大家所忽视!这无形中加大了我们患癌的风险!";
#define SERVICEID_POST @"67"
#define SERVICEID_NEGO @"23"
typedef enum
{
    CustomService_Property,
    CustomService_Msg,
    CustomService_Count
}CustomServiceEnumType;

@interface CustomerServiceCenterViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSArray* PropertyArray;
    NSArray* MsgArray;
    NSIndexPath* msgSelIndexPath;
}

@property (strong,nonatomic) IBOutlet UICollectionView* collection;

@end

@implementation CustomerServiceCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Str_Comm_Service;
   
    PropertyArray=@[@[Img_CustomerService_Praise,Str_CustomerService_Praise],@[Img_CustomerService_Mail,Str_CustomerService_Mail],@[Img_CustomerService_News,Str_CustomerService_News],@[Img_CustomerService_Tip,Str_CustomerService_Tip],@[Img_CustomerService_GovermentNews,Str_CustomerService_GovermentNews],@[Img_CustomerService_Key,Str_CustomerService_Key],@[Img_CustomerService_Express,Str_CustomerService_Express],@[Img_CustomerService_Nego,Str_CustomerService_Nego]];
    MsgArray = @[@"我的积分如何兑换？",@"未按时缴费如何收取滞纳金？",@"已购买的商品如何退换货？",@"如何获得业主认证？",@"物业费多久交一次？"];
    [self registNibForCollectionVew];
     self.hidesBottomBarWhenPushed = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    CGRect frame = self.tabBarController.tabBar.frame;
    self.tabBarController.tabBar.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 49);
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
#pragma mark---UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == CustomService_Property) {
        return [PropertyArray count];
    }else if(section == CustomService_Msg)
    {
        return [MsgArray count];
    }
    else return 0;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return CustomService_Count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   if(indexPath.section == CustomService_Property)
   {
       CustomerServiceCenterCollectionViewCell *cell = (CustomerServiceCenterCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifyPropertyCell forIndexPath:indexPath];
       
       [cell setCell: [PropertyArray objectAtIndex:indexPath.row]];
       return cell;
   }
    else if(indexPath.section == CustomService_Msg)
    {
        
        CustomerServiceCenterCollectionMsgViewCell *cell = (CustomerServiceCenterCollectionMsgViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifyMsgCell forIndexPath:indexPath];
       
        [cell setCell: [MsgArray objectAtIndex:indexPath.row] detail:detail];
        if(msgSelIndexPath && indexPath.row == msgSelIndexPath.row)
        {
            [cell showDetail];
        }
        else
        {
            [cell hideDetail];
        }
        return cell;
    }
    
    return nil;
}

#pragma mark - CollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == CustomService_Property) {
        switch (indexPath.row) {
            // 点赞物业
            case 0:
            {
                PersonalCenterSuggestViewController* vc = [[PersonalCenterSuggestViewController alloc]init];
                [self.navigationController pushViewController:vc animated:TRUE];
            }
                break;
            
            // 周边商家
            case 1:
            {
                SurroundBusinessViewController *vc = [[SurroundBusinessViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            
            // 生活资讯
            case 2:
            {
                MessageViewController* vc = [[MessageViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            // 温馨提示
            case 3:
            {
                MessageViewController* vc = [[MessageViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            
            // 政府公告
            case 4:
            {
                MessageViewController* vc = [[MessageViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            // 门禁卡
            case 5:
                break;
            
            // 快递服务
            case 6:
            {
                PostRepairEditViewController* vc = [[PostRepairEditViewController alloc] init];
                vc.serviceId = SERVICEID_POST;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            
            // 邻里协调
            case 7:
            {
                PostRepairEditViewController* vc = [[PostRepairEditViewController alloc] init];
                vc.serviceId = SERVICEID_NEGO;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    else if(indexPath.section == CustomService_Msg)
    {
//        if(msgSelIndexPath)
//        {
//            CustomerServiceCenterCollectionMsgViewCell* msgCell = (CustomerServiceCenterCollectionMsgViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
//            [msgCell hideDetail];
//        }
//        CustomerServiceCenterCollectionMsgViewCell* msgCell = (CustomerServiceCenterCollectionMsgViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
//        [msgCell showDetail];
        if(msgSelIndexPath && msgSelIndexPath.row == indexPath.row)
        {
            msgSelIndexPath = nil;
        }
        else
        {
            msgSelIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        }
        [_collection reloadData];
    }
}

#pragma mark -CollectionViewFlowlayout代理
// 设置CollectionViewCell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = 0;
    CGFloat height = 0;
    
    switch (indexPath.section) {
        case CustomService_Msg:
        {
            width = Screen_Width;
            
            if(msgSelIndexPath && msgSelIndexPath.row == indexPath.row)
            {
                height = [self sizeCellHeight];
            }
            else
                height = 43;
        }
            break;
        case CustomService_Property:
        {
            width = Screen_Width/4;
            height = 105;
        }
            break;
        default:
            break;
    }
    
    CGSize itemSize = CGSizeMake(width, height);
    return itemSize;
}

 
// 设置Header和FooterView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == CustomService_Property) {
            CustomerServicePropertyHeadView *view = (CustomerServicePropertyHeadView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:PropertyHeaderViewNibName forIndexPath:indexPath];
            [view setPropertyBlock:^(void) {
                [self toPropertyMessage];
            }];
            [view setHotLineBlock:^(void) {
                [self toHotline];
            }];
            return view;
        }
        else{
            CustomerServiceMsgHeadView *view = (CustomerServiceMsgHeadView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MsgHeaderViewNibName forIndexPath:indexPath];
            return view;
        }
    }
    return nil;
}


// 设置Sectionheader大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize itemSize = CGSizeMake(0, 0);
    switch (section) {
        case CustomService_Property:
            itemSize = CGSizeMake(Screen_Width, 208);
            break;
        case CustomService_Msg:
            itemSize = CGSizeMake(Screen_Width, 20);
            break;
        default:
            break;
    }
    
    return itemSize;
}

#pragma mark--other
-(void)registNibForCollectionVew
{
    //propertyCell
    UINib *nibForConvenienceService = [UINib nibWithNibName:identifyPropertyCell bundle:[NSBundle mainBundle]];
    [_collection registerNib:nibForConvenienceService forCellWithReuseIdentifier:identifyPropertyCell];
    //msgList
    UINib *nibForConvenienceService1 = [UINib nibWithNibName:identifyMsgCell bundle:[NSBundle mainBundle]];
    [_collection registerNib:nibForConvenienceService1 forCellWithReuseIdentifier:identifyMsgCell];
    
 
    UINib *nibPropertyFooterHeader = [UINib nibWithNibName:PropertyHeaderViewNibName bundle:[NSBundle mainBundle]];
    [_collection registerNib:nibPropertyFooterHeader forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PropertyHeaderViewNibName];
    
    
    UINib *nibMsgHeader = [UINib nibWithNibName:MsgHeaderViewNibName bundle:[NSBundle mainBundle]];
    [_collection registerNib:nibMsgHeader forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MsgHeaderViewNibName];
    
}
-(CGFloat)sizeCellHeight
{
    static CGFloat TitleHeight = 43.0f;

    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect tmpRect = [detail boundingRectWithSize:CGSizeMake(Screen_Width-20, 2000)  options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        
    //计算实际frame大小，并将label的frame变成实际大小
        
    CGRect  contentViewFrame = CGRectMake(0, 0, Screen_Width, TitleHeight+tmpRect.size.height);
    return contentViewFrame.size.height;
}
-(void)toPropertyMessage
{
    MessageViewController* vc = [[MessageViewController alloc]init];
    vc.isFreeDiscuss = TRUE;
    [self.navigationController pushViewController:vc animated:TRUE];
}
-(void)toHotline
{
    PersonalCenterHotlineViewController* vc = [[PersonalCenterHotlineViewController alloc]init];
    [self.navigationController pushViewController:vc animated:TRUE];
}
@end
