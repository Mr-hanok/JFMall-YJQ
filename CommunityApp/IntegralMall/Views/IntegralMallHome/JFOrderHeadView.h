//
//  JFOrderHeadView.h
//  CommunityApp
//
//  Created by yuntai on 16/4/25.
//  Copyright © 2016年 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFOrderHeadView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *orderStorenameLabel;
- (void)configSectionHeadViewWithStoreName:(NSString *)storeName;
@end
