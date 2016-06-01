//
//  JFIntegralRuleCell.h
//  CommunityApp
//
//  Created by yuntai on 16/5/6.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFIntegralRuleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@property (nonatomic, strong) NSIndexPath *indexPath;
+ (JFIntegralRuleCell *)tableView:(UITableView *)tableView cellForRowInTableViewIndexPath:(NSIndexPath *)indexPath;
- (void)configCellWithDic:(NSDictionary *)dic;
+ (CGFloat)heightOfCellWithText:(NSString *)str;
@end
