//
//  ShoppingCartHeaderView.h
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCartHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIButton *sectionCheckBox;
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UIImageView *topLine;

@property (nonatomic, copy) void (^sectionCheckBoxClickBlock)(ShoppingCartHeaderView *);
@property (nonatomic, copy) void (^storeBtnBlock)(ShoppingCartHeaderView *);
@end
