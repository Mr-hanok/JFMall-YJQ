//
//  PropertyBillTableViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/6/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "PropertyBillTableViewCell.h"



@interface PropertyBillTableViewCell()
@property (retain, nonatomic) IBOutlet UILabel *month;
@property (retain, nonatomic) IBOutlet UILabel *year;

@property (retain, nonatomic) IBOutlet UILabel *cost;
@property (retain, nonatomic) IBOutlet UILabel *unpay;
@property (retain, nonatomic) IBOutlet UIView *unpayImgView;
@property (retain, nonatomic) IBOutlet UIImageView *topLeftLineImgView;
@property (retain, nonatomic) IBOutlet UIImageView *bottomLeftLineImgView;
@property (retain, nonatomic) IBOutlet UIImageView *topRightLineImgView;
@property (retain, nonatomic) IBOutlet UIImageView *bottomRightLineImgView;
@property (retain, nonatomic) IBOutlet UIView *contentBgView;
@property (retain, nonatomic) IBOutlet UILabel *unPayMarkLabel;

@end

@implementation PropertyBillTableViewCell

- (void)awakeFromNib {
    
    self.contentBgView.layer.borderWidth = 1.0;
    self.contentBgView.layer.borderColor = COLOR_RGB(220, 220, 220).CGColor;
    self.contentBgView.layer.cornerRadius = 3.0;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
// 加载Cell模型数据
- (void)loadCellModelData:(BillListModel *)model byCellType:(eCellType)type
{

    [self.cost setText:model.fiName];
    [self.unpay setText:model.receivable];
    NSRange rang={0,2};
    
    [self.month setText:[model.billDate substringWithRange:rang]];
    NSRange rang2 = {2,5};
    [self.year setText:[NSString stringWithFormat:@"%@",[model.billDate substringWithRange:rang2]]];
    
    if (type == E_Cell_First) {
        self.topLeftLineImgView.hidden = YES;
        self.topRightLineImgView.hidden = YES;
        self.bottomLeftLineImgView.hidden = NO;
        self.bottomRightLineImgView.hidden = NO;
    }
    else if (type == E_Cell_Last) {
        self.bottomLeftLineImgView.hidden = YES;
        self.bottomRightLineImgView.hidden = YES;
        self.topLeftLineImgView.hidden = NO;
        self.topRightLineImgView.hidden = NO;
    }
    else {
        self.topLeftLineImgView.hidden = NO;
        self.topRightLineImgView.hidden = NO;
        self.bottomLeftLineImgView.hidden = NO;
        self.bottomRightLineImgView.hidden = NO;
    }
    if([model.billType isEqualToString:@"1"])
    {
        [_unPayMarkLabel setText:@"已交"];
    }
    else
    {
        [_unPayMarkLabel setText:@"未交"];
    }
}


// 加载Cell数据
- (void)loadCellData:(NSArray *)array byCellType:(eCellType)type
{
    [self.cost setText:[array objectAtIndex:1]];
    
    if (type == E_Cell_First) {
        self.topLeftLineImgView.hidden = YES;
        self.topRightLineImgView.hidden = YES;
        self.bottomLeftLineImgView.hidden = NO;
        self.bottomRightLineImgView.hidden = NO;
    }
    else if (type == E_Cell_Last) {
        self.bottomLeftLineImgView.hidden = YES;
        self.bottomRightLineImgView.hidden = YES;
        self.topLeftLineImgView.hidden = NO;
        self.topRightLineImgView.hidden = NO;
    }
    else {
        self.topLeftLineImgView.hidden = NO;
        self.topRightLineImgView.hidden = NO;
        self.bottomLeftLineImgView.hidden = NO;
        self.bottomRightLineImgView.hidden = NO;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
