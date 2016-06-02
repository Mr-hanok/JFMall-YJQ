//
//  CommunityMessageCollectionViewCell.h
//  CommunityApp
//
//  Created by 张艳清 on 16/2/22.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityMessageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

- (void)createCellData;
@end
