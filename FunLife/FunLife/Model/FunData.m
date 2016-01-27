//
//  FunData.m
//  FunLife
//
//  Created by qianfeng on 15/8/31.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "FunData.h"

@implementation FunData

- (FunData *) initWithJSONNode: (id) node
{
    self = [super init];
    if (self) {
        self.title = node[@"title"];
        self.subtitle = node[@"subtitle"];
        self.tag = node[@"tag"];
        self.imageArray = node[@"items"];
        
    }
    
    return self;
}

@end
