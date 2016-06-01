//
//  StoreListCollectionViewCell.m
//  CommunityApp
//
//  Created by issuser on 15/6/7.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "StoreListCollectionViewCell.h"

@interface StoreListCollectionViewCell()
@property (retain, nonatomic) IBOutlet UIImageView *icon;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *telno;
@property (retain, nonatomic) IBOutlet UIView *bottomLineView;

@end


@implementation StoreListCollectionViewCell

- (void)awakeFromNib {
    self.bottomLineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottomDottedLine"]];
}


// 装载Cell数据
- (void)loadCellData:(NSArray *)array
{
    
    [self.icon setImage:[UIImage imageNamed:[array objectAtIndex:0]]];
    [self.name setText:[array objectAtIndex:1]];
    [self.telno setText:[array objectAtIndex:2]];
}

@end
