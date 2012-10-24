//
//  HBMyLocationViewController.m
//  FindLocation
//
//  Created by 吴 辉斌 on 12-9-10.
//  Copyright (c) 2012年 Âê¥ ËæâÊñå. All rights reserved.
//

#import "HBMyLocationViewController.h"
#import <MapKit/MapKit.h>
#import "HBBaiduMap.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "SVProgressHUD.h"
#import "HBRefreshBarButtonItem.h"

@interface HBMyLocationViewController () <MKMapViewDelegate, MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSString *detailAddress;
@property (strong, nonatomic) CLGeocoder *geoCoder;
@property (strong, nonatomic) UIBarButtonItem *rightBarButtonItem;
@end

@implementation HBMyLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的位置";
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"MyLocation"] tag:0];
        self.geoCoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapView showsUserLocation];
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
    self.mapView.userLocation.title = @"位置查询中";
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(sendLocation:)];
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
}

- (void)getGeocodeLocation
{
    [self.geoCoder reverseGeocodeLocation:self.mapView.userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error && placemarks.count) {
            CLPlacemark *placemark = placemarks[0];
            NSString *displayAddress = [NSString stringWithFormat:@"%@%@%@%@", placemark.locality, placemark.subLocality, placemark.thoroughfare, placemark.subThoroughfare];
            self.mapView.userLocation.title = displayAddress;
            self.detailAddress = placemark.name;
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}

- (void)sendLocation:(id)sender
{
    if (![MFMessageComposeViewController canSendText]) {
        [SVProgressHUD showErrorWithStatus:@"您的设备不支持短信服务"];
    } else {
        MFMessageComposeViewController *messageComposeVC = [[MFMessageComposeViewController alloc] init];
        messageComposeVC.messageComposeDelegate = self;
        if (self.detailAddress) {
            messageComposeVC.body = [NSString stringWithFormat:@"我目前在这里：\n%@", self.detailAddress];
            [self presentModalViewController:messageComposeVC animated:YES];
        } else {
            self.navigationItem.rightBarButtonItem = [[HBRefreshBarButtonItem alloc] init];
            [self.geoCoder reverseGeocodeLocation:self.mapView.userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
                self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
                if (!error && placemarks.count) {
                    CLPlacemark *placemark = placemarks[0];
                    self.detailAddress = placemark.name;
                    messageComposeVC.body = [NSString stringWithFormat:@"我目前在这里：\n%@", self.detailAddress];
                    [self presentModalViewController:messageComposeVC animated:YES];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"位置信息获取失败， 请检查网络连接"];
                }
            }];
        }
    }
}

#pragma mark - mapView delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [mapView setCenterCoordinate:mapView.userLocation.location.coordinate animated:YES];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [self getGeocodeLocation];
}

#pragma mark Dismiss SMS view controller
// Dismisses the message composition interface when users tap Cancel or Send.
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
	
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MessageComposeResultFailed:
			[SVProgressHUD showErrorWithStatus:@"短信发送失败"];
			break;
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultSent:
            break;
		default:
			break;
	}
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}

@end
