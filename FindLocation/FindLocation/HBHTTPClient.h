//
//  HBHTTPClient.h
//  FindLocation
//
//  Created by 吴 辉斌 on 12-10-3.
//  Copyright (c) 2012年 Âê¥ ËæâÊñå. All rights reserved.
//

#import "AFHTTPClient.h"
//typedef void(^errorBlock)(NSError *error);

@class CLLocation;

@interface HBHTTPClient : AFHTTPClient

+ (HBHTTPClient *)sharedHttpClient;

+ (NSMutableURLRequest *)registerRequestWithUserName:(NSString *)name phoneNum:(NSString *)phoneNum andPassword:(NSString *)password;
+ (NSMutableURLRequest *)loginRequestWithPhoneNum:(NSString *)phoneNum andPassword:(NSString *)password;
+ (NSMutableURLRequest *)findPasswordRequestWithPhoneNum:(NSString *)phoneNum;
+ (NSMutableURLRequest *)updateUserInfoWithUserPhoneNum:(NSString *)phoneNum andLocaton:(CLLocation *)location;
+ (NSMutableURLRequest *)locateFreindLocationWithPhoneNum:(NSString *)phoneNum andSessionID:(NSString *)sessionID;
@end
