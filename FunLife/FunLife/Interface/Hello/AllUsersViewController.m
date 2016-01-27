//
//  AllUsersViewController.m
//  FunLife
//
//  Created by qianfeng on 15/9/6.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "AllUsersViewController.h"
#import <MapKit/MapKit.h>
#import "HelloData.h"
#import "FLAnnotation.h"
#import "UIImageView+WebCache.h"

@interface AllUsersViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation AllUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView.delegate = self;
    
    [self decodeAddress];
}

- (void) decodeAddress
{
    HelloData * data = self.data[0];
    if (data.city.length<2) {
        [self.data removeObject:data];
        if (self.data.count==0) {
            return;
        }
        
        [self decodeAddress];
        return;
    }
    
    CLGeocoder * geocoder = [CLGeocoder new];
    [geocoder geocodeAddressString:data.city completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark * placemark = placemarks[0];
        
        FLAnnotation * ann = [FLAnnotation new];
        ann.coordinate = placemark.location.coordinate;
        ann.title = data.name;
        ann.subtitle = data.city;
        ann.imageUrl = data.iconUrl;
        ann.gender = data.gender;
        
        [self.mapView addAnnotation:ann];
        
        [self.data removeObject:data];
        if (self.data.count==0) {
            return;
        }
        
        [self decodeAddress];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[FLAnnotation class]]) {
        NSString * annID = @"FLAID";
        MKAnnotationView * annView = [mapView dequeueReusableAnnotationViewWithIdentifier:annID];
        if (!annView) {
            annView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annID];
            annView.canShowCallout = YES;
            
            UIImageView * iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            iconView.layer.cornerRadius = 4;
            iconView.clipsToBounds = YES;
            
            annView.leftCalloutAccessoryView = iconView;
            
            annView.rightCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        }
        
        FLAnnotation * flAnnotation = (FLAnnotation *) annotation;
        UIImageView * iconView = (UIImageView *)annView.leftCalloutAccessoryView;
        [iconView sd_setImageWithURL:[NSURL URLWithString:flAnnotation.imageUrl]];
        
        UIImageView * genderView = (UIImageView *)annView.rightCalloutAccessoryView;
        genderView.image = [UIImage imageNamed:flAnnotation.gender==0?@"icon_male":@"icon_female"];
        
        annView.image = [UIImage imageNamed:@"icon_marker"];
        
        return annView;
    }
    else {
        return nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
