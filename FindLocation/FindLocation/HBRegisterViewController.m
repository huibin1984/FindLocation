//
//  HBRegisterViewController.m
//  FindLocation
//
//  Created by 吴 辉斌 on 12-10-8.
//  Copyright (c) 2012年 Âê¥ ËæâÊñå. All rights reserved.
//

#import "HBRegisterViewController.h"
#import "NSString+NimbusCore.h"
#import "SVProgressHUD.h"
#import "HBUser.h"
#import "HBRefreshBarButtonItem.h"

@interface HBRegisterViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdField;
@property (weak, nonatomic) IBOutlet UISwitch *agreeMentSwitch;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation HBRegisterViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"免费注册";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.nameTextField resignFirstResponder];
    [self.phoneTextField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.confirmPwdField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNameTextField:nil];
    [self setPhoneTextField:nil];
    [self setPasswordField:nil];
    [self setConfirmPwdField:nil];
    [self setAgreeMentSwitch:nil];
    [self setRegisterBtn:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillHideNotification];
    [super viewDidUnload];
}

- (IBAction)changeAgreement:(UISwitch *)sender
{
    self.registerBtn.enabled = sender.isOn;
}

- (IBAction)register:(id)sender
{
    if ([self.nameTextField.text isWhitespaceAndNewlines]) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return;
    }
    
    if ([self.phoneTextField.text isWhitespaceAndNewlines]) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return;
    }
    
    if ([self.passwordField.text isWhitespaceAndNewlines]) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户密码"];
        return;
    }
    
    if ([self.confirmPwdField.text isWhitespaceAndNewlines] || ![self.confirmPwdField.text isEqualToString:self.passwordField.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致，请确认后重新输入"];
        return;
    }
    
    [self beginRegister];
    [HBUser registerUserByName:self.nameTextField.text phoneNum:self.phoneTextField.text password:self.passwordField.text success:^(HBUser *user) {
        [self endRegister:user];
    } failure:^(NSError *error) {
        [self endRegister:nil];
    }];
    
}

- (void)beginRegister
{
    [SVProgressHUD showWithStatus:@"正在注册"];
    self.registerBtn.enabled = NO;
    self.navigationItem.leftBarButtonItem = [[HBRefreshBarButtonItem alloc] init];
}

- (void)endRegister:(HBUser *)user
{
    if (user) {
        [SVProgressHUD dismiss];
        [HBUser changeCurrentUser:user];
        [self.navigationController.presentingViewController dismissModalViewControllerAnimated:YES];
    } else {
        [SVProgressHUD showErrorWithStatus:@"注册失败"];
    }
    self.registerBtn.enabled = YES;
    self.navigationItem.leftBarButtonItem = nil;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Keyboard Notification
- (void)keyboardWillShow:(NSNotification *)notification
{
    if (self.view.window) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (self.view.window) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

@end
