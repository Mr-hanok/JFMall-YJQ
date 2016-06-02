//
//  JFOrederFollowCell.h
//  CommunityApp
//
//  Created by yuntai on 16/5/4.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFOrederFollowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIView *upLine;
@property (weak, nonatomic) IBOutlet UIImageView *stateImageIV;
@property (weak, nonatomic) IBOutlet UIView *downLine;

@property (nonatomic, strong) NSIndexPath *indexPath;
+ (JFOrederFollowCell *)tableView:(UITableView *)tableView cellForRowInTableViewIndexPath:(NSIndexPath *)indexPath;

- (void)configCellWith:(NSDictionary *)dic;
+ (CGFloat)heightOfCellWithText:(NSString *)str;
@end
