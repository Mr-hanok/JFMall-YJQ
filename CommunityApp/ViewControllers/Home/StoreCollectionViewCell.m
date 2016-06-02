//
//  StoreCollectionViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/6/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "StoreCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface StoreCollectionViewCell()
@property (retain, nonatomic) IBOutlet UIImageView *icon;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *price;
@property (retain, nonatomic) IBOutlet UILabel *saleCount;
@property (retain, nonatomic) IBOutlet UIView *bottomLineView;

@property (retain, nonatomic) IBOutlet UIImageView *horizonLineImg;
@property (retain, nonatomic) IBOutlet UIImageView *verticalLineImg;
@end

@implementation StoreCollectionViewCell

- (void)awakeFromNib {
    self.bottomLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottomDottedLine"]];
}

// 装载Cell数据
- (void)loadCellData:(WaresList *)model byIsHomeView:(BOOL)isHome forCellId:(NSInteger)cellId andTotalCount:(NSInteger)count
{
    NSURL *iconUrl = [NSURL URLWithString:[Common setCorrectURL:model.goodsUrl]];
    [self.icon setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:Img_Comm_DefaultImg]];
    [self.name setText:model.goodsName];
    [self.price setText:[NSString stringWithFormat:@"￥%@",model.goodsActualPrice]];
    [self.saleCount setText:[NSString stringWithFormat:@"￥%@",model.goodsPrice]];
    
    if (isHome) {
        if (cellId == 3 || cellId == 8) {
            self.verticalLineImg.hidden = YES;
        }
        else {
            self.verticalLineImg.hidden = NO;
        }
        if (count <= 3) {
            self.bottomLineView.hidden = YES;
        }else {
            if (cellId >=6 && cellId<= 8) {
                self.bottomLineView.hidden = YES;
            }
            else {
                self.bottomLineView.hidden = NO;
            }
        }
    }else {
        if (count <= 3) {
            self.bottomLineView.hidden = YES;
            if (cellId == 2) {
                self.verticalLineImg.hidden = YES;
            }
            else {
                self.verticalLineImg.hidden = NO;
            }
        }else {
            if (cellId == 2) {
                self.verticalLineImg.hidden = YES;
            }else if (cellId > 2 && ((cellId+1)%3 == 0)) {
                self.verticalLineImg.hidden = YES;
            }else {
                self.verticalLineImg.hidden = NO;
            }
            NSInteger totalLines = count/3 + 1;
            NSInteger currentLine = cellId/3 + 1;
            if (currentLine == totalLines) {
                self.bottomLineView.hidden = YES;
            }else {
                self.bottomLineView.hidden = NO;
            }
        }
    }

}


@end
