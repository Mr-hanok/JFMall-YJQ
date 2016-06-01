//
//  RoadManageCellTableViewCell.m
//  CommunityApp
//
//  Created by iss on 15/6/10.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "RoadManageCellTableViewCell.h"

@interface RoadManageCellTableViewCell()

//@property (nonatomic, strong) IBOutlet UIButton *myButton;
//@property (nonatomic, strong) IBOutlet UILabel *neighborhoodAddressLable;
//@property (nonatomic, strong) IBOutlet UILabel *neighborhoodNameLable;
@end

@implementation RoadManageCellTableViewCell

- (void)awakeFromNib
{
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];    
}

// 加载Cell数据
- (void)loadCellData:(RoadData *)roadData isModify:(BOOL) isModify
{
    if(roadData.projectName == nil || [roadData.projectName isEqualToString:@""])
         [self.neighborhoodNameLable setText:@"(无项目)"];
    else
        [self.neighborhoodNameLable setText:roadData.projectName];
    [self.neighborhoodAddressLable setText:roadData.address];
    if(roadData.contactName != nil && roadData.contactTel != nil)
        [_contactLabel setText:[NSString stringWithFormat:@"%@    %@",roadData.contactName,roadData.contactTel]];
 
    if (roadData.authen.length == 0) {
        self.authenticationLabel.hidden = YES;
    }
    else{
        self.authenticationLabel.hidden = NO;
        if (roadData.authen!=nil && [roadData.authen isEqualToString:@"1"])//已认证
        {
            //        NSString *title =[[NSString alloc] initWithString:[NSString stringWithFormat:@"%@(已认证)",roadData.projectName]];
            //        NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:title];
            //        NSRange range1;
            //        // range1 = NSMakeRange(0, [price length]+1);//通过NSRange来划分片段
            //        range1 = NSMakeRange([roadData.projectName length], [title length]-[roadData.projectName length]);
            //        UIColor* color1 = COLOR_RGB(235, 114, 25);
            //        [string addAttribute:NSForegroundColorAttributeName value:color1 range:range1];//给不同的片段设置不同的颜色
            //        [self.neighborhoodNameLable setAttributedText:string];
            [self.authenticationLabel setText:@"(已认证)"];
            [self.authenticationLabel setHidden:NO];
        }else if (roadData.authen!=nil && [roadData.authen isEqualToString:@"2"]) { //认证中
            [self.authenticationLabel setText:@"(待认证)"];
            [self.authenticationLabel setHidden:NO];
        }
        //已拒绝
        else if (roadData.authen!=nil && [roadData.authen isEqualToString:@"3"]) {
            [self.authenticationLabel setText:@"(已拒绝)"];
            [self.authenticationLabel setHidden:NO];
        }
        //已取消
        else if (roadData.authen!=nil && [roadData.authen isEqualToString:@"4"]) {
            [self.authenticationLabel setText:@"(已取消)"];
            [self.authenticationLabel setHidden:NO];
        }
        else{
            [self.authenticationLabel setHidden:YES];
        }
    }
    if (isModify == FALSE) {
        _setDefaultBtnWidth.constant = 0;
        [self.myButton setHidden:YES];
    }
    else
    {
        if ([roadData.isDefault isEqualToString:@"1"])
        {
            [self.myButton setTitle:@"默认" forState:UIControlStateNormal];
            [self.myButton setTitleColor:[UIColor colorWithRed:113.0/255 green:113.0/255 blue:113.0/255  alpha:1] forState:UIControlStateNormal];
            self.myButton.enabled = FALSE;
            [self.myButton setTitleColor:[UIColor colorWithRed:113.0/255 green:113.0/255 blue:113.0/255  alpha:1] forState:UIControlStateDisabled];
            [self.myButton setBackgroundImage:nil forState:UIControlStateNormal];
        }
        
        if ([roadData.isDefault isEqualToString:@"2"])
        {
            self.myButton.enabled =     TRUE;
            [self.myButton setTitle:@"设为默认" forState:UIControlStateNormal];
            [self.myButton setTitleColor:[UIColor orangeColor]forState:UIControlStateNormal];
            [self.myButton setBackgroundImage:[UIImage imageNamed:@"AddressRoadUnselect"] forState:UIControlStateNormal];
            [self.myButton setBackgroundImage:[UIImage imageNamed:@"AddressRoadSelected"] forState:UIControlStateHighlighted];
        }

        [self.myButton setHidden:NO];

        }
}

@end
