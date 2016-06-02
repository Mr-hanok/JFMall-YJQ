//
//  ComTestController.m
//  CommunityApp
//
//  Created by lipeng on 16/4/11.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "ComTestController.h"

#import "BookListModel.h"
#import "BookModel.h"
#import "BookTableViewCell.h"
#import "ComTableView.h"
#import "ComScrollView.h"

@interface ComTestController ()

@property(nonatomic, strong) BookModel *bookModel;
@property(nonatomic, strong) BookListModel *bookListModel;
@property(nonatomic, strong) ComTableView *table;
@property(nonatomic, strong) ComScrollView *scrollView;


@end

@implementation ComTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavBarLeftItemAsBackArrow];
    
    [self buildView];
    
    
//    self.bookModel = [[BookModel alloc] init];
//    [self.bookModel loadOnSuccess:^(BookModel *model) {
//
//    } onFailed:^(NSError *error) {
//
//    }];
//
//    self.bookListModel = [[BookListModel alloc] init];
//    [self.bookListModel loadOnSuccess:^(id data) {
//
//    } onFailed:^(NSError *error) {
//        
//    }];
}

- (void)buildView {
    [self.view addSubview:self.table];
//    self.table.isPaging = NO;
//    self.table.isShowEmptyTip = NO;
//    self.table.isRefresh = YES;
    self.table.listModel = [[BookListModel alloc] init];
    self.table.tableViewCellClass = [BookTableViewCell class];
    self.table.configureCellBlock = ^(UITableViewCell *cell, BookModel *item, NSIndexPath *indexPath) {
        cell.textLabel.text = item.title;
        cell.textLabel.textColor = TEXT_DEFAULT_COLOR_BLACK;
    };
    [self.table reLoadDataFromServer];
    
    
//    [self.view addSubview:self.scrollView];
//    self.scrollView.model = [[BookModel alloc] init];
////    self.scrollView.isShowEmptyTip = NO;
////    self.scrollView.isRefresh = NO;
//    self.scrollView.loadSuccessBlock = ^(BookModel *model){
//        
//    };
//    [self.scrollView reLoadDataFromServer];
    
    
    [self showHUDWithMessage:@"aaa"];
}

- (ComTableView *)table {
    if (!_table) {
        _table = [ComTableView newAutoLayoutView];
    }
    return _table;
}

- (ComScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [ComScrollView newAutoLayoutView];
    }
    return _scrollView;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    [self.table autoPinEdgesToSuperviewEdges];
//    [self.scrollView autoPinEdgesToSuperviewEdges];
}

@end
