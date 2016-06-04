//
//  JFGoodsSpecsView.m
//  CommunityApp
//
//  Created by yuntai on 16/5/11.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "JFGoodsSpecsView.h"
#import "JFGoodsDetailModel.h"

CGFloat const itemHeight = 43;//  每一行高是43；
CGFloat const itemMargin = 20;

@interface JFGoodsSpecsView ()
{
    UILabel *titleLabel;
}
@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation JFGoodsSpecsView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isCanSelected = YES;
        self.buttons = @[].mutableCopy;
        [self setTitleLabel];
    }
    
    return self;
}

- (void)setTitleLabel
{
    titleLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.bounds.size.width, itemHeight)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = 0;
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textColor = HEXCOLOR(0x4a4a4a);
        label;
    });
    [self addSubview:titleLabel];
}

- (void)setItemDict:(JFGoodsSpec *)itemDict
{
    if (_itemDict != itemDict) {
        _itemDict = itemDict;
        
        // 设置标题
        titleLabel.text = _itemDict.name;
        CGSize titlesize = MB_TEXTSIZE(_itemDict.name, [UIFont systemFontOfSize:15.0f]);
        titleLabel.frame = CGRectMake(15, 0, titlesize.width, itemHeight);
        
        // 设置选择项
        if ( [_itemDict.gsps count]>0) {
            
            NSArray *attrValueInfos = [_itemDict.gsps copy];
            
            CGFloat sideMargin = 92;
            CGFloat alreadyWidth = 0;
            CGFloat topMargin = 10;
            NSInteger line = 0;
            CGFloat limitWidth = self.bounds.size.width - sideMargin;
            
            for (int i=0; i<attrValueInfos.count; i++) {
                
                // 当前属性文字宽度
                JFGoodsGsp *gsp = attrValueInfos[i];
                NSString *attrStr = gsp.value;
                CGSize curItemSize = MB_TEXTSIZE(attrStr, [UIFont systemFontOfSize:20.0f]);
                curItemSize = CGSizeMake(curItemSize.width<50 ? 50 : curItemSize.width, curItemSize.height);// 限定字符的宽度，如果是单个字符，不容易触摸。
                
                if ((alreadyWidth + curItemSize.width) > limitWidth) {
                    alreadyWidth = 0;
                    line ++;
                }
                
                CGFloat y = topMargin + line * 40;
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(sideMargin + alreadyWidth, y, curItemSize.width, 23);
                [button setTitle:attrStr forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                [button setTitleColor:HEXCOLOR(0x4a4a4a) forState:UIControlStateNormal];
                [button setTitleColor:HEXCOLOR(0xEA7E36) forState:UIControlStateSelected];
                
                UIImage *image = [UIImage imageNamed:@"jf-goodstypenormal"];
                image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
                [button setBackgroundImage:image forState:UIControlStateNormal];
                
                UIImage *imageSel = [UIImage imageNamed:@"jf-goodstype"];
                imageSel = [imageSel stretchableImageWithLeftCapWidth:floorf(imageSel.size.width/2) topCapHeight:floorf(imageSel.size.height/2)];
                [button setBackgroundImage:imageSel forState:UIControlStateSelected];
        
                button.tag = 1000 + i;
                [button addTarget:self action:@selector(selectionAction:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
                
                // 默认选中的状态，可以重新
                JFGoodsGsp *p = attrValueInfos[i];
                if ([_itemDict.checked  isEqualToString:p.gspId]) {
                    button.selected = YES;
                } else {
                    button.selected = NO;
                }
                
                [self.buttons addObject:button];
                
                alreadyWidth += itemMargin + button.frame.size.width;
            }
            
            self.height = (line + 1) * 44 ; // 多出一行，再加上项部距离
        }
    }
}

- (void)selectionAction:(UIButton *)sender
{
    if (sender.selected) return;
    
    sender.selected = !sender.selected;
    NSNumber *valueId;
    if ( [_itemDict.gsps count]>0) {
        JFGoodsGsp *gsp = _itemDict.gsps[sender.tag-1000];
        valueId = [gsp.gspId copy];
        self.checked = gsp.gspId;
        _itemDict.checked = gsp.gspId;
    }
    
    for (UIButton *btn in self.buttons) {
        if (btn ==sender) {
            
        }else{
            if (btn.selected) {
                btn.selected = NO;
            }
        }
    }
    // responds the delegate method
    if (sender.selected) {
        if ([self.delegate respondsToSelector:@selector(goodsSpecs:spec:gsp:)]) {
            
            [self.delegate goodsSpecs:self spec:_itemDict gsp:_itemDict.gsps[sender.tag-1000]];
        }
    }else{
        if([self.delegate respondsToSelector:@selector(goodsSpecSelectNone:)]){
            [self.delegate goodsSpecSelectNone:self];
        }
    }
    
    
}


@end
