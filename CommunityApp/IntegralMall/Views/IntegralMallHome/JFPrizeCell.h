//
//  JFPrizeCell.h
//  CommunityApp
//
//  Created by yuntai on 16/6/2.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JFPrizeModel.h"
/**积分奖品cell*/
@interface JFPrizeCell : UITableViewCell

/**cell1*/

@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *time1Label;
@property (weak, nonatomic) IBOutlet UIButton *state1Btn;


/**cell2*/
@property (weak, nonatomic) IBOutlet UIImageView *imageIV;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsSpecLabel;
@property (weak, nonatomic) IBOutlet UILabel *time2Label;
@property (weak, nonatomic) IBOutlet UIButton *state2Btn;


@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic, strong) JFPrizeModel *model;
@property (nonatomic, copy) void (^callBackPrize)(NSString *pid,NSString *type);

+ (JFPrizeCell *)tableView:(UITableView *)tableView cellForRowInTableViewIndexPath:(NSIndexPath *)indexPath prize_type:(NSString *)prize_type;
+ (CGFloat)cellHeigthWithModel:(JFPrizeModel *)model;
- (void)configCellWithModel:(JFPrizeModel *)model;
@end
