//
//  GuideViewController.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/31.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()
{
    UIImageView* guideView;
}
@property (strong,nonatomic) IBOutlet UIScrollView* scroll;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end


@implementation GuideViewController

#pragma mark - view
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initWithGuideView];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self initWithGuideView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //self.view.frame = CGRectMake(0, -20, Screen_Width, Screen_Height);
    self.navigationController.navigationBarHidden=YES;
    
}
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES; //返回NO表示要显示，返回YES将hiden
}

#pragma mark - subviews
-(void)initWithGuideView
{
    _scroll.pagingEnabled = true;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.autoresizingMask = self.view.autoresizingMask;
    _scroll.scrollsToTop = NO;
    for(int i=1;i<5;i++)
    {
        guideView = [[UIImageView alloc] initWithFrame:CGRectMake(Screen_Width*(i-1),0, Screen_Width, Screen_Height)];
        guideView.tag = i;
        NSString *imgName;
    //    if (IPhone5) {
            imgName = [NSString stringWithFormat:@"Guide-%d.jpg", i];
//        }
//        else
//        {
//            imgName = [NSString stringWithFormat:@"960-%d.jpg", i];
//        }
        UIImage *img = [UIImage imageNamed:imgName];
        guideView.image = img;
        guideView.userInteractionEnabled=YES;
        [self.scroll addSubview:guideView];
        self.scroll.contentSize = CGSizeMake(Screen_Width*(i), 0);
        if (guideView.tag==1)
        {
            UIButton* start = [UIButton buttonWithType:UIButtonTypeCustom];
            start.backgroundColor = COLOR_RGB(90, 183, 33);
            start.layer.cornerRadius = 5;
            start.layer.borderWidth = 1;
            start.layer.borderColor = COLOR_RGB(90, 183, 33).CGColor;
            [start setTitle:@"跳过" forState:UIControlStateNormal];
            start.frame = CGRectMake(Screen_Width-60, 20, 50, 30);
            [start addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
            [guideView addSubview:start];
        }
        if (guideView.tag==4)
        {
            UIButton* start = [UIButton buttonWithType:UIButtonTypeCustom];
            start.backgroundColor = COLOR_RGB(90, 183, 33);
            start.layer.cornerRadius = 5;
            start.layer.borderWidth = 1;
            start.layer.borderColor = COLOR_RGB(90, 183, 33).CGColor;
            [start setTitle:@"马上开启" forState:UIControlStateNormal];
//            if (IPhone5) {
//               start.frame = CGRectMake((Screen_Width-100)/2, Screen_Height-40-50, 100, 30);
//               
//           }
//            else
//            {
                start.frame = CGRectMake((Screen_Width-100)/2, Screen_Height-50, 100, 30);
            //}
            [start addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
            [guideView addSubview:start];
        }
    }
    
//    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, Screen_Height-20, Screen_Width, 20)];
    [_pageControl setBackgroundColor:[UIColor clearColor]];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 4;
    [self.view addSubview:_pageControl];
    
}

#pragma mark - button click
-(void)closeView:(id)sender
{
    //写入数据
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * key = [NSString stringWithFormat:@"is_first"];
    [setting setObject:[NSString stringWithFormat:@"false"] forKey:key];
    [setting synchronize];
    [[Common appDelegate] loadSWRevealViewController];
}

#pragma mark - scroll
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取当前页码
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
//    NSInteger page = floor((scrollView.contentOffset.x -Screen_Width/2)/Screen_Width) +1;
    
    //设置当前页码
    self.pageControl.currentPage = index;
    
}
@end
