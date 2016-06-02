//
//  MessageViewCellTableViewCell.m
//  CommunityApp
//
//  Created by iss on 6/10/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "MessageViewCellTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import <SDWebImageDownloader.h>
@interface MessageViewCellTableViewCell()
@property(strong,nonatomic)IBOutlet UIView* bg;
@property(strong,nonatomic)IBOutlet UILabel* title;
@property(strong,nonatomic)IBOutlet UIImageView* img;
@property(strong,nonatomic)IBOutlet UILabel* context;
@property(strong,nonatomic)IBOutlet UILabel* time;
@property(nonatomic,strong)IBOutlet UIView*checkView;
@property(strong,nonatomic)IBOutlet NSLayoutConstraint* descHeight;
@property(strong,nonatomic)IBOutlet NSLayoutConstraint* descBgViewHeight;
@property (weak, nonatomic) IBOutlet UIView *viewBg;

@property(strong,nonatomic)IBOutlet NSLayoutConstraint* titleHeight;
@property(strong,nonatomic)IBOutlet NSLayoutConstraint* titleBgHeight;
@property (weak, nonatomic) IBOutlet UIImageView *newsTypeImageView;//消息类型
@property (weak, nonatomic) IBOutlet UIImageView *newsReadImageView;//已读未读标识

@end
@implementation MessageViewCellTableViewCell
- (void)awakeFromNib {
    self.bg.layer.borderWidth = 1.0;
    self.bg.layer.borderColor = COLOR_RGB(237 , 237, 237).CGColor;
    self.viewBg.frame=CGRectMake(self.viewBg.bounds.origin.x-5, self.viewBg.bounds.origin.y, self.viewBg.frame.size.width, self.viewBg.frame.size.height);
    self.context.frame=CGRectMake(self.context.bounds.origin.x-5, self.context.bounds.origin.y, self.context.frame.size.width, self.context.frame.size.height);
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
        NSLineBreakMode lbm = NSLineBreakByTruncatingTail;
#else
        UILineBreakMode lbm = UILineBreakModeTailTruncation;
#endif
    
    self.context.lineBreakMode = NSLineBreakByWordWrapping|lbm;
    self.context.numberOfLines = 0;
//    [self.context sizeToFit];

//    self.title.lineBreakMode=NSLineBreakByWordWrapping|lbm;
//    self.title.numberOfLines = 0;

    
//    CGSize size = [self.context sizeThatFits:CGSizeMake(self.context.frame.size.width, MAXFLOAT)];
//    self.context.frame = CGRectMake(self.context.frame.origin.x, self.context.frame.origin.y, self.context.frame.size.width, 60);

    
}
#pragma mark-初始化数据
-(void)setMessageModelData:(MessageModel *)modelData
{
    if ([modelData.newsTypeString isEqual:@"物业"]) {
        _newsTypeImageView.image = [UIImage imageNamed:@"propertyBg"];
    }
    else
    {
        _newsTypeImageView.image = [UIImage imageNamed:@"systemBg"];
    }
    if ([modelData.newsReadString isEqual:@"未读"]) {

//        _newsReadImageView.image = [UIImage imageNamed:@"HintBgImg"];
        _newsReadImageView.hidden = NO;
    }
    else
    {
        _newsReadImageView.hidden = YES;
//        _newsReadImageView.image = [UIImage imageNamed:@"access"];
    }
    _time.text=modelData.createTimeString;
    
    NSString*str=@"图文消息";
        NSString*strr=@"文字";
    if ([modelData.msgTypeString isEqual:str] || [modelData.msgTypeString isEqual:strr]) {
        self.checkView.hidden=NO;

        _descHeight.constant = 20;
        _descBgViewHeight.constant = _descBgViewHeight.constant + _descHeight.constant-20;
        //将title分割成标题和内容＝＝＝2016.02.23
        NSArray *titleArray = [modelData.titlelString componentsSeparatedByString:@":"];
        //新物业通知：title 和context 分开
        if (titleArray.count > 0) {
            if ([modelData.msgTypeString isEqual:str]) {
                if (titleArray.count > 0) {
                    _title.text=[titleArray[0] substringFromIndex:6];
                }
                _context.text = [modelData.contentString substringFromIndex:0];
            }
            else
            {
                if (titleArray.count > 0) {
                    _title.text=[titleArray[0] substringFromIndex:4];
                }
                
                if (titleArray.count > 1) {
                    _context.text = [titleArray[1] substringFromIndex:0];
                }
            }
        }
        else
        {}


#pragma -mark 2016.01.11  物业通知title 显示两次修改
//        _context.text=[modelData.titlelString substringFromIndex:6];


//       [self updateViewConstraints];

//        CGFloat titleHeight=[Common labelDemandHeightWithText:self.title.text font:self.title.font size:CGSizeMake(self.title.bounds.size.width, 60)];
        _titleHeight.constant=35;
//        _titleBgHeight.constant=_titleBgHeight.constant+_titleHeight.constant-35;
//        [self layoutSubviews];

    }
    else
    {
        self.checkView.hidden=YES;
        CGFloat descHeight = [Common labelDemandHeightWithText:self.context.text font:self.context.font size:CGSizeMake(self.context.bounds.size.width,60)];
        _descHeight.constant = descHeight<20?20:descHeight;
        _descBgViewHeight.constant = _descBgViewHeight.constant + _descHeight.constant-20;
        _title.text=[modelData.titlelString substringFromIndex:4];
#pragma -mark 2016.01.11  物业通知title 显示两次修改
//        _context.text=[modelData.titlelString substringFromIndex:4];

        
//        CGFloat titleHeight=[Common labelDemandHeightWithText:self.title.text font:self.title.font size:CGSizeMake(self.title.bounds.size.width, 60)];
        _titleHeight.constant=197;
//        _titleBgHeight.constant=_titleBgHeight.constant+_titleHeight.constant-35;
//        [self layoutSubviews];
        
    }
    //2016.02.23  图片不显示
    if (modelData.pictureString.length==0||modelData.pictureString==nil) {
        _img.hidden=YES;
        return;
    }else
    {
        _img.hidden=NO;
        [_img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Service_Address,modelData.pictureString]] placeholderImage:[UIImage imageNamed:@"WaresDetailDefaultImg"]];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
