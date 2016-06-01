//
//  VisitorPassportViewControllerTableViewCell.h
//  CommunityApp
//
//  Created by iss on 7/1/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisitorPassportViewControllerTableViewCell : UITableViewCell
-(void)loadCellData:(NSArray*)data textFieldDelegate:(id<UITextFieldDelegate>)textFieldDelegate;
-(void)setContextText:(NSString*)text;
-(NSString*)getInputText;
@end
