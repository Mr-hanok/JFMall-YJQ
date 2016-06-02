//
//  PersonalCenterIntegralViewController.m
//  CommunityApp
//
//  Created by iss on 7/1/15.
//  Copyright (c) 2015 iss. All rights reserved.
//

#import "PersonalCenterIntegralViewController.h"
#import "PersonalCenterIntegralRuleViewController.h"
#import "UIImageView+AFNetworking.h"

@interface PersonalCenterIntegralViewController ()
@property (strong,nonatomic)IBOutlet UILabel* membersLevel;
@property (strong,nonatomic)IBOutlet UILabel* currentIntegral;
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;

@end

@implementation PersonalCenterIntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Str_Integral_Tilte;
    [self setNavBarLeftItemAsBackArrow];
    [self freshPage];
    
    _headIcon.layer.cornerRadius = _headIcon.frame.size.width / 2;
    _headIcon.clipsToBounds = YES;
    if (_myAvatar) {
        [_headIcon setImage:_myAvatar];
    }else {
        NSString *filePath = [[LoginConfig Instance] userIcon];
        NSURL *iconUrl = [NSURL URLWithString:filePath];
        [_headIcon setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"head"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)freshPage
{
    UserModel* user=[[LoginConfig Instance]getUserInfo];
    [_membersLevel setText:[NSString stringWithFormat:@"LV.%@",user.membersLevel] ];
    [_currentIntegral  setText: user.currentIntegral];
}
- (IBAction)toIntegralRule:(UIButton *)sender {
    PersonalCenterIntegralRuleViewController* vc = [[PersonalCenterIntegralRuleViewController alloc]init];
    [self.navigationController pushViewController:vc animated:TRUE];
}

@end
