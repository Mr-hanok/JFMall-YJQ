//
//  WaresDetailViewController.h
//  CommunityApp
//
//  Created by issuser on 15/6/11.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "BaseViewController.h"
#import "KDCycleBannerView.h"

typedef enum EFromViewType{
    E_FromViewType_WareList,
    E_FromViewType_CartView,
    E_FromViewType_Other
}eFromViewType;

@interface WaresDetailViewController : BaseViewController

@property (nonatomic, copy) NSString    *waresId;
@property (nonatomic, copy) NSString    *sellerId;

@property (nonatomic, assign) eFromViewType efromType;

@end
