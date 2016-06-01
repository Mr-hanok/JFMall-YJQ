//
//  ComTableView.m
//  CommonApp
//
//  Created by lipeng on 16/3/30.
//  Copyright © 2016年 common. All rights reserved.
//

#import "ComTableView.h"
#import "MJRefresh.h"
#import "ComTableViewCell.h"
#import "ComTableViewDataSource.h"
#import "ComErrorViewManager.h"

#define CellReuseIdentifier @"Cell"

@interface ComTableView()

@property(nonatomic, strong) ComTableViewDataSource *tableDataSource;

@property(nonatomic, strong) MJRefreshNormalHeader *comHeader;
@property(nonatomic, strong) MJRefreshAutoNormalFooter *comFooter;

@end

@implementation ComTableView

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    __weak typeof(self) weakSelf = self;
    
    self.isPaging = YES;
    
    _tableDataSource = [[ComTableViewDataSource alloc] initWithItems:self.listModel.listArray cellIdentifier:CellReuseIdentifier configureCellBlock:^(UITableViewCell *cell, id item, NSIndexPath *indexPath) {
        if ([cell isKindOfClass:[ComTableViewCell class]]) {
            ComTableViewCell *comCell = (ComTableViewCell *)cell;
            comCell.indexPath = indexPath;
            comCell.item = item;
        }
        
        if (self.configureCellBlock) {
            self.configureCellBlock(cell, item, indexPath);
        }
    }];
    
    self.dataSource = _tableDataSource;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 添加下拉/上滑刷新更多
    // 顶部下拉刷出更多
    self.comHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ComErrorViewManager removeErrorViewFromView:self.superview];
        self.listModel.moreData = NO;
        [weakSelf.listModel reload];
    }];
    // 底部上拉刷出更多
    self.comFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.listModel load];
    }];
    self.comHeader.lastUpdatedTimeLabel.hidden = YES;
    
    self.listModel = [[ComListModel alloc] init];
}

- (void)setTableViewCellClass:(Class)tableViewCellClass {
    _tableViewCellClass = tableViewCellClass;
    [self registerClass:_tableViewCellClass forCellReuseIdentifier:CellReuseIdentifier];
}

- (void)setListModel:(ComListModel *)listModel {
    _listModel = listModel;
    
    __weak typeof(self) weakSelf = self;
    _listModel.successBlock = ^(id data) {
        [weakSelf loadSuccess];
    };
    
    _listModel.failedBlock = ^(NSError *error) {
        [weakSelf loadFail];
        if (weakSelf.isShowEmptyTip) {
            [ComErrorViewManager showErrorViewInView:weakSelf.superview withError:error];
        }
    };
}

- (void)reLoadDataFromServer {
    [self.listModel reload];
}

- (void)loadDataFromServer {
    [self.listModel load];
}

- (void)loadFail {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    [self reloadData];
}

- (void)loadSuccess {
    [ComErrorViewManager removeErrorViewFromView:self.superview];
    self.tableDataSource.items = self.listModel.listArray;
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    if (!self.listModel.moreData) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
    [self reloadData];
    if ([self.listModel.listArray count] == 0) {
        if (self.isShowEmptyTip) {
            [ComErrorViewManager showEmptyViewInView:self.superview];
        }
    }
}

- (void)setIsPaging:(BOOL)isPaging {
    _isPaging = isPaging;
    self.isRefresh = isPaging;
    self.isShowEmptyTip = !isPaging;
    
    self.mj_footer = _isPaging ? self.comFooter : nil;
}

- (void)setIsRefresh:(BOOL)isRefresh {
    _isRefresh = isRefresh;
    self.mj_header = _isRefresh ? self.comHeader : nil;
}


@end
