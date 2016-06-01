//
//  UserfulTelNoCellTableViewCell.m
//  CommunityApp
//
//  Created by iss on 15/6/15.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "UserfulTelNoCellTableViewCell.h"
#import "ConnectMode.h"

@interface UserfulTelNoCellTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *telNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailAddressLabel;
@end

@implementation UserfulTelNoCellTableViewCell

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

/**
 * 加载数据
 */
-(void) loadCellData:(ConnectMode *)connectMode
{
    [_addressLabel setText:connectMode.address];
    [_telNoLabel setText:connectMode.telNo];
    if([connectMode.detailAddress  isEqual: @""]){
        [_detailAddressLabel setText:@"广州市天河区天河北路"];
    }
    else
    {
        [_detailAddressLabel setText:connectMode.detailAddress];
    }
    
}
//办事通cell右边的电话，客拨号
- (IBAction)clickCallHotLine:(id)sender {
    if(self.dialCallHotLine){
        self.dialCallHotLine();
    }
}

@end
