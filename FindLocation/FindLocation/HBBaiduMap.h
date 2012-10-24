//
//  HBBaiduMap.h
//  FindLocation
//
//  Created by 吴 辉斌 on 12-10-4.
//  Copyright (c) 2012年 Âê¥ ËæâÊñå. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

typedef void(^locationBlock)(NSString *detailAddress, NSString *displayAddress);

@interface HBBaiduMap : NSObject

+ (void)getAddressByLocation:(CLLocation *)location
                     success:(locationBlock)successBlock
                     failure:(errorBlock)failureBlock;

@end
