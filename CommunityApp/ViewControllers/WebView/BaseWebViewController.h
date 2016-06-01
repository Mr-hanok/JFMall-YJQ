//
//  BaseWebViewController.h
//  CommunityApp
//
//  Created by lipeng on 16/3/15.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseWebViewController : BaseViewController

@property (nonatomic, strong) NSString *url;
@property (nonatomic, copy)   NSString *filePath;

@end
