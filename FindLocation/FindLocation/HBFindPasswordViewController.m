//
//  HBFindPasswordViewController.m
//  FindLocation
//
//  Created by 吴 辉斌 on 12-10-11.
//  Copyright (c) 2012年 Âê¥ ËæâÊñå. All rights reserved.
//

#import "HBFindPasswordViewController.h"
#import "NSString+NimbusCore.h"
#import "SVProgressHUD.h"
#import "HBUser.h"
#import "HBRefreshBarButtonItem.h"

@interface HBFindPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation HBFindPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"找回密码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPhoneTextField:nil];
    [self setSubmitBtn:nil];
    [super viewDidUnload];
}

- (IBAction)findPassword:(id)sender
{
    [self.phoneTextField resignFirstResponder];
    if ([self.phoneTextField.text isWhitespaceAndNewlines]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
        return;
    }
    
    [self beginFindPassword];
    [HBUser findPasswordByPhoneNum:self.phoneTextField.text success:^(BOOL result) {
        [self endFindPassword:result];
    } failure:^(NSError *error) {
        [self endFindPassword:NO];
    }];

}

- (void)beginFindPassword
{
    [SVProgressHUD showWithStatus:@"正在找回密码"];
    self.submitBtn.enabled = NO;
    self.navigationItem.leftBarButtonItem = [[HBRefreshBarButtonItem alloc] init];
}

- (void)endFindPassword:(BOOL)result
{
    self.submitBtn.enabled = YES;
    self.navigationItem.leftBarButtonItem = nil;
    if (result) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"密码已发送至您的手机，查收一下吧~"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"操作失败"];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
