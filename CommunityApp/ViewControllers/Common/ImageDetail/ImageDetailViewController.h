//
//  ImageDetailViewController.h
//  CommunityApp
//
//  Created by iss on 7/28/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "BaseViewController.h"
@protocol ImageDetailViewDelegate<NSObject>
-(void)clickDel:(NSInteger)delIndex;
@end
@interface ImageDetailViewController : BaseViewController
-(void)setImageDetail:(NSArray*)imgArray;
@property (assign,nonatomic) id<ImageDetailViewDelegate>delegate;
@property (assign,nonatomic)NSInteger currentSelectedPage;
@end
