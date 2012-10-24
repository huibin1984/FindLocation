//
//  HBTabBarViewController.m
//  FindLocation
//
//  Created by 吴 辉斌 on 12-9-3.
//  Copyright (c) 2012年 Âê¥ ËæâÊñå. All rights reserved.
//

#import "HBTabBarViewController.h"
#import "HBMyLocationViewController.h"
#import "HBFriendLocationViewController.h"
#import "HBLocationHistoryViewController.h"
#import "HBLoginViewController.h"
#import "HBLBSServer.h"
#import "HBUser.h"

#import <CoreLocation/CoreLocation.h>

@interface HBTabBarViewController ()<CLLocationManagerDelegate>

@property (strong, nonatomic) HBMyLocationViewController *myLocationVC;
@property (strong, nonatomic) HBFriendLocationViewController *frientLocationVC;
@property (strong, nonatomic) HBLocationHistoryViewController *locationHistoryVC;
@property (strong, nonatomic) HBLoginViewController *loginVC;

@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation HBTabBarViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self performSelector:@selector(presentLoginVC) withObject:nil afterDelay:.0];
    
    [self.locationManager startUpdatingLocation];
    
}

- (void)presentLoginVC
{
    UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:self.loginVC];
    [self presentViewController:loginNavC animated:NO completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    UINavigationController *navMyLocationVC = [[UINavigationController alloc] initWithRootViewController:self.myLocationVC];
    UINavigationController *navLocationHistoryVC = [[UINavigationController alloc] initWithRootViewController:self.locationHistoryVC];
    self.viewControllers = @[self.frientLocationVC, navMyLocationVC, navLocationHistoryVC];
}

- (HBLoginViewController *)loginVC
{
    if (!_loginVC) {
        _loginVC = [[HBLoginViewController alloc] init];
    }
    return _loginVC;
}

- (HBMyLocationViewController *)myLocationVC
{
    if (!_myLocationVC) {
        _myLocationVC = [[HBMyLocationViewController alloc] init];
    }
    return _myLocationVC;
}

- (HBFriendLocationViewController *)frientLocationVC
{
    if (!_frientLocationVC) {
        _frientLocationVC = [[HBFriendLocationViewController alloc] init];
    }
    return _frientLocationVC;
}

- (HBLocationHistoryViewController *)locationHistoryVC
{
    if (!_locationHistoryVC) {
        _locationHistoryVC = [[HBLocationHistoryViewController alloc] initWithNibName:NSStringFromClass([HBLocationHistoryViewController class]) bundle:nil];
    }
    return _locationHistoryVC;
}

#pragma mark - Location Manager and Delegate
- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        _locationManager.distanceFilter = 250;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // If it's a relatively recent event, turn off updateds to save power
    NSDate *eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceDate:oldLocation.timestamp];
    if (abs(howRecent) > 10.0) {
        HBUser *currentUser = [HBUser currentUser];
        if (currentUser && newLocation) {
            [HBLBSServer updateUserLocationInfoByPhoneNum:currentUser.phoneNumber andLocation:newLocation success:^{
                // do nothing
            } failure:^(NSError *error) {
                // do nothing
            }];
        }

//        NSLog(@"latitude %+.6f, longitude %+.6f\n", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    }
    // else skip the event and process the next one.
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
//    NSLog(@"Location error: %@", error);
}

@end
