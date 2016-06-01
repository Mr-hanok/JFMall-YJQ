//
//  BusinessUserEvaluateTableViewCell.h
//  CommunityApp
//
//  Created by iss on 7/6/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurroundBusinessReviewModel.h"

@interface BusinessUserEvaluateTableViewCell : UITableViewCell
+(CGFloat) textWidth;
+(CGFloat) textOriginY;
+(CGFloat) textMarginBottom;
+(CGFloat) cellFixHeight;
-(void)loadCellData:(SurroundBusinessReviewModel*) data;
@end
