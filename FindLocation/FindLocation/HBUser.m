//
//  HBUser.m
//  FindLocation
//
//  Created by 吴 辉斌 on 12-10-3.
//  Copyright (c) 2012年 吴 辉斌. All rights reserved.
//

#import "HBUser.h"
#import "AFNetworking.h"
#import "HBHTTPClient.h"
#import <MapKit/MapKit.h>

static HBUser *currentUser;

@implementation HBUser

- (id)initWithUserData:(NSDictionary *)userData
{
    self = [self init];
    if ([userData isKindOfClass:[NSDictionary class]]) {
        self.name = userData[@"userName"];
        self.sessionID = userData[@"sessionId"];
    }
    return self;
}

+ (HBUser *)currentUser
{
    return currentUser;
}

+ (void)changeCurrentUser:(HBUser *)user
{
    currentUser = user;
}

+ (void)registerUserByName:(NSString *)name
                  phoneNum:(NSString *)phoneNum
                  password:(NSString *)password
                   success:(UserBlock)successBlock
                    failure:(errorBlock)failureBlock
{
    NSMutableURLRequest *request = [HBHTTPClient registerRequestWithUserName:name phoneNum:phoneNum andPassword:password];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSDictionary *userData = JSON;
        HBUser *user = [[HBUser alloc] initWithUserData:userData[@"1"]];
        user.phoneNumber = phoneNum;
        if (user) {
            successBlock(user);
        } else {
            successBlock(nil);
        }
        successBlock(user);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"User register error:\n%@", error);
        failureBlock(error);
    }];
    [operation start];
}

+ (void)findPasswordByPhoneNum:(NSString *)phoneNum
                       success:(void (^)(BOOL))successBlock
                       failure:(errorBlock)failureBlock
{
    NSMutableURLRequest *request = [HBHTTPClient findPasswordRequestWithPhoneNum:phoneNum];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *resultString = operation.responseString;
        if ([resultString isEqualToString:@"true"]) {
            successBlock(YES);
        } else {
            successBlock(NO);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Find password request error:\n%@", error);
        failureBlock(error);
    }];
    [operation start];
}

+ (void)loginByPhoneNum:(NSString *)phoneNum
            andPassword:(NSString *)password
                success:(UserBlock)successBlock
                failure:(errorBlock)failureBlock
{
    NSMutableURLRequest *request = [HBHTTPClient loginRequestWithPhoneNum:phoneNum andPassword:password];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        id userData = ((NSDictionary *)JSON)[@"1"];
        HBUser *user = nil;
        if ([userData isKindOfClass:[NSDictionary class]]) {
            user = [[HBUser alloc] initWithUserData:userData];
            user.phoneNumber = phoneNum;
        }
        
        if (user) {
            successBlock(user);
        } else {
            successBlock(nil);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Login request error:\n%@", error);
        failureBlock(error);
    }];
    [operation start];
}

@end
