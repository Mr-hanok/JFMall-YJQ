//
//  FirstHeaderView.m
//  CommunityApp
//
//  Created by issuser on 15/6/5.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "FirstHeaderView.h"
#import "AdImgSlideInfo.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageDownloaderOperation.h"

@interface FirstHeaderView()<KDCycleBannerViewDataource, KDCycleBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *speakerImgView;
@property (weak, nonatomic) IBOutlet UILabel *ntfContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *ntfTimerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;

// 轮播区域关联属性
@property (nonatomic, retain) NSMutableArray    *adImageArray;
@property (nonatomic, retain) NSMutableArray    *adImageOperateArray;
@property (nonatomic, assign) NSInteger         SDWebImageDownUrlNumber;
@property (nonatomic, assign) NSInteger         SDWebImageDownUrlCount;
@end

@implementation FirstHeaderView

- (void)awakeFromNib {
    // Initialization code
    _cycleBannerView.datasource = self;
    _cycleBannerView.delegate = self;
    _cycleBannerView.continuous = YES;
    _cycleBannerView.autoPlayTimeInterval = 4;
    self.adImageArray = [[NSMutableArray alloc] init];
    self.adImageOperateArray = [[NSMutableArray alloc]init];
    [Common updateLayout:_bottomLine where:NSLayoutAttributeHeight constant:0.5];
}

-(void)loadHeaderData:(NSArray *)adImgSildeInfoArray
{
//    [self.speakerImgView setImage:[UIImage imageNamed:Img_Home_SpeakerNoVoice]];
    
//    NSDate *  today=[NSDate date];
//    NSCalendar  * cal=[NSCalendar  currentCalendar];
//    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
//    NSDateComponents * conponent= [cal components:unitFlags fromDate:today];
//    NSInteger year=[conponent year];
//    NSInteger month=[conponent month];
//    NSInteger day=[conponent day];
//    NSString *  nsDateString= [NSString stringWithFormat:@"今天是%4ld年%2ld月%2ld日",(long)year,(long)month,(long)day];
//    if (month < 10 && day < 10) {
//        nsDateString= [NSString stringWithFormat:@"今天是%4ld年0%1ld月0%1ld日",(long)year,(long)month,(long)day];
//    }else if (month < 10) {
//        nsDateString= [NSString stringWithFormat:@"今天是%4ld年0%1ld月%2ld日",(long)year,(long)month,(long)day];
//    }else if (day < 10) {
//        nsDateString= [NSString stringWithFormat:@"今天是%4ld年%2ld月0%1ld日",(long)year,(long)month,(long)day];
//    }
//    
//    [self.ntfContentLabel setText:nsDateString];
//    [self.ntfTimerLabel setText:@"00:12:38"];
 
    
    //adImgSildeInfoArray轮播图片url数组
    
    //上次刷新还有剩余的block未完成
    if(_SDWebImageDownUrlCount <  _SDWebImageDownUrlNumber)
    {
        for(id<SDWebImageOperation> operation in _adImageOperateArray)
        {
            [operation cancel];
        }
        NSLog(@"清除上次刷新还有剩余的block未完成");
    }
    [_adImageOperateArray removeAllObjects];
    _SDWebImageDownUrlNumber = adImgSildeInfoArray.count;
    [self.adImageArray removeAllObjects];
    for (int i = 0; i < adImgSildeInfoArray.count; i++) {
        [self.adImageArray addObject:[UIImage imageNamed:@"AdSlideDefaultImg"]];
    }
 
    if (adImgSildeInfoArray.count <= 1) {
        _cycleBannerView.continuous = NO;
    }else{
        _cycleBannerView.continuous = TRUE;
    }

    _SDWebImageDownUrlCount = 0;
    int index = 0;
    for (NSString *imgUrl in adImgSildeInfoArray) {
        NSRange rang = [imgUrl rangeOfString:FileManager_Address];
        NSURL *iconUrl = [[NSURL alloc] init];
        if(rang.length == 0)
        {
            iconUrl = [NSURL URLWithString:[Common setCorrectURL:imgUrl]];
        }
        else
        {
            iconUrl = [NSURL URLWithString:imgUrl];
        }
        
        SDWebImageDownloaderOperation* operation = [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:iconUrl options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            _SDWebImageDownUrlCount++;
            UIImage *waresImg = [UIImage imageWithData:data];
            if (waresImg != nil) {
                [self.adImageArray replaceObjectAtIndex:index withObject:[UIImage imageWithData:data]];
            }
            if(_SDWebImageDownUrlCount ==  _SDWebImageDownUrlNumber)
            {
                [self cycleBannerReloadOnMainThread];
            }
            
        }];
        if(operation)
            [_adImageOperateArray addObject:operation];
        
        index++;
    }
    [self.cycleBannerView reloadDataWithCompleteBlock:^{}];

}

-(void) cycleBannerReloadOnMainThread
{
    [self  performSelectorOnMainThread:@selector(cycleBannerReload) withObject:nil waitUntilDone:(BOOL)TRUE];
   
}
-(void)cycleBannerReload
{
    [_cycleBannerView reloadDataWithCompleteBlock:^{}];
}
#pragma mark - KDCycleBannerViewDataSource

- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView {
    
    return self.adImageArray;
}

- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index {
    return UIViewContentModeScaleToFill;
}

- (UIImage *)placeHolderImageOfZeroBannerView {
    return [UIImage imageNamed:_defaultImgName];
}

#pragma mark - KDCycleBannerViewDelegate

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didScrollToIndex:(NSUInteger)index
{
}

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index
{
    if (self.adImgClickBlock) {
        self.adImgClickBlock(index);
    }
}

@end
