//
//  GiveTokenViewController.m
//  CommunityApp
//
//  Created by 张艳清 on 15/11/6.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "GiveTokenViewController.h"

@interface GiveTokenViewController ()

@end

@implementation GiveTokenViewController
{
    UIView *alerView;
    UIWindow *window;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor = [UIColor blackColor];
    window.alpha = 0.5;
    [window makeKeyAndVisible];

    UIImageView *bgimageview = [[UIImageView alloc] init];
//    bgimageview.image = [UIImage imageNamed:@"cashcoupona_bg.jpg"];
    UIImage *bgImage = [UIImage imageNamed:@"cashcoupona_bg.jpg"];
    alerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    alerView.backgroundColor = [UIColor colorWithPatternImage:bgImage];


    UIImage *openImage = [UIImage imageNamed:@"cashcoupona_cancel.jpg"];
    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    openBtn.frame = CGRectMake(250, 0, 50, 50);
    [openBtn setBackgroundImage:openImage forState:UIControlStateNormal];
    [openBtn addTarget:self action:@selector(openBtnClick:) forControlEvents:UIControlEventTouchDragInside];
    [alerView addSubview:openBtn];



    alerView.center = window.center;
    [window addSubview:alerView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)];
    [window addGestureRecognizer:tap];


}
- (void)dissmiss{
    [window resignKeyWindow];
    window = nil;
    [alerView removeFromSuperview];
}
//- (void)openbutton
//{
//    UIImage *openImage = [UIImage imageNamed:@"cashcoupona_bg.jpg"];
//    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    openBtn.frame = CGRectMake(250, 0, 50, 50);
//    [openBtn setBackgroundImage:openImage forState:UIControlStateNormal];
//    [openBtn addTarget:self action:@selector(openBtnClick:) forControlEvents:UIControlEventTouchDragInside];
//    [self.view addSubview:openBtn];
//}
- (void)openBtnClick:(UIButton *)btn
{
    [self dismissModalViewControllerAnimated:YES];
//    [window resignKeyWindow];
//    window = nil;
//    [alerView removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
