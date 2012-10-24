//
//  HBBaiduMap.m
//  FindLocation
//
//  Created by 吴 辉斌 on 12-10-4.
//  Copyright (c) 2012年 Âê¥ ËæâÊñå. All rights reserved.
//

#import "HBBaiduMap.h"
#import "AFNetworking.h"
#import <MapKit/MapKit.h>

#define kBaiduKey @"e5fae78412b386d0c66bdaaad9fa2780"
#define kGeocoderPath @"http://api.map.baidu.com/geocoder?location=%@&output=json&key=e5fae78412b386d0c66bdaaad9fa2780"

@implementation HBBaiduMap

+ (void)getAddressByLocation:(CLLocation *)location
                     success:(locationBlock)successBlock
                     failure:(errorBlock)failureBlock
{
    NSString *locationString = [NSString stringWithFormat:@"%.6f,%%%.6f", location.coordinate.latitude, location.coordinate.longitude];
    NSString *requestPath = [NSString stringWithFormat:kGeocoderPath, locationString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestPath]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSString *detailAddress = JSON[@"result"][@"formatted_address"];
        NSString *displayAddress = [NSString stringWithFormat:@"%@%@", JSON[@"result"][@"addressComponent"][@"street"], JSON[@"result"][@"addressComponent"][@"street_number"]];
        successBlock(detailAddress, displayAddress);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        failureBlock(error);
    }];
    [operation start];
}

@end
