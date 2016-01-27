//
//  FLAnnotation.h
//  FunLife
//
//  Created by qianfeng on 15/9/6.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FLAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic) NSString * imageUrl;
@property (nonatomic) NSInteger gender;

@end
