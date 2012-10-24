//
//  HBHTTPClient.m
//  FindLocation
//
//  Created by 吴 辉斌 on 12-10-3.
//  Copyright (c) 2012年 Âê¥ ËæâÊñå. All rights reserved.
//

#import "HBHTTPClient.h"
#import <MapKit/MapKit.h>

#define kHostName @"http://www.lbs001.cn/lbs"
#define kUserRegisertPath @"appRegister.action"
#define kUserLoginPath @"appLogin.action"
#define kUserFindPasswordPath @"appGetPassword.action"
#define kUserUpoadLocationInfo @"appUploadLocationInfo.action"
#define kLocateFrinedLocation @"appLocationSearch.action"

#define kGETMethod @"GET"
#define KPostMethod @"POST"

static HBHTTPClient *sharedHttpClient = nil;

@implementation HBHTTPClient

+ (HBHTTPClient *)sharedHttpClient
{
    if (sharedHttpClient == nil) {
        NSURL *baseURL = [NSURL URLWithString:kHostName];
        sharedHttpClient = [[super alloc] initWithBaseURL:baseURL];
    }
    return sharedHttpClient;
}

+ (NSMutableURLRequest *)registerRequestWithUserName:(NSString *)name phoneNum:(NSString *)phoneNum andPassword:(NSString *)password
{
    NSDictionary *parameters = @{@"strUserName" : name, @"strMobileNum" : phoneNum, @"strUserPassword" : password};
    return [[self sharedHttpClient] requestWithMethod:KPostMethod path:kUserRegisertPath parameters:parameters];
}

+ (NSMutableURLRequest *)loginRequestWithPhoneNum:(NSString *)phoneNum andPassword:(NSString *)password
{
    NSDictionary *parameters = @{@"strMobileNum" : phoneNum, @"strUserPassword" : password};
    return [[self sharedHttpClient] requestWithMethod:KPostMethod path:kUserLoginPath parameters:parameters];
}

+ (NSMutableURLRequest *)findPasswordRequestWithPhoneNum:(NSString *)phoneNum
{
    NSDictionary *parameters = @{@"strMobileNum" : phoneNum};
    return [[self sharedHttpClient] requestWithMethod:KPostMethod path:kUserFindPasswordPath parameters:parameters];
}

+ (NSMutableURLRequest *)updateUserInfoWithUserPhoneNum:(NSString *)phoneNum andLocaton:(CLLocation *)location
{
    NSString *locationStr = [NSString stringWithFormat:@"(%.15f,%.15f)", location.coordinate.latitude, location.coordinate.longitude];
    NSDictionary *parameters = @{@"strUserId" : phoneNum, @"strUserLocation" : locationStr, @"strUpdataType" : @"true"};
    return [[self sharedHttpClient] requestWithMethod:KPostMethod path:kUserUpoadLocationInfo parameters:parameters];
}

+ (NSMutableURLRequest *)locateFreindLocationWithPhoneNum:(NSString *)phoneNum andSessionID:(NSString *)sessionID
{
    NSDictionary *parameters = @{@"strSearchMobileNum" : phoneNum, @"sessionid" : sessionID};
    return [[self sharedHttpClient] requestWithMethod:KPostMethod path:kLocateFrinedLocation parameters:parameters];
}

@end
