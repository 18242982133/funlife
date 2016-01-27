//
//  ArticleCellBase.m
//  FunLife
//
//  Created by qianfeng on 15/9/9.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "ArticleCellBase.h"

@implementation ArticleCellBase

+ (float) cellHeightByType: (NSString *)type
{
    if ([type isEqualToString:@"TYPE1"]) {
        return 80.;
    }
    else if ([type isEqualToString:@"TYPE2"]) {
        return 120.;
    }
    return 60.;
}

@end
