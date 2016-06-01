//
//  JFGoodsSpecsView.h
//  CommunityApp
//
//  Created by yuntai on 16/5/11.
//  Copyright © 2016年 iss. All rights reserved.
//
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
#define MBLabelAlignmentCenter NSTextAlignmentCenter
#else
#define MBLabelAlignmentCenter UITextAlignmentCenter
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MB_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define MB_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define MB_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

#import <UIKit/UIKit.h>
#import "JFGoodsDetailModel.h"
extern CGFloat const itemHeight;
extern CGFloat const itemMargin;
@protocol JFGoodsSpecsViewDelegate;

@interface JFGoodsSpecsView : UIView

/** 具体条目信息 */
@property (nonatomic, strong) JFGoodsSpec *itemDict;

@property (nonatomic, copy) NSString *checked;

@property (nonatomic,weak)id<JFGoodsSpecsViewDelegate>delegate;
/** 点击商品属性时会请求商品库存，如果没有库存，回调isCanSelected＝NO ，相反为yes */
@property (nonatomic, assign) BOOL isCanSelected;
@end

@protocol JFGoodsSpecsViewDelegate <NSObject>

/**
 选择条目属性的方法
 @param: item:第几个条目(tag)
 @param: valueID:属性的id
 */
- (void)goodsSpecs:(JFGoodsSpecsView *)item
                   spec:(JFGoodsSpec *)spec
                    gsp:(JFGoodsGsp *)gsp;
/**
 *  没有选中当前规格 条目
 *
 *  @param item 当前规格
 */
- (void)goodsSpecSelectNone:(JFGoodsSpecsView *)item;
@end
