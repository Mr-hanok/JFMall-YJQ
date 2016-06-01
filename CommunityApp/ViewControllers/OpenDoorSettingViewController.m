//
//  OpenDoorSettingViewController.m
//  CommunityApp
//
//  Created by lsy on 15/12/23.
//  Copyright © 2015年 iss. All rights reserved.
//

#import "OpenDoorSettingViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface OpenDoorSettingViewController ()
@property(nonatomic,weak)IBOutlet UISwitch*soundEffectSwitch;
- (IBAction)soundEffectSwitchAction:(UISwitch *)sender;
@property(nonatomic,weak)IBOutlet UISwitch*shakeSwitch;
- (IBAction)shakeSwitchAction:(UISwitch *)sender;
//@property(nonatomic,strong)NSUserDefaults*defaultsSwitchStatus;
@end

@implementation OpenDoorSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=COLOR_RGBA(240,240,240,1);
    self.title=@"设置";
    [self setNavBarLeftItemAsBackArrow];
    [self soundEffectSwitchAndshakeSwitchStatus];
}
//获取设置的默认状态
-(void)soundEffectSwitchAndshakeSwitchStatus
{
    NSUserDefaults*defaultsSwitchStatus=[NSUserDefaults standardUserDefaults];
    NSString*soundEffectSwitchstr=[defaultsSwitchStatus objectForKey:@"soundEffectSwitch"];
    if ([soundEffectSwitchstr isEqualToString:@"YES"]) {
        [self.soundEffectSwitch setOn:YES];
    }else{
        [self.soundEffectSwitch setOn:NO];
    }
    NSString*str=[defaultsSwitchStatus objectForKey:@"shakeSwitch"];
    if ([str isEqualToString:@"YES"]) {
        [self.shakeSwitch setOn:YES];
    }else{
        [self.shakeSwitch setOn:NO];
    }
    
}
- (IBAction)soundEffectSwitchAction:(UISwitch *)sender {
     NSUserDefaults*defaultsSwitchStatus=[NSUserDefaults standardUserDefaults];
    if (self.soundEffectSwitch.isOn) {
        [defaultsSwitchStatus setObject:@"YES" forKey:@"soundEffectSwitch"];
        NSURL *url=[[NSBundle mainBundle]URLForResource:@"4514.wav" withExtension:nil];
        SystemSoundID soundID=0;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        AudioServicesPlayAlertSound(soundID);
    }else{
        [defaultsSwitchStatus setObject:@"NO" forKey:@"soundEffectSwitch"];
    }
}

- (IBAction)shakeSwitchAction:(UISwitch *)sender {
     NSUserDefaults*defaultsSwitchStatus=[NSUserDefaults standardUserDefaults];
    if (self.shakeSwitch.isOn) {
        [defaultsSwitchStatus  setObject:@"YES" forKey:@"shakeSwitch"];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }else
    {
         [defaultsSwitchStatus  setObject:@"NO" forKey:@"shakeSwitch"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
