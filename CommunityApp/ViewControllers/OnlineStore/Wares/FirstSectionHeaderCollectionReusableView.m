//
//  FirstSectionHeaderCollectionReusableView.m
//  CommunityApp
//
//  Created by iSS－WDH on 15/8/14.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "FirstSectionHeaderCollectionReusableView.h"

@implementation FirstSectionHeaderCollectionReusableView

- (void)awakeFromNib {
    // Initialization code
}


- (IBAction)headerClickHandler:(id)sender {
    if (self.headerClickBlock) {
        self.headerClickBlock();
    }
}


@end
