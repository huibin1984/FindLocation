//
//  HBLBSServer.m
//  FindLocation
//
//  Created by 吴 辉斌 on 12-10-12.
//  Copyright (c) 2012年 Âê¥ ËæâÊñå. All rights reserved.
//

#import "HBLBSServer.h"
#import "HBUser.h"
#import "HBHTTPClient.h"
#import "AFNetworking.h"
#import <MapKit/MapKit.h>

@implementation HBLBSServer

+ (void)updateUserLocationInfoByPhoneNum:(NSString *)phoneNum
                         andLocation:(CLLocation *)location
                             success:(void (^)(void))successBlock
                             failure:(errorBlock)failureBlock
{
    NSMutableURLRequest *request = [HBHTTPClient updateUserInfoWithUserPhoneNum:phoneNum andLocaton:location];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([operation.responseString isEqualToString:@"true"]) {
            successBlock();
        } else {
            failureBlock(nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Update user location request error:\n%@", error);
        failureBlock(error);
    }];
    
    [operation start];
}

+ (void)locateFriendLocationByPhoneNum:(NSString *)phoneNum
                          andSessionID:(NSString *)sessionID
                               success:(void (^)(CLLocation *))successBlock
                               failure:(errorBlock)failureBlock
{
    NSMutableURLRequest *request = [HBHTTPClient locateFreindLocationWithPhoneNum:phoneNum andSessionID:sessionID];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSInteger resultNum = [JSON[@"0"] integerValue];
        if (resultNum == 0) {
            successBlock(nil);
        } else {
            NSDictionary *locationData = JSON[@"1"];
            NSString *locationString = locationData[@"gpscoordinate"];
            NSArray *array = [locationString componentsSeparatedByString:@","];
            CLLocationDegrees latitude = [[array[0] substringFromIndex:1] doubleValue];
            CLLocationDegrees longtitude = [[array[1] substringToIndex:(((NSString *)array[1]).length-2)] doubleValue];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longtitude];
            successBlock(location);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Locate friend location request error:\n%@", error);
        failureBlock(error);
    }];
    
    [operation start];
}

@end
