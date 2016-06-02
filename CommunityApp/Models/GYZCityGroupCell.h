//
//  GYZCityGroupCell.h
//  GYZChooseCityDemo
//
//  Created by wito on 15/12/29.
//  Copyright © 2015年 gouyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYZCity.h"
#import "GYZChooseCityDelegate.h"


#define     MIN_SPACE           8           // 城市button最小间隙
#define     MAX_SPACE           10

#define     WIDTH_LEFT          20        // button左边距
#define     WIDTH_RIGHT         28          // button右边距

#define     MIN_WIDTH_BUTTON    180
#define     HEIGHT_BUTTON       38

@interface GYZCityGroupCell : UITableViewCell
@property (nonatomic,assign) id <GYZCityGroupCellDelegate> delegate;
//已定位项目前图标
@property (nonatomic, strong) UIImageView *locationImg;
//刷新按钮
@property (nonatomic, strong) UIButton *refreshBtn;
//无数据时叹号图标
@property (nonatomic ,strong) UIImageView * warnImg;
/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  暂无数据
 */
@property (nonatomic, strong) UILabel *noDataLabel;
/**
 *  btn数组
 */
@property (nonatomic, strong) NSMutableArray *arrayCityButtons;
/**
 *  lab数组
 */
@property (nonatomic, strong) NSMutableArray *arrayCityLabels;
/**
 *  城市数据信息
 */
@property (nonatomic, strong) NSArray *cityArray;
/**
 *  返回cell高度
 *
 *  @param cityArray cell的数量
 *
 *  @return 返回cell高度
 */
+ (CGFloat) getCellHeightOfCityArray:(NSArray *)cityArray;
@end
