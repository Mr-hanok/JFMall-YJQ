//
//  PageManager.m
//  DoctorYL
//
//  Created by 陈腾飞 on 15/11/5.
//  Copyright © 2015年 yuntai. All rights reserved.
//

#import "PageManager.h"

@implementation PageManager

+ (instancetype)handlerWithDelegate:(id<PageManagerDelegate>)delegate TableView:(UITableView *)tableView {
    
    PageManager *pageHandler = [[PageManager alloc] init];
    pageHandler.delegate = delegate;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (tableView.mj_footer.state == MJRefreshStateRefreshing) {
            [tableView.mj_header endRefreshing];
        } else {
            [delegate headerRefreshing];
        }
    }];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (tableView.mj_header.state == MJRefreshStateRefreshing) {
            [tableView.mj_footer endRefreshing];
        } else {
            [delegate footerRereshing];
        }
    }];
    
//    tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:delegate refreshingAction:@selector(headerRefreshing)];
//    tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:delegate refreshingAction:@selector(footerRereshing)];
    return pageHandler;
}

+ (instancetype)handlerWithDelegate:(id<PageManagerDelegate>)delegate collectionView:(UICollectionView *)collectionView {
    
    PageManager *pageHandler = [[PageManager alloc] init];
    pageHandler.delegate = delegate;
    
    collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (collectionView.mj_footer.state == MJRefreshStateRefreshing) {
            [collectionView.mj_header endRefreshing];
        } else {
            [delegate headerRefreshing];
        }
    }];
    
    collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (collectionView.mj_header.state == MJRefreshStateRefreshing) {
            [collectionView.mj_footer endRefreshing];
        } else {
            [delegate footerRereshing];
        }
    }];
    
    return pageHandler;
}

#pragma mark - getters & setters
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
