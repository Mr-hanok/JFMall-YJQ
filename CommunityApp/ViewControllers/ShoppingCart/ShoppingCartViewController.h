//
//  ShoppingCartViewController.h
//  CommunityApp
//
//  Created by issuser on 15/6/2.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#define ShoppingCartChangedNotification             @"shoppingCartChangeNotification"

typedef enum ECartViewFromViewType{
    E_CartViewFromType_TabBar,
    E_CartViewFromType_Push,
    E_CartViewFromType_Other
}eCartViewFromViewType;

@interface ShoppingCartViewController : BaseViewController

@property (nonatomic, assign) eCartViewFromViewType     eFromType;

@end
