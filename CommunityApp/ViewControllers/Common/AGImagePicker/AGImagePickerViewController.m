//
//  AGImagePickerViewController.m
//  CommunityApp
//
//  Created by iss on 7/10/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "AGImagePickerViewController.h"

#import "KDCycleBannerView.h"
#import "SDWebImageDownloader.h"

#define cellNibName @"AGImagePickerCollectionViewCell"


@interface AGImagePickerViewController ()<UIGestureRecognizerDelegate,KDCycleBannerViewDelegate,KDCycleBannerViewDataource>
{
    CGFloat lastScale;
    NSInteger currIndex;
    UIPinchGestureRecognizer *pinchRecognizer;
}
@property (strong,nonatomic) IBOutlet UIView *holderView;
@property (strong,nonatomic) IBOutlet UILabel *tipLabel;
@property (retain, nonatomic) KDCycleBannerView *cycleBannerView;
@property (retain, nonatomic) NSMutableArray    *imgArray;
@property (retain,nonatomic) IBOutlet UIImageView* preImg;
@property (nonatomic, assign) NSInteger         SDWebImageDownUrlNumber;
@property (nonatomic, assign) NSInteger         SDWebImageDownUrlCount;
@end

@implementation AGImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor lightGrayColor];
    self.navigationItem.title = @"图片预览";
    [self setNavBarLeftItemAsBackArrow];
       
    _imgArray = [[NSMutableArray alloc] init];
    
 
}
-(void)addGesture
{
    pinchRecognizer = [[UIPinchGestureRecognizer alloc]
                                                 
                                                 initWithTarget:self action:@selector(scale:)];
    
    [pinchRecognizer setDelegate:self];
    [_cycleBannerView addGestureRecognizer:pinchRecognizer];
   
}
-(void)removeGesture
{
    [_cycleBannerView removeGestureRecognizer:pinchRecognizer];
}
-(void)scale:(id)sender {
    
    [self.view bringSubviewToFront:[(UIPinchGestureRecognizer*)sender view]];
    
    //当手指离开屏幕时,将lastscale设置为1.0
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        lastScale = 1.0;
        
        return;
        
    }
    
    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
    
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [[(UIPinchGestureRecognizer*)sender view] setTransform:newTransform];
    
    lastScale = [(UIPinchGestureRecognizer*)sender scale];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer

shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadUrlData];
    [self loadCycleBanner];
    [self addGesture];
    [self showFirstPic];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeGesture];
}
-(void)loadUrlData
{
    if(_imgUrlArray.count == 0)
    {
        return;
    }
    if(_imgArray.count != 0)
    {
        return;
    }
    [self showHUDWithMessage:@"加载中..."];
    _SDWebImageDownUrlNumber = _imgUrlArray.count;
    
    [_imgArray removeAllObjects];
    for (int i = 0; i < _imgUrlArray.count; i++) {
        [_imgArray addObject:[UIImage imageNamed:@"DefaultImg"]];
    }
    
    int i = 0;
    for (NSString *imgUrl in _imgUrlArray) {
        NSRange rang = [imgUrl rangeOfString:@"http"];
        NSURL *iconUrl ;
        if(rang.length == 0)
        {
            iconUrl = [NSURL URLWithString:[Common setCorrectURL:imgUrl]];
        }
        else
        {
            iconUrl = [NSURL URLWithString:imgUrl];
        }
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:iconUrl options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            _SDWebImageDownUrlCount ++;
            UIImage *waresImg = [UIImage imageWithData:data];
            if (waresImg != nil) {
//                [_imgArray addObject:[UIImage imageWithData:data]];
                [_imgArray replaceObjectAtIndex:i withObject:[UIImage imageWithData:data]];
            }
            if(_SDWebImageDownUrlCount == _SDWebImageDownUrlNumber) {
                [self hideHUD];
                [_cycleBannerView reloadDataWithCompleteBlock:^{
                    
                }];
            }
        }];
        
//        NSData *data = [NSData dataWithContentsOfURL:iconUrl];
//        if(data == nil)
//            continue;
//        [_imgArray addObject:[UIImage imageWithData:data]];
        
        i++;
    }
    
    [_preImg setHidden:TRUE];
}
-(void)loadCycleBanner
{
    _cycleBannerView = [[KDCycleBannerView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-Navigation_Bar_Height)];
    _cycleBannerView.delegate = self;
    _cycleBannerView.datasource = self;
    _cycleBannerView.autoPlayTimeInterval = 1000;
    // 图片切换视图属性初始化
//    _cycleBannerView.hidePageControl = TRUE;
    [self.holderView addSubview:_cycleBannerView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showFirstPic{
    currIndex = 0;
    if (_imgArray.count == 0) {
        return;
    }
    currIndex = 1;
    [self freshTip];
       
}
-(void)freshTip
{
     [_tipLabel setText:[NSString stringWithFormat:@"%ld/%ld",(long)currIndex,(unsigned long)_imgArray.count]];
}


 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //得到每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    
    // 根据当前的x坐标和页宽度计算出当前页数
    currIndex = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth) + 2;
    [self freshTip];
}


#pragma mark - KDCycleBannerViewDataSource

- (NSArray *)numberOfKDCycleBannerView:(KDCycleBannerView *)bannerView {
    
    return _imgArray;
}

- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index {
    return UIViewContentModeScaleAspectFit;
}

- (UIImage *)placeHolderImageOfZeroBannerView {
    if(_imgArray.count == 0)
        return [UIImage imageNamed:Img_Comm_DefaultImg];
    return [_imgArray objectAtIndex:0];

}

#pragma mark - KDCycleBannerViewDelegate

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didScrollToIndex:(NSUInteger)index
{
    currIndex = index+1;
    [self freshTip];
}

- (void)cycleBannerView:(KDCycleBannerView *)bannerView didSelectedAtIndex:(NSUInteger)index
{
}


@end
