//
//  ManJianViewController.m
//  CommunityApp
//
//  Created by yuntai on 16/4/15.
//  Copyright © 2016年 iss. All rights reserved.
//

#import "ManJianViewController.h"
#import "ManJianCollectionCell.h"
#import "ManJIanTitleView.h"
#import "ManJianFooterView.h"
#import <MJRefresh.h>

@interface ManJianViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger footerHeight;
@end

@implementation ManJianViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarLeftItemAsBackArrow];
    
    self.collectionView.backgroundColor = self.view.backgroundColor;
    self.footerHeight = 0;

//    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc]init];   
//    collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
//    [self.collectionView setCollectionViewLayout:collectionViewLayout];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ManJianCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    UINib *nibForFirstHeader = [UINib nibWithNibName:@"ManJIanTitleView" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nibForFirstHeader forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ManJIanTitleView"];
    
    UINib *nibForFirstFooter = [UINib nibWithNibName:@"ManJianFooterView" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nibForFirstFooter forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ManJianFooterView"];
    
    // 添加下拉刷新、下拉加载更多
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //数据请求
        [self performSelector:@selector(getdata) withObject:nil afterDelay:1.f];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = header;

}

#pragma mark - CollectionDataSource代理
//CollectionView的Section数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
    
}
// 设计每个section的Item数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return section = 2;
}
// 加载CollectionViewCell的数据
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ManJianCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell configCellWith];
    return cell;
}

#pragma mark - CollectionView代理
// CollectionView元素选择事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark -CollectionViewFlowlayout代理
// 设置CollectionViewCell大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = 0;
    CGFloat height = 0;
    width = APP_SCREEN_WIDTH/2-10;
    height = width;

    CGSize itemSize = CGSizeMake(width, height);
    return itemSize;
}
/* 定义每个UICollectionView 的边缘 */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);//上 左 下 右
}

// 设置Sectionheader大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize itemSize ;
    if (section == 0) {
        itemSize=CGSizeMake(APP_SCREEN_WIDTH, 185);
    }else{
        itemSize=CGSizeMake(APP_SCREEN_WIDTH, 35);
    }
    
    return itemSize;
}

// 设置SectionFooter大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize itemSize = CGSizeMake(0, 0);
    if (section == 1) {
        if (self.footerHeight == 0) {
            itemSize = CGSizeMake(APP_SCREEN_WIDTH, 100);
        }else{
            itemSize = CGSizeMake(APP_SCREEN_WIDTH, self.footerHeight);

        }
    }
    return itemSize;
}

 //设置Header和FooterView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
       ManJIanTitleView *view = (ManJIanTitleView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ManJIanTitleView" forIndexPath:indexPath];
        [view loadHeadersection:indexPath.section imagePath:nil placeHolderImage:@"01" title:@"最热推荐"];
        return view;
    }
    if (kind == UICollectionElementKindSectionFooter && indexPath.section == 1 ) {
       ManJianFooterView *view = (ManJianFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ManJianFooterView" forIndexPath:indexPath];
       NSInteger height = [view loadFooterText:@"是ing看电视可交付的时刻就发了看电视就发了看电视就离开房间里的时刻就发了看电视剧发大水了开机"];
        self.footerHeight = height;
//        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
        return view;
    }
    return nil;
}

#pragma mark - event response

#pragma mark - private methods
- (void)getdata{
    [self.collectionView.mj_header endRefreshing];
}
@end
