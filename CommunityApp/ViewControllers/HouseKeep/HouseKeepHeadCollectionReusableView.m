//
//  HouseKeepHeadCollectionReusableView.m
//  CommunityApp
//
//  Created by iss on 8/5/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "HouseKeepHeadCollectionReusableView.h"
#import "KDCycleBannerView.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageDownloaderOperation.h"

@interface HouseKeepHeadCollectionReusableView()<KDCycleBannerViewDataource>
@property (strong,nonatomic) IBOutlet KDCycleBannerView* picShow;
@property (strong,nonatomic) IBOutlet UIView* lableView;
@property (strong,nonatomic) NSArray* data;

// 轮播区域关联属性
@property (nonatomic, retain) NSMutableArray    *adImageArray;
@property (nonatomic, retain) NSMutableArray    *adImageOperateArray;
@property (nonatomic, assign) NSInteger         SDWebImageDownUrlNumber;
@property (nonatomic, assign) NSInteger         SDWebImageDownUrlCount;

@end
@implementation HouseKeepHeadCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
    _picShow.datasource = self;
    _picShow.continuous = YES;
    _picShow.autoPlayTimeInterval = 4;
}
-(void)loadHeaderCell:(NSArray*)picUrl andSetContinuous:(BOOL)isContinuous
{
    _picShow.continuous = isContinuous;
    
     self.data = [[NSArray alloc] initWithArray: picUrl];
    
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
    _SDWebImageDownUrlNumber = self.data.count;
    [self.adImageArray removeAllObjects];
    
    _SDWebImageDownUrlCount = 0;
    for (NSString *imgUrl in self.data) {
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
                [self.adImageArray addObject:[UIImage imageWithData:data]];
            }
            if(_SDWebImageDownUrlCount ==  _SDWebImageDownUrlNumber)
            {
                [self cycleBannerReloadOnMainThread];
            }
            
        }];
        if(operation)
            [_adImageOperateArray addObject:operation];
    }
    
//     [self.picShow reloadDataWithCompleteBlock:^{}];
}

-(void) cycleBannerReloadOnMainThread
{
    [self  performSelectorOnMainThread:@selector(cycleBannerReload) withObject:nil waitUntilDone:(BOOL)TRUE];
    
}
-(void)cycleBannerReload
{
    [_picShow reloadDataWithCompleteBlock:^{}];
}

- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView
{
    return _data ;
}
- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index
{
    return UIViewContentModeScaleToFill;
}
- (UIImage *)placeHolderImageOfZeroBannerView {
    return [UIImage imageNamed:@"HouseKeepSildeDefaultImg"];
}
@end
