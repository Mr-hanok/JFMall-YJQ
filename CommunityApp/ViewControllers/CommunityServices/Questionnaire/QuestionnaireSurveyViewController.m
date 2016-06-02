//
//  CSQNQuestionnaireSurveyViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//  问卷调查列表

#import "QuestionnaireSurveyViewController.h"
#import "QuestionnaireTableCellTableViewCell.h"
//
//#import "QuestionSurveyJoinViewController.h"//开始问卷
#import "QuestionContentListViewController.h"
//
#import "QuestionnaireExtendTableViewCell.h"
#import "UserModel.h"
//🍎
#import "PersonalCenterModBaseInfoViewController.h"

#pragma mark - 宏定义区
#define QuestionnaireTableCellTableViewCellNibName          @"QuestionnaireTableCellTableViewCell"
#define QuestionnaireExtendTableViewCellNibName             @"QuestionnaireExtendTableViewCell"


@interface QuestionnaireSurveyViewController ()

@property (nonatomic, retain) IBOutlet UITableView *tableView;

// 调查问卷数据数组
@property (nonatomic, retain)   NSMutableArray      *questionnairData;

// 当前选中Cell序号
@property (nonatomic, assign)   NSInteger           selectCellNo;

@end

@implementation QuestionnaireSurveyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化导航栏信息
    self.navigationItem.title = Str_Question_Title;
    [self setNavBarLeftItemAsBackArrow];
    [self initBasicDataInfo];
}

#pragma mark - tableview datasource delegate
// 设置Cell数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.questionnairData.count;
}

// 设置Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0;
    
    if (indexPath.row == self.selectCellNo) {
        height = 130.0;
    }
    
    return height;
}

// 装载Cell元素
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.selectCellNo) {   // 选中Cell
        QuestionnaireExtendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QuestionnaireExtendTableViewCellNibName forIndexPath:indexPath];
        [cell loadCellData:(QuestionnaireSurvey *)[self.questionnairData objectAtIndex:indexPath.row]];
        
        // 注册 ‘点击参与’ 按钮点击事件block
        [cell registJoinQuestionnairBlock:^{
            QuestionContentListViewController *vc = [[QuestionContentListViewController alloc]init];
            QuestionnaireSurvey* survey = [self.questionnairData objectAtIndex:indexPath.row];
            //🍎
            UserModel* user = [[Common appDelegate].userArray objectAtIndex:0];
            vc.qid = survey.mpqid;
            //🍎
            vc.investigatorName = user.userName;
            vc.investigatorTel = user.ownerPhone;
            
            [self.navigationController pushViewController:vc animated:YES];
        }];

        return cell;
    }
    else {  // 非选中Cell
        QuestionnaireTableCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QuestionnaireTableCellTableViewCellNibName forIndexPath:indexPath];
        [cell loadCellData:(QuestionnaireSurvey *)[self.questionnairData objectAtIndex:indexPath.row]];
        return cell;
    }

    return nil;
}


#pragma mark - tableview delegate
// 点击事件Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectCellNo = indexPath.row;
    [self.tableView reloadData];
}


#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    self.selectCellNo = 0;
    
    self.questionnairData = [[NSMutableArray alloc] init];
    
    // 请求服务器获取周边商家数据
    [self getDataFromServer];
    
    // 注册TableViewCell Nib
    UINib *nibForNormal = [UINib nibWithNibName:QuestionnaireTableCellTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForNormal forCellReuseIdentifier:QuestionnaireTableCellTableViewCellNibName];
    
    UINib *nibForExtend = [UINib nibWithNibName:QuestionnaireExtendTableViewCellNibName bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibForExtend forCellReuseIdentifier:QuestionnaireExtendTableViewCellNibName];
    [self.tableView reloadData];
}

// 从服务器端获取数据
- (void)getDataFromServer
{
    [self.questionnairData removeAllObjects];
    if([Common appDelegate].userArray.count == 0)
        return;
    UserModel* user =  [[Common appDelegate].userArray objectAtIndex:0];
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString *projectId = [userDefault objectForKey:@"projectId"];
    // 初始化参数
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[user.userId,projectId] forKeys:@[@"userId",@"projectId"]];
    
    
    // 请求服务器获取数据
    [self getArrayFromServer:@"" path:QuestionnaireSurveyList_Path method:@"GET" parameters:dic xmlParentNode:@"questionnaire" success:^(NSMutableArray *result) {
        for (NSDictionary *dic in result) {
            [self.questionnairData addObject:[[QuestionnaireSurvey alloc] initWithDictionary:dic]];
        }
        [self.tableView reloadData];
#pragma mark-添加提醒没有数据
        if ( self.questionnairData.count==0) {
            UIAlertView*ale=[[UIAlertView alloc]initWithTitle:@"提示" message:@"亲，当前社区没有调查活动哦~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [ale show];
//            [Common showBottomToast:@"暂时没有数据"];
        }
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}



#pragma mark - 内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
