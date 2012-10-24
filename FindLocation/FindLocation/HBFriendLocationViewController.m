//
//  HBFriendLocationViewController.m
//  FindLocation
//
//  Created by 吴 辉斌 on 12-10-1.
//  Copyright (c) 2012年 Âê¥ ËæâÊñå. All rights reserved.
//

#import "HBFriendLocationViewController.h"
#import <MapKit/MapKit.h>
#import "SVProgressHUD.h"
#import "HBLBSServer.h"
#import "HBUser.h"
#import "HBAnnotation.h"
#import "NSString+NimbusCore.h"

@interface HBFriendLocationViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) HBAnnotation *annotation;
@property (strong, nonatomic) CLGeocoder *geoCoder;

@end

@implementation HBFriendLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"朋友位置";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"FriendLocation"] tag:1];
        self.geoCoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (IBAction)searchFriendLocation:(id)sender
{
    [self beginSearchFriendLocation];
    HBUser *currentUser = [HBUser currentUser];
    if (!self.searchBar.text || [self.searchBar.text isWhitespaceAndNewlines]) {
        [SVProgressHUD showErrorWithStatus:@"手机号码不能为空"];
        return;
    }
    
    if (currentUser) {
        [HBLBSServer locateFriendLocationByPhoneNum:self.searchBar.text
                                       andSessionID:currentUser.sessionID
                                            success:^(CLLocation *location) {
                                                [self endSearchFriendLocation:location error:nil];
                                            } failure:^(NSError *error) {
                                                [self endSearchFriendLocation:nil error:error];
                                            }];
    }

}

- (void)beginSearchFriendLocation
{
    [self.searchBar resignFirstResponder];
    [SVProgressHUD showWithStatus:@"好友定位中"];
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)endSearchFriendLocation:(CLLocation *)location error:(NSError *)error
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"获取好友定位失败,请检查网络情况"];
    } else {
        if (location) {
            [SVProgressHUD dismiss];
            self.annotation = [[HBAnnotation alloc] init];
            self.annotation.coordinate = location.coordinate;
            [self.mapView addAnnotation:self.annotation];
            
            [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
                if (!error && placemarks.count) {
                    CLPlacemark *placemark = placemarks[0];
                    NSString *displayAddress = [NSString stringWithFormat:@"%@%@%@%@", placemark.locality, placemark.subLocality, placemark.thoroughfare, placemark.subThoroughfare];
                    self.annotation.title = displayAddress;
                }
            }];
            
            
        } else {
            [SVProgressHUD showErrorWithStatus:@"获取好友定位失败"];
        }
    }
}


@end
