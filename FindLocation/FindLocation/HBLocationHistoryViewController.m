//
//  HBLocationHistoryViewController.m
//  FindLocation
//
//  Created by 吴 辉斌 on 12-10-3.
//  Copyright (c) 2012年 Âê¥ ËæâÊñå. All rights reserved.
//

#import "HBLocationHistoryViewController.h"

@interface HBLocationHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumField;
@property (weak, nonatomic) IBOutlet UITextField *startTimeField;
@property (weak, nonatomic) IBOutlet UITextField *endTextField;

@end

@implementation HBLocationHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil];
    if (self) {
        self.title = @"历史位置查询";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"Setting"] tag:0];
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

- (NSArray *)textFields
{
    return @[self.phoneNumField, self.startTimeField, self.endTextField];
}

- (void)resignTextFieldsFirstResponder
{
    for (UITextField *textField in [self textFields]) {
        [textField resignFirstResponder];
    }
}

- (IBAction)findFriendInAB:(id)sender
{
    [self resignFirstResponder];
}

- (IBAction)selectStartTime:(id)sender
{
    [self resignFirstResponder];
}

- (IBAction)selectEndTime:(id)sender
{
    [self resignFirstResponder];
}

- (IBAction)findLocation:(id)sender
{
    [self resignFirstResponder];
}

- (void)viewDidUnload {
    [self setPhoneNumField:nil];
    [self setStartTimeField:nil];
    [self setEndTextField:nil];
    [super viewDidUnload];
}
@end
