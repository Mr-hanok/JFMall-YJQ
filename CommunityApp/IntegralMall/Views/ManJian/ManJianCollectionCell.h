//
//  ManJianCollectionCell.h
//  CommunityApp
//
//  Created by yuntai on 16/4/15.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  满减商品 cell
 */
@interface ManJianCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageIV;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;

- (void)configCellWith;
@end
