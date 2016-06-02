//
//  CustomerServiceCenterCollectionMsgViewCell.h
//  CommunityApp
//
//  Created by iss on 6/29/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerServiceCenterCollectionMsgViewCell : UICollectionViewCell
-(void)setCell:(NSString*) string detail:(NSString*)detail;
-(void)showDetail;
-(void)hideDetail;
-(CGFloat)getCellHeight;
@end
