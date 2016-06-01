//
//  QuestionContentListViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "QuestionContentListViewController.h"
#import "QuestionContentListCell.h"
#import "QuestionContentListHeadView.h"
#import "UserModel.h"
#import "MyPostWorkMode.h"
#import "QuestionnaireSurveySubjectModel.h"



@interface QuestionContentListViewController ()<UITableViewDelegate,UITableViewDataSource,QuestionContentListCellDelegate>
    @property (strong, nonatomic) IBOutlet UITableView *questioncontentTableView;
@property (assign, nonatomic) BOOL isQAStart;
@end

@implementation QuestionContentListViewController
{
    //表格分类选择数据
    NSArray * nsQuestionContentMode;
    NSMutableArray* questionDetailList;
    NSMutableDictionary* answerDic;
    
    
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    nsQuestionContentMode = @[@[@"signal",@[@"1111",@"2222",@"3333"]],@[@"signal",@[@"4444",@"5555"]],@[@"multiply",@[@"6666",@"7777",@"8888"]]];
    self.isQAStart = NO;
    
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_Question_Title;
    answerDic  = [[NSMutableDictionary alloc]init];
    questionDetailList = [[NSMutableArray alloc]init];
    [self initBasicDataInfo];
}
//导航栏左边返回箭头
- (void)navBarLeftItemBackBtnClick
{
    if (!self.isQAStart) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在进行问卷调查，是否退出" delegate:self cancelButtonTitle:@"继续调查" otherButtonTitles:@"确认退出", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        return;
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 文件域内公共方法
// 初始化基本数据
- (void)initBasicDataInfo
{
    [questionDetailList removeAllObjects];
    // 请求服务器获取周边商家数据
    [self getDataFromServer];
    
}

// 从服务器端获取数据
- (void)getDataFromServer
{
    // 初始化参数
    if([[Common appDelegate].userArray count]==0)
        return;
     UserModel* user = [[Common appDelegate].userArray objectAtIndex:0];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[user.userId,_qid] forKeys:@[@"userId",@"mpqid"]];
    
    // 请求服务器获取数据
    [self getOrignStringFromServer:@"" path:QuestionnaireSurveyDetail_Path method:@"GET" parameters:dic success:^(NSString* string){
         NSMutableArray* result =  [self getArrayFromXML:string byParentNode:@"subject"];
        for(NSDictionary* dic in result)
        {
            [questionDetailList addObject:[[QuestionnaireSurveySubjectModel alloc]initWithDictionary:dic ]];
        }
   
        for(QuestionnaireSurveySubjectModel* subject in questionDetailList)
        {
            NSString* tmp = [NSString stringWithFormat:@"%@",string];
            NSString* start = [NSString  stringWithFormat:@"<subjectId>%@</subjectId>",subject.subjectId];
            NSRange rangeStart= [tmp  rangeOfString:start];//匹配得到的下标
            tmp = [tmp substringFromIndex:rangeStart.location];//截取范围类的字符串
            NSString* end=@"</subject>";
            NSRange rangeEnd = [tmp  rangeOfString:end];//匹配得到的下标
            NSRange range;
            range.location = 0;
            range.length = rangeEnd.location;
            tmp = [tmp substringWithRange:range];
            NSString* tmpParse = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\" ?><list>\n%@</list>",tmp];
            NSMutableArray*resultEle =  [self getArrayFromXML:tmpParse byParentNode:@"element"];
             for(NSDictionary* dic in resultEle)
             {
                 [subject.elements addObject:[[QuestionnaireSurveyElementModel alloc]initWithDictionary:dic ]];
                 
             }
        }
       
        
        [self.questioncontentTableView reloadData];
        
    } failure:^(NSError *error) {
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark-table view
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.isQAStart = YES;
    QuestionContentListCell* cell = (QuestionContentListCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell clickCheckBoxByCell];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [questionDetailList count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    QuestionnaireSurveySubjectModel* subject =[ questionDetailList objectAtIndex: section];
    if (![subject.type isEqualToString:@"2"]) {
        count = subject.elements.count;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 35.0;
    
    QuestionnaireSurveySubjectModel* subject =[ questionDetailList objectAtIndex: indexPath.section];
    if ([subject.type isEqualToString:@"2"]) {
        height = 100.0;
    }
    
    return height;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identify = @"QuestionContentListCell";
    QuestionContentListCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:identify owner:self options:nil] lastObject];
    }

    QuestionnaireSurveySubjectModel* subject =[ questionDetailList objectAtIndex: indexPath.section];
    if(subject==nil) {
        return cell;
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    UIImage* img = [UIImage imageNamed:Img_Survey_CellBg];
    UIImageView* bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _questioncontentTableView.bounds.size.width, 36)];
    [bg setImage:img];
    [cell.contentView insertSubview:bg atIndex:0];
    
    if ([subject.type isEqualToString:@"2"]) {
        [cell setCellText:subject.content andType:subject.type andStatus:NO];
        cell.textChangeBlock = ^(NSString *content){
            subject.content = content;
        };
    }
    else  {
        QuestionnaireSurveyElementModel* ele = [subject.elements objectAtIndex:indexPath.row];
        if(ele==nil) {
            return cell;
        }
        [cell setCellText:ele.title andType:subject.type andStatus:ele.isSelected];
        if ([subject.type isEqualToString:@"0"]) {
            [cell setCheckBoxClickBlock:^{
                ele.isSelected = YES;
                NSInteger row = 0;
                for (QuestionnaireSurveyElementModel *elem in subject.elements) {
                    if (elem != ele) {
                        elem.isSelected = NO;
                        QuestionContentListCell *radioCell = (QuestionContentListCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
                        [radioCell.check1 setSelected:NO];
                    }
                    row++;
                }
            }];
        }else if ([subject.type isEqualToString:@"1"]) {
            [cell setCheckBoxClickBlock:^{
                ele.isSelected = YES;
            }];
        }
    }


    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    QuestionContentListHeadView* ListHead = [[QuestionContentListHeadView alloc]initWithFrame:CGRectMake(0, 0, _questioncontentTableView.bounds.size.width, 40)];
    
    QuestionnaireSurveySubjectModel* subject =[ questionDetailList objectAtIndex: section];

    
    NSString* title = [NSString stringWithFormat:@"%ld.%@",section+1,subject.title];
    [ListHead setTitleText:title];
    return ListHead;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* bottom=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _questioncontentTableView.bounds.size.width, 40)];
    [bottom setBackgroundColor:[UIColor clearColor]];
    UIImage* img = [UIImage imageNamed:Img_Survey_Bottom];
    UIImageView* bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _questioncontentTableView.bounds.size.width, 20)];
    [bg setImage:img];
    [bottom addSubview:bg ];
    return bottom;
}



#pragma mark--checkbox delegate

-(void)cellSelect:(QuestionContentListCell*)cell
{
    self.isQAStart = YES;
    NSIndexPath *index = [_questioncontentTableView indexPathForCell:cell];
    QuestionnaireSurveySubjectModel* subject =[ questionDetailList objectAtIndex: index.section];
    for(int row = 0;row<subject.elements.count;row++)
    {
        if( row !=  index.row)
        {
            NSIndexPath *index1 =  [NSIndexPath indexPathForItem:row inSection:index.section];
           
            QuestionContentListCell *cell1 =  (QuestionContentListCell*)[_questioncontentTableView cellForRowAtIndexPath:index1];
            [cell1 setCheckStatus:FALSE];
        }
    }
}
#pragma mark---IBAction
//🍎
//提交－－－改：1、用户填写用户调查问卷，不判断用户是否填写个人信息，直接进行答题环节
//2、提交结果表单时，判断用户是否填写个信信息，如果填写，将姓名、电话带到表单，如果没填写，表单中姓名、电话字段为空（将‘我‘的个人资料－个人信息中的姓名和电话提交服务器）
#pragma -mark *生产环境*只答一题点击‘提交’闪退

-(IBAction) commitClick:(id)sender
{
    if([[Common appDelegate].userArray count]==0)
        return;
    [self parseAnswerToDic];
    
    if(questionDetailList.count != answerDic.count){
        [Common showBottomToast:@"问卷回答不完整"];
        return;
    }
    UserModel* user = [[Common appDelegate].userArray objectAtIndex:0];
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    NSMutableDictionary* jsonObj = [self toJsonDataObject:answerDic];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj options:0 error:nil];
    NSString * questContent = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //🍎参数是不是nil校验一遍
    //NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[user.userId,_qid,_investigatorTel,_investigatorName,questContent,date] forKeys:@[@"userId",@"questId",@"phone",@"userName",@"questContent",@"questDate"]];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[Common vaildString:user.userId],[Common vaildString:_qid],[Common vaildString:_investigatorTel],[Common vaildString:_investigatorName],[Common vaildString:questContent],[Common vaildString:date]] forKeys:@[@"userId",@"questId",@"phone",@"userName",@"questContent",@"questDate"]];
    

    //🍎
    
    
    // 请求服务器获取数据
    [self getArrayFromServer:@"" path:QuestionnaireSurveySave_Path parameters:dic xmlParentNode:@"result" success:^(NSMutableArray* result) {
        for (NSDictionary* dic in result){
            NSString* flag = [dic objectForKey:@"flag"];
            if ([flag isEqualToString:@"1"]) {
                [self.navigationController popToRootViewControllerAnimated:TRUE];
                // 问卷提交成功
                [Common showBottomToast:@"问卷提交成功"];
            }
            else {
                //
                [self.navigationController popToRootViewControllerAnimated:TRUE];
                // 问卷提交内容不完整
                [Common showBottomToast:@"问卷提交失败"];
            }
        }
    } failure:^(NSError *error) {
        // 问卷提交超时
        [Common showBottomToast:Str_Comm_RequestTimeout];
    }];
    

}

#pragma mark-other
-(NSMutableDictionary*) toJsonDataObject:(NSMutableDictionary*)dic
{
    NSMutableDictionary* result = [[NSMutableDictionary alloc]init];
   
    for(id key in dic)
    {
         NSMutableString* valueString  ;
        id value = [dic objectForKey:key];

       
        if ([value isKindOfClass:[NSArray class]])
        {
            
                for (NSString* string in value ) {
                    if(valueString==nil)
                    {
                        valueString = [NSMutableString stringWithFormat:@"%@",string];
                    }
                    else
                    {
                        [valueString appendFormat:@",%@",string];
                    }
                }
        }
        else
            valueString = [NSMutableString stringWithFormat:@"%@",value];

         [result setObject:valueString forKey:key];
    }
    return result;
    
}
-(void)parseAnswerToDic
{
    [answerDic removeAllObjects];
//    NSIndexPath* indexPath ;
    NSInteger  j=0;
    for(NSInteger i=0;i<[questionDetailList count];i++)
    {
        QuestionnaireSurveySubjectModel* subject =  [questionDetailList objectAtIndex:i];
        j=0;
        NSInteger count = 0;
        if ([subject.type isEqualToString:@"1"] || [subject.type isEqualToString:@"0"]) {
            count = [subject.elements count];
        }else if ([subject.type isEqualToString:@"2"]) {
            count = 1;
        }
        
       for(NSInteger j=0;j<count;j++)
        {
//            indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            if ([subject.type isEqualToString:@"2"]) {
                NSString *newContent;
                if(![subject.content isEqual:nil]){
                    newContent = subject.content;
                }else{
                    newContent = @"";
                }
                [answerDic setObject:newContent forKey:subject.subjectId];
            }else {
                QuestionnaireSurveyElementModel *elm  = [subject.elements objectAtIndex:j];
                
                if([subject.type isEqualToString:@"0"] && elm.isSelected)//单选
                {
                    [answerDic setObject:[NSString stringWithFormat:@"%@",elm.elementId] forKey:subject.subjectId];
                }
                else if ([subject.type isEqualToString:@"1"] && elm.isSelected) //复选
                {
                    NSMutableArray* answers = [answerDic objectForKey:subject.subjectId];
                    if(answers==nil)
                    {
                        answers = [[NSMutableArray alloc]init];
                        [answerDic setObject:answers forKey:subject.subjectId];
                    }
                    if([answers containsObject:elm.elementId] == FALSE)
                    {
                        [answers addObject:elm.elementId];
                    }
                }
            }
        }
    }
}



#pragma mark - 键盘显示、隐藏事件处理函数重写
- (void)keyboardDidShow:(NSNotification *)notification
{
    [super keyboardDidShow:notification];
    _questioncontentTableView.contentOffset = CGPointMake(0, self.keyboardHeight);
}

- (void)keyboardDidHide
{
    _questioncontentTableView.contentOffset = CGPointMake(0, 0);
    [super keyboardDidHide];
}



@end
