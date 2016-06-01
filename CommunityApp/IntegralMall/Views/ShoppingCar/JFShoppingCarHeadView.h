//
//  JFShoppingCarHeadView.h
//  CommunityApp
//
//  Created by yuntai on 16/4/26.
//  Copyright © 2016年 iss. All rights reserved.
//
@class JFShoppingCarHeadView;
@protocol JFShoppingCarHeadViewDelegate <NSObject>

-(void)shoppingCarHeadView:(JFShoppingCarHeadView *)headview selectBtn:(UIButton *)btn;
-(void)shoppingCarHeadView:(JFShoppingCarHeadView *)headview shopNameBtn:(UIButton *)btn;

@end
#import <UIKit/UIKit.h>
#import "JFStoreInfoMode.h"
/**
 *  购物车headview
 */
@interface JFShoppingCarHeadView : UITableViewHeaderFooterView

@property (nonatomic,weak)id<JFShoppingCarHeadViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *nameBtn;
- (void)instHeadviewWithSection:(NSInteger)section storeModel:(JFStoreInfoMode *)store;
@end
