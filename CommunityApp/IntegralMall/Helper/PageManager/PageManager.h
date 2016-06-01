//
//  PageManager.h
//  DoctorYL
//
//  Created by 陈腾飞 on 15/11/5.
//  Copyright © 2015年 yuntai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefresh.h"

@protocol PageManagerDelegate <NSObject>

@required
/**
 *  @brief  头部刷新的回调方法，使用 [tableView.header beginRefreshing]
 */
- (void)headerRefreshing;
- (void)footerRereshing;

@optional
/**
 *  @brief  加载本地数据，规范方法名
 */
- (void)loadDataSource;
@end

@interface PageManager : NSObject

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) id<PageManagerDelegate> delegate;

+ (instancetype)handlerWithDelegate:(id<PageManagerDelegate>)delegate TableView:(UITableView *)tableView;
+ (instancetype)handlerWithDelegate:(id<PageManagerDelegate>)delegate collectionView:(UICollectionView *)collectionView;
@end
