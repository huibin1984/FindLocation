//
//  HBUser.h
//  FindLocation
//
//  Created by 吴 辉斌 on 12-10-3.
//  Copyright (c) 2012年 吴 辉斌. All rights reserved.
//

@class HBUser;
typedef void(^UserBlock)(HBUser *user);

@interface HBUser : NSObject

@property (strong, readwrite) NSString *phoneNumber;
@property (strong, readwrite) NSString *name;
@property (strong, readwrite) NSString *sessionID;

+ (HBUser *)currentUser;
+ (void)changeCurrentUser:(HBUser *)user;


+ (void)registerUserByName:(NSString *)name
                  phoneNum:(NSString *)phoneNum
                  password:(NSString *)password
                   success:(UserBlock)successBlock
                    failure:(errorBlock)failureBlock;

+ (void)findPasswordByPhoneNum:(NSString *)phoneNum
                       success:(void (^)(BOOL result))successBlock
                       failure:(errorBlock)failureBlock;

+ (void)loginByPhoneNum:(NSString *)phoneNum
            andPassword:(NSString *)password
                success:(UserBlock)successBlock
                failure:(errorBlock)failureBlock;

@end
