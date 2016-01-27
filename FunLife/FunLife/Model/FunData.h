//
//  FunData.h
//  FunLife
//
//  Created by qianfeng on 15/8/31.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunData : NSObject

@property (nonatomic) NSString * title;
@property (nonatomic) NSString * subtitle;
@property (nonatomic) NSString * tag;
@property (nonatomic) NSArray * imageArray;

- (FunData *) initWithJSONNode: (id) node;


@end
