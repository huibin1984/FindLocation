//
//  HBLoginViewController.m
//  FindLocation
//
//  Created by 吴 辉斌 on 12-10-5.
//  Copyright (c) 2012年 Âê¥ ËæâÊñå. All rights reserved.
//

#import "HBLoginViewController.h"
#import "NSString+NimbusCore.h"
#import "SVProgressHUD.h"
#import "HBRegisterViewController.h"
#import "HBFindPasswordViewController.h"
#import "HBUser.h"

#define kRememberedNameKey @"RememberedNameKey"
#define kRememberedPasswordKey @"RememberedPasswordKey"

@interface HBLoginViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UISwitch *rememberNameSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rememberPasswordSwitch;
@property (assign, nonatomic) BOOL hasBeganEditing;

@end

@implementation HBLoginViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"用户登陆";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if ([standardUserDefaults valueForKey:kRememberedNameKey]) {
        self.nameTextField.text = [standardUserDefaults valueForKey:kRememberedNameKey];
    }
    if ([standardUserDefaults valueForKey:kRememberedPasswordKey]) {
        self.passwordTextField.text = [standardUserDefaults valueForKey:kRememberedPasswordKey];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.nameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNameTextField:nil];
    [self setPasswordTextField:nil];
    [self setRememberNameSwitch:nil];
    [self setRememberPasswordSwitch:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIKeyboardWillHideNotification];
    [super viewDidUnload];
}

- (IBAction)login:(id)sender
{
    if ([self.nameTextField.text isWhitespaceAndNewlines]) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return;
    }
    
    if ([self.passwordTextField.text isWhitespaceAndNewlines]) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    
    [self beginLogin];
    [HBUser loginByPhoneNum:self.nameTextField.text
                andPassword:self.passwordTextField.text
                    success:^(HBUser *user) {
                        [self endLogin:user error:nil];
                    } failure:^(NSError *error) {
                        [self endLogin:nil error:error];
                    }];
}

- (void)beginLogin
{
    [SVProgressHUD showWithStatus:@"登陆中"];
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            button.enabled = NO;
        }
    }
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (self.rememberNameSwitch.isOn) {
        [standardUserDefaults setObject:self.nameTextField.text forKey:kRememberedNameKey];
    } else {
        [standardUserDefaults removeObjectForKey:kRememberedNameKey];
    }
    
    
    if (self.rememberPasswordSwitch.isOn) {
        [standardUserDefaults setObject:self.passwordTextField.text forKey:kRememberedPasswordKey];
    } else {
        [standardUserDefaults removeObjectForKey:kRememberedPasswordKey];
    }
    
    [standardUserDefaults synchronize];
    
}

- (void)endLogin:(HBUser *)user error:(NSError *)error
{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            button.enabled = YES;
        }
    }
    
    if (!error) {
        if (user) {
            [SVProgressHUD dismiss];
            [HBUser changeCurrentUser:user];
            
            [self.navigationController.presentingViewController dismissModalViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:@"用户名不存在或者密码错误！"];
        }
    } else {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }
}


- (IBAction)rigister:(id)sender
{
    HBRegisterViewController *registerVC = [[HBRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (IBAction)findPassword:(id)sender
{
    HBFindPasswordViewController *findPasswordVC = [[HBFindPasswordViewController alloc] init];
    [self.navigationController pushViewController:findPasswordVC animated:YES];
}

- (IBAction)goToHelpPage:(id)sender
{
    // TODO: now no help images
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
