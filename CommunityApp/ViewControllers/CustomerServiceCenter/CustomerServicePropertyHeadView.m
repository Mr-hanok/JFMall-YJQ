//
//  CustomerServicePropertyHeadView.m
//  CommunityApp
//
//  Created by iss on 6/29/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "CustomerServicePropertyHeadView.h"
@interface CustomerServicePropertyHeadView()
@property (weak,nonatomic) IBOutlet NSLayoutConstraint* space1;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint* space2;
@end
@implementation CustomerServicePropertyHeadView

- (void)awakeFromNib {
    // Initialization code
    _space2.constant = _space1.constant = (Screen_Width-100*2)/3;
}
-(IBAction)toProperty:(id)sender
{
    if(self.PropertyBlock)
    {
        self.PropertyBlock();
        
    }
}
-(IBAction)toHotline:(id)sender
{
    if(self.HotLineBlock)
    {
        self.HotLineBlock();
        
    }
}
@end
