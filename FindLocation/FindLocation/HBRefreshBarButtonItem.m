//
//  HBRefreshBarButtonItem.m
//  FindLocation
//
//  Created by 吴 辉斌 on 12-10-12.
//  Copyright (c) 2012年 Âê¥ ËæâÊñå. All rights reserved.
//

#import "HBRefreshBarButtonItem.h"

@implementation HBRefreshBarButtonItem

- (id)init
{
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self = [super init];
    self.customView = indicatorView;
    [indicatorView startAnimating];
    return self;
}

@end
