//
//  CommonFilterDataView.h
//  CommunityApp
//
//  Created by iss on 7/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommonFilterDataView;

@protocol CommonFilterDataViewDelegate<NSObject>
-(void) FilterTableData:(CommonFilterDataView*) dataView filter:(NSArray*)filter;
@end

@interface CommonFilterDataView : UIView
@property (nonatomic,assign) id<CommonFilterDataViewDelegate>delegate;
-(void) initFilterTitle:(NSArray*)filterTitle;
-(void) setFilterTitle:(NSInteger)tag title:(NSString*)title;
@end
