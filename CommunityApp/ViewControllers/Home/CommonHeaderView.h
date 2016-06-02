//
//  CommonHeaderView.h
//  CommunityApp
//
//  Created by issuser on 15/6/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SectionBtnClickBlock)(void);

@interface CommonHeaderView : UICollectionReusableView
 

/* 加载Header数据
 * @parameter:array 第一个值为左侧图片名，第二值为右侧Normal图片名，第三个值为右侧Highlight图片名
 */
- (void)loadHeaderData:(NSArray *)array;


/* 注册SectionHeader右侧箭头按钮的点击事件回调函数
 * @parameter:block 按钮点击事件Block
 */
- (void)registBtnClickCallBack:(SectionBtnClickBlock)block;

@end
