//
//  HousesDescriptionViewController.m
//  CommunityApp
//
//  Created by iss on 15/6/30.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "HousesDescriptionViewController.h"
#import "HousesDescriptionTableViewCell.h"

@interface HousesDescriptionViewController ()<UITableViewDataSource, UITableViewDelegate,HousesDescriptionTableViewCellDelegate>
{
    NSMutableArray * detailDesc;
}
@property (retain,nonatomic) IBOutlet UILabel *tipsLabel;
@property (strong,nonatomic) IBOutlet UITableView* table;
@property (nonatomic, strong) NSArray *data;
@end

@implementation HousesDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Str_HousesDescription_Title;
    [self setNavBarLeftItemAsBackArrow];
    _tipsLabel.text = Str_HousesDescription_Tips;
    detailDesc = [[NSMutableArray alloc]init];
    _data = @[@"",@"",@"",@"",@"",@""];

    [detailDesc addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"例:1990年",Str_HousesDescription_Year, nil]];
    [detailDesc addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"例:已满五年的商品房，仅有1%的契税，可直接过户",Str_HousesDescription_Detail, nil]];
    [detailDesc addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"例:南北朝向，阳光充足",Str_HousesDescription_Light, nil]];
    [detailDesc addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"例:精美装修，可拎包入住",Str_HousesDescription_Decorate, nil]];
    [detailDesc addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"例:育英小学",Str_HousesDescription_Study, nil]];
    [detailDesc addObject:[[NSMutableDictionary alloc]initWithObjectsAndKeys:@"例:360度海景",Str_HousesDescription_Spacial, nil]];
    self.table.estimatedRowHeight = 97;
    self.table.rowHeight = UITableViewAutomaticDimension;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignCurrentResponse)];
    [self.view addGestureRecognizer:tap];
//    [self.navigationController.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return detailDesc.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HousesDescriptionTableViewCell* cell = (HousesDescriptionTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        return [cell getCellHeight];
    }
    NSDictionary* dic = [detailDesc objectAtIndex:indexPath.row];
    return [HousesDescriptionTableViewCell getCellHeightByString:[dic objectForKey:[[dic allKeys] objectAtIndex:0]]];
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *housesDescriptionIndentifier = @"HousesDescriptionTableViewCell";
    HousesDescriptionTableViewCell *cell = (HousesDescriptionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:housesDescriptionIndentifier];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:housesDescriptionIndentifier owner:self options:nil]lastObject];
        //        cell = [nib objectAtIndex:0];
    }
    NSDictionary* dic = [detailDesc objectAtIndex:indexPath.row];
    if([[self.data objectAtIndex:indexPath.row] isEqualToString:@""])
    {
        [cell setTitleText:[[dic allKeys] objectAtIndex:0] DetailText:[dic objectForKey:[[dic allKeys] objectAtIndex:0]]];
    }
    else
    {
        [cell setTitleText:[[dic allKeys] objectAtIndex:0] DetailText:[self.data objectAtIndex:indexPath.row]];

    }
    cell.delegate = self;
    return cell;
}
 
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - HousesDescriptionTableViewCellDelegate
- (void)textViewCell:(HousesDescriptionTableViewCell *)cell didChangeText:(NSString *)text
{
        NSIndexPath *indexPath = [self.table indexPathForCell:cell];
        NSMutableArray *data = [self.data mutableCopy];
        data[indexPath.row] = text;
        self.data = [data copy];


}
#pragma mark --- IBAction
-(IBAction)clickOK:(id)sender
{
    if(self.selecHouseDescriptBlock)
    {
        self.selecHouseDescriptBlock(self.data);
    }
    [self.navigationController popViewControllerAnimated:TRUE];
}
#pragma mark --- other
-(void)resignCurrentResponse
{
   [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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


@end
