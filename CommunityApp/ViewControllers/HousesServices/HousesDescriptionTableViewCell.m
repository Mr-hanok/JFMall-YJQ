//
//  HousesDescriptionTableViewCell.m
//  CommunityApp
//
//  Created by iss on 15/6/30.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "HousesDescriptionTableViewCell.h"

@interface HousesDescriptionTableViewCell()<UITextViewDelegate>
@property (retain,nonatomic) IBOutlet UILabel *titleLabel;
@property (retain,nonatomic) IBOutlet UITextView *detail;


@end
@implementation HousesDescriptionTableViewCell

- (void) setTitleText:(NSString*)titleText DetailText:(NSString*)detailText {
    _titleLabel.text = titleText;
    _placeholder = detailText;
    [_detail setText:_placeholder];
}

- (void)awakeFromNib {
    // Initialization code
   // _detail.scrollEnabled  = FALSE;
    _detail.delegate = self;
  //  _detail.contentInset = UIEdgeInsetsMake(-11,-8,0,0);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [_detail becomeFirstResponder];
    } else {
        [_detail resignFirstResponder];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:_placeholder])
    {
        textView.text = @"";
    }
    
     UITableView *tableView = [self tableView];
    NSIndexPath *indexPath = [tableView indexPathForCell:self];
    NSInteger row = indexPath.row;
    //这里要看textField 是直接加到cell 上的还是加的 cell.contentView上的
    
    //直接加到cell 上
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


- (void)textViewDidChange:(UITextView *)textView
{
//    if (textView.text.length<1) {
//        textView.text = _placeholder;
//    }

    if ([self.delegate respondsToSelector:@selector(textViewCell:didChangeText:)]) {
        [self.delegate textViewCell:self didChangeText:textView.text];
    }
    NSString* input =  textView.text;
    CGFloat height =  [HousesDescriptionTableViewCell getInputHeight:input];
    textView.bounds = CGRectMake(0, 4,[HousesDescriptionTableViewCell textWidth], height );
    CGRect  contentViewFrame = CGRectMake(0, 0, Screen_Width, [HousesDescriptionTableViewCell getCellHeight:height]);
   [self.contentView setFrame:contentViewFrame];
    
    // 让 table view 重新计算高度
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];
}
- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}
+(CGFloat) textMinHeight
{
    return 34.0f;
}

+(CGFloat) textHeightOrgin
{
    return 48.0f;
}
+(CGFloat) textMaginButtom
{
    return 4.0f;
}
+(CGFloat) textXOrgin
{
    return 12.0f;
}
+(CGFloat) textWidth
{
    return Screen_Width - [HousesDescriptionTableViewCell textXOrgin ]*2;
}
-(CGFloat) getCellHeight
{
    return self.contentView.frame.size.height;
}
+(CGFloat) getInputHeight:(NSString*)input
{
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake([HousesDescriptionTableViewCell textWidth], 2000);
    UIFont *font = [UIFont systemFontOfSize:13];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect newSize = [input boundingRectWithSize:maxSize  options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    CGFloat height = newSize.size.height> [HousesDescriptionTableViewCell textMinHeight]? newSize.size.height: [HousesDescriptionTableViewCell textMinHeight];
    
    return height;
}
+(CGFloat) getCellHeight:(CGFloat)inputHeight
{
    return inputHeight+[HousesDescriptionTableViewCell textHeightOrgin]+[HousesDescriptionTableViewCell textMaginButtom] ;
    
}
+(CGFloat) getCellHeightByString:(NSString*)input
{
    return [HousesDescriptionTableViewCell getCellHeight:[HousesDescriptionTableViewCell getInputHeight:input]];
    
}
@end
