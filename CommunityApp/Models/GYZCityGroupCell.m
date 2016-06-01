//
//  GYZCityGroupCell.m
//  GYZChooseCityDemo
//
//  Created by wito on 15/12/29.
//  Copyright © 2015年 gouyz. All rights reserved.
//

#import "GYZCityGroupCell.h"

@implementation GYZCityGroupCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self addSubview:self.titleLabel];
        [self addSubview:self.noDataLabel];

        [self addSubview:self.locationImg];
        [self addSubview:self.refreshBtn];
        [self addSubview:self.warnImg];
    }
    return self;
}
#pragma mark - Getter
- (UILabel *) titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    }
    return _titleLabel;
}

- (UIButton *) refreshBtn
{
    if (_refreshBtn == nil) {
        _refreshBtn = [[UIButton alloc] init];
        [_refreshBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _refreshBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];


    }
    return _refreshBtn;
}
- (UIImageView *) locationImg
{
    if (_locationImg == nil) {
        _locationImg = [[UIImageView alloc] init];
//        _locationImg.image = [UIImage imageNamed:@"localviewImg.png"];
    }
    return _locationImg;
}
- (UIImageView *) warnImg
{
    if (_warnImg == nil) {
        _warnImg = [[UIImageView alloc] init];
//        _warnImg.image = [UIImage imageNamed:@"warnImg.png"];
    }
    return _warnImg;
}

- (UILabel *) noDataLabel
{
    if (_noDataLabel == nil) {
        _noDataLabel = [[UILabel alloc] init];
        [_noDataLabel setText:@"暂无数据"];
        [_noDataLabel setTextColor:[UIColor grayColor]];
        [_noDataLabel setFont:[UIFont systemFontOfSize:16.0f]];
    }
    return _noDataLabel;
}

- (NSMutableArray *) arrayCityButtons
{
    if (_arrayCityButtons == nil) {
        _arrayCityButtons = [[NSMutableArray alloc] init];
    }
    return _arrayCityButtons;
}
- (NSMutableArray *) arrayCityLabels
{
    if (_arrayCityLabels == nil) {
        _arrayCityLabels = [[NSMutableArray alloc] init];
    }
    return _arrayCityLabels;
}
- (void) setCityArray:(NSArray *)cityArray
{

    _cityArray = cityArray;
    [self.noDataLabel setHidden:(cityArray != nil && cityArray.count > 0)];

//从父view中删除子view
    if ((cityArray == nil || cityArray.count == 0)) {
        [self.arrayCityButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.arrayCityLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }


    for (int i = 0; i < cityArray.count; i ++) {
        GYZCity *city = [cityArray objectAtIndex:i];
        UIButton *button = nil;
        UILabel *label = nil;
        if (i < self.arrayCityButtons.count) {
            button = [self.arrayCityButtons objectAtIndex:i];
            label = [self.arrayCityLabels objectAtIndex:i];
        }
        else {
            button = [[UIButton alloc] init];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:2.0f];
            [button.layer setBorderColor:[UIColor colorWithWhite:0.8 alpha:1.0].CGColor];
            [button.layer setBorderWidth:1.0f];
            [button setTitle:city.projectName forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(cityButtonDown:) forControlEvents:UIControlEventTouchUpInside];
            [self.arrayCityButtons addObject:button];
            [self addSubview:button];

            label = [[UILabel alloc] init];
            CGFloat dictanceInt = [city.distance intValue];
                label.text = [NSString stringWithFormat:@"距离%.1fkm",dictanceInt/1000];

            label.font = [UIFont systemFontOfSize:12];
            label.tag = i;
            label.textColor = [UIColor grayColor];
            [self.arrayCityLabels addObject:label];
            [self addSubview:label];
        }

    }
    while (cityArray.count < self.arrayCityButtons.count) {
        [self.arrayCityButtons removeLastObject];
        [self.arrayCityLabels removeLastObject];
    }
}

#pragma mark - Event Response
- (void) cityButtonDown:(UIButton *)sender
{
    GYZCity *city = [self.cityArray objectAtIndex:sender.tag];
    
    if (_delegate && [_delegate respondsToSelector:@selector(cityGroupCellDidSelectCity:)]) {
        [_delegate cityGroupCellDidSelectCity:city];
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    float x = WIDTH_LEFT;
    float y = 5;
    float x1 = WIDTH_LEFT*2+MIN_WIDTH_BUTTON;
    float y1 = 5;
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    [self.locationImg setFrame:CGRectMake(x/2, y,5, size.height)];
    [self.titleLabel setFrame:CGRectMake(x, y, self.frame.size.width - x, size.height)];
    [self.refreshBtn setFrame:CGRectMake(self.frame.size.width-60, y, 50, 25)];

    y += size.height + 5;
    [self.warnImg setFrame:CGRectMake(self.frame.size.width/2-160/2-25, y, 17, self.titleLabel.frame.size.height)];
    [self.noDataLabel setFrame:CGRectMake(self.frame.size.width/2-160/2, y, 160 , self.titleLabel.frame.size.height)];
    y += 0;
    y1 += 7+20;
    float width = MIN_WIDTH_BUTTON;     // button最小宽度
    //arrayCityLables
    for (int i = 0; i < self.arrayCityButtons.count; i ++) {
        UIButton *button = [self.arrayCityButtons objectAtIndex:i];
        UILabel *lable = [self.arrayCityLabels objectAtIndex:i];
        [button setFrame:CGRectMake(x, y, width, HEIGHT_BUTTON)];
        [lable setFrame:CGRectMake(x1, y1, width, HEIGHT_BUTTON)];
        y += HEIGHT_BUTTON + 5;
        y1 += HEIGHT_BUTTON + 5;
        x = WIDTH_LEFT;
        x1 = WIDTH_LEFT*2+MIN_WIDTH_BUTTON;
    }
}

+ (CGFloat) getCellHeightOfCityArray:(NSArray *)cityArray
{
    float h = 0;
    if (cityArray != nil && cityArray.count > 0) {
        h += (40 + (HEIGHT_BUTTON + 5) * cityArray.count);
    }
    else {
        h += 60;
    }
    return h;
}
@end
