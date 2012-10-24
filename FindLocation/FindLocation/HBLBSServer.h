//
//  HBLBSServer.h
//  FindLocation
//
//  Created by 吴 辉斌 on 12-10-12.
//  Copyright (c) 2012年 Âê¥ ËæâÊñå. All rights reserved.
//

@class CLLocation;

@interface HBLBSServer : NSObject

+ (void)updateUserLocationInfoByPhoneNum:(NSString *)phoneNum
                         andLocation:(CLLocation *)location
                             success:(void (^)(void))successBlock
                              failure:(errorBlock)failureBlock;

+ (void)locateFriendLocationByPhoneNum:(NSString *)phoneNum
                          andSessionID:(NSString *)sessionID
                               success:(void (^)(CLLocation *location))successBlock
                               failure:(errorBlock)failureBlock;

@end
