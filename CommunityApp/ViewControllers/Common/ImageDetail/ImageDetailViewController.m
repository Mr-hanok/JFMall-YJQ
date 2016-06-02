//
//  ImageDetailViewController.m
//  CommunityApp
//
//  Created by iss on 7/28/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "ImageDetailViewController.h"
 
@interface ImageDetailViewController ()<UIScrollViewDelegate>
@property (strong,nonatomic) NSMutableArray* imgArray;
@property (strong,nonatomic) IBOutlet UIScrollView* scroll;
@end

@implementation ImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = Str_PictureDetail_Title;
    [self setNavBarLeftItemAsBackArrow];
    [self setNavBarRightItemTitle:Str_RightNavBtn_Title andNorBgImgName:nil andPreBgImgName:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    _scroll.delegate  =self;
    _scroll.pagingEnabled = true;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.autoresizingMask = self.view.autoresizingMask;
    _scroll.scrollsToTop = NO;
    [self.view addSubview:_scroll];
    [self loadImg];
    
    if (_currentSelectedPage > 0) {
        [_scroll scrollRectToVisible:CGRectMake(_currentSelectedPage*_scroll.frame.size.width, 0, _scroll.frame.size.width, _scroll.frame.size.height) animated:NO];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setImageDetail:(NSArray *)imgArray
{
    _imgArray =[[NSMutableArray alloc]initWithArray: imgArray];
}
-(void)loadImg
{
//    [_detail setImage:_imgTmp];
//    UIImage *scaledImg = [Common imageCompressForWidth:_imgTmp targetWidth:Screen_Width];
   // CGFloat targetHight = scaledImg.size.height;
   // _imageHeight.constant = targetHight;
    CGFloat contentWidth = CGRectGetWidth(_scroll.frame);
    CGFloat contentHeight = CGRectGetHeight(_scroll.frame);
    [_scroll setContentSize:CGSizeMake(contentWidth*_imgArray.count,contentHeight)];
    for (int i=0;i<_imgArray.count;i++) {
        UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(contentWidth*i, 0,contentWidth, contentHeight)];
        [img setImage:[_imgArray objectAtIndex:i]];
        img.backgroundColor = [UIColor clearColor];
         img.contentMode = UIViewContentModeScaleToFill;
        [_scroll addSubview:img];
    }
    

}
- (void)navBarRightItemClick
{
    // nothing
    if (_currentSelectedPage>_imgArray.count-1) {
        return;
    }
    if([self.delegate respondsToSelector:@selector(clickDel:)])
    {
        [self.delegate clickDel:_currentSelectedPage];
    }
    [_imgArray removeObjectAtIndex:_currentSelectedPage];
    for(UIView* subview in [_scroll subviews])
    {
        [subview removeFromSuperview];
    }
    [self loadImg];
    if(_imgArray.count==0)
    {
        [self.navigationController popViewControllerAnimated:TRUE];
        return;
    }

}
#pragma mark---UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)sender {
    // 得到每页宽度
    CGFloat pageWidth = sender.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    _currentSelectedPage = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth)+1;
}

@end
