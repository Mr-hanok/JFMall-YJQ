//
//  ComScrollView.h
//  CommonApp
//
//  Created by lipeng on 16/4/13.
//  Copyright © 2016年 common. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComModel.h"

@interface ComScrollView : UIScrollView

@property(nonatomic, strong) ComModel*      model;
@property(nonatomic,   copy) SuccessBlock   loadSuccessBlock;

@property(nonatomic, assign) BOOL           isRefresh;
@property(nonatomic, assign) BOOL           isShowEmptyTip;

- (void)reLoadDataFromServer;

@end
