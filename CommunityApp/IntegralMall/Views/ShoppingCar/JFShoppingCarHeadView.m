//
//  JFShoppingCarHeadView.m
//  CommunityApp
//
//  Created by yuntai on 16/4/26.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFShoppingCarHeadView.h"

@implementation JFShoppingCarHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)instHeadviewWithSection:(NSInteger)section storeModel:(JFStoreInfoMode *)store{
    self.selectBtn.tag = section;
    self.nameBtn.tag = section;
    self.selectBtn.selected = store.isSelect;
    NSString *name = store.storeName;
    [self.nameBtn setTitle:name forState:UIControlStateNormal];
}
- (IBAction)shopnameBtnClick:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(shoppingCarHeadView:shopNameBtn:)]) {
        [_delegate shoppingCarHeadView:self shopNameBtn:sender];
    }
    
}
- (IBAction)selectBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([_delegate respondsToSelector:@selector(shoppingCarHeadView:selectBtn:)]) {
        [_delegate shoppingCarHeadView:self selectBtn:sender];
    }

}

@end
