//
//  ContactSelect.m
//  CommunityApp
//
//  Created by iss on 15/6/8.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ContactSelect.h"
#import "UserModel.h"
#import <AddressBookUI/AddressBookUI.h>

@interface ContactSelect()<ABPeoplePickerNavigationControllerDelegate>
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *telno;

@end

@implementation ContactSelect

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化导航栏
    self.navigationItem.title = @"联系人";
    [self setNavBarLeftItemAsBackArrow];
    [self setNavBarRightItemTitle:@"确认" andNorBgImgName:nil andPreBgImgName:nil];
    
    [self.name setText:self.strName];
    [self.telno setText:self.strTelno];
}


#pragma mark - 按钮点击事件处理函数定义区域
// 联系人按钮点击事件处理函数
- (IBAction)contactBtnClickHandler:(id)sender
{
    ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    peoplePicker.peoplePickerDelegate = self;
    [self.navigationController presentViewController:peoplePicker animated:YES completion:^{
        
    }];
}


#pragma mark -- 通讯录代理方法实现
// 8.0之后版本 联系人选择 代理方法
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    CFStringRef telno = ABMultiValueCopyValueAtIndex(valuesRef,index);
    
    CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        [self.telno setText:(__bridge NSString *)telno];
        [self.name setText: [NSString stringWithFormat:@"%@%@",(__bridge NSString *)lastName, (__bridge NSString *)firstName]];
    }];
}

// 8.0之前版本 联系人选择 代理方法
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef,identifier);
    CFStringRef telno = ABMultiValueCopyValueAtIndex(valuesRef,index);
    
    CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        [self.telno setText:(__bridge NSString *)telno];
        [self.name setText: [NSString stringWithFormat:@"%@%@",(__bridge NSString *)lastName, (__bridge NSString *)firstName]];
    }];
    
    return NO;
}

// 取消按钮点击事件 代理方法
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - 重写导航栏右侧按钮点击事件处理函数
- (void)navBarRightItemClick
{
    [self.delegate setSelectedContactName:self.name.text andTelno:self.telno.text];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
