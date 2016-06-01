//
//  ExpressNoInsertViewController.m
//  CommunityApp
//
//  Created by issuser on 15/8/24.
//  Copyright (c) 2015年 iss. All rights reserved.
//

#import "ExpressNoInsertViewController.h"
typedef enum {
    Express_Company_YuanTong = 0,   // @"圆通快递"
    Express_Company_ShenTong,       // @"申通快递"
    Express_Company_YunDa,          // @"韵达快递"
    Express_Company_ShunFeng,       // @"顺丰快递"
    Express_Company_EMS,            // @"中国邮政"
    EXpress_Company_Other           // @"其他快递"
}eExpressCp;

@interface ExpressNoInsertViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *expressNoTextField;
@property (weak, nonatomic) IBOutlet UILabel *expressCpTextLabel;

@end

@implementation ExpressNoInsertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBgViewStyle];
    [self setNavBarLeftItemAsBackArrow];
    self.navigationItem.title = Str_Express_No_Title;
    [self setNavBarRightItemTitle:@"提交" andNorBgImgName:nil andPreBgImgName:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    

}

- (void)initBgViewStyle {
    [Common setRoundBorder:_bgView borderWidth:0.5 cornerRadius:3 borderColor:Color_Gray_RGB];
}

- (void)navBarRightItemClick {
    ExpressTypeModel *model = [[ExpressTypeModel alloc]init];
    model.ExpressTypeNo = _expressNoTextField.text;
    model.ExpressTypeName = _expressCpTextLabel.text;
    
    //判断输入内容是否为空
    if ([model.ExpressTypeNo isEqualToString: @""] || model.ExpressTypeNo == nil) {
        [Common showBottomToast:@"内容填写不完整，请检查后提交"];
        return;
    }

    if (self.ExpressTicket) {
        self.ExpressTicket(model);
    }
}

#pragma mark---UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case Express_Company_YuanTong:
            {
                [_expressCpTextLabel setText:Str_Express_Company_YuanTong];
            }
            break;
        case Express_Company_ShenTong:
            {
                
                [_expressCpTextLabel setText:Str_Express_Company_ShenTong];
            }
            break;
        case Express_Company_YunDa:
            {
                
                [_expressCpTextLabel setText:Str_Express_Company_YunDa];
            }
            break;
        case Express_Company_ShunFeng:
            {
                
                [_expressCpTextLabel setText:Str_Express_Company_ShunFeng];
            }
            break;
        case Express_Company_EMS:
            {
                
                [_expressCpTextLabel setText:Str_Express_Company_EMS];
            }
            break;
        case EXpress_Company_Other:
            {
                [_expressCpTextLabel setText:Str_EXpress_Company_Other];
            }
            break;
        default:
            break;
    }
}

- (IBAction)selectExpressCompany:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:Str_Express_Company_YuanTong, Str_Express_Company_ShenTong, Str_Express_Company_YunDa, Str_Express_Company_ShunFeng, Str_Express_Company_EMS, Str_EXpress_Company_Other, nil];
    
    [actionSheet showInView:self.view];
}
@end