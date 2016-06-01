//
//  ComScrollView.m
//  CommonApp
//
//  Created by lipeng on 16/4/13.
//  Copyright © 2016年 common. All rights reserved.
//

#import "ComScrollView.h"
#import "MJRefreshNormalHeader.h"
#import "ComErrorViewManager.h"
#import "UIScrollView+MJRefresh.h"

@interface ComScrollView ()

@property(nonatomic, strong) MJRefreshStateHeader *comHeader;

@end

@implementation ComScrollView

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
    self.scrollEnabled = YES;
    self.isShowEmptyTip = YES;
    self.isRefresh = YES;
    
    __weak typeof(self) weakSelf = self;
    self.comHeader = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [ComErrorViewManager removeErrorViewFromView:self.superview];
        [weakSelf.model load];
    }];
    self.comHeader.lastUpdatedTimeLabel.hidden = YES;
    
    self.model = [[ComModel alloc] init];
}

- (void)setModel:(ComModel *)model {
    _model = model;
    
    __weak typeof(self) weakSelf = self;
    _model.successBlock = ^(id data) {
        [weakSelf loadSuccess];
    };
    
    _model.failedBlock = ^(NSError *error) {
        [weakSelf loadFail];
        if (weakSelf.isShowEmptyTip) {
            [ComErrorViewManager showErrorViewInView:weakSelf.superview withError:error];
        }
    };
}

- (void)reLoadDataFromServer {
    [self.model load];
}

- (void)loadFail {
    [self.mj_header endRefreshing];
}

- (void)loadSuccess {
    [ComErrorViewManager removeErrorViewFromView:self.superview];
    [self.mj_header endRefreshing];
    if (self.loadSuccessBlock) {
        self.loadSuccessBlock(self.model);
    }
}

- (void)setIsRefresh:(BOOL)isRefresh {
    _isRefresh = isRefresh;
    self.mj_header = _isRefresh ? self.comHeader : nil;
}

@end
