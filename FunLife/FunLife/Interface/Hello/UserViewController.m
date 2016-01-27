//
//  UserViewController.m
//  FunLife
//
//  Created by qianfeng on 15/9/6.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "UserViewController.h"
#import <MapKit/MapKit.h>

@interface UserViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLPlacemark * placemark;
@property (nonatomic) BOOL gotUserLocation;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    NSString * userLocation = self.userData.city;
    if (userLocation.length<2) {
        userLocation = @"山西省 太原市";
    }
    
    CLGeocoder * geocoder = [CLGeocoder new];
    
    [geocoder geocodeAddressString:userLocation
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     self.placemark = placemarks[0];
                     
                     MKPointAnnotation * ann = [MKPointAnnotation new];
                     ann.coordinate = self.placemark.location.coordinate;
                     ann.title = self.userData.name;
                     ann.subtitle = userLocation;
                     [self.mapView addAnnotation:ann];
                     
                     self.mapView.delegate = self;
                     self.mapView.showsUserLocation = YES;
                     self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    }];
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapped:)];
    gesture.numberOfTapsRequired = 3;
    [self.mapView addGestureRecognizer:gesture];
}

- (void) userTapped: (UITapGestureRecognizer *) gesture
{
    CGPoint pt = [gesture locationInView:gesture.view];
   
    CLLocationCoordinate2D location = [self.mapView convertPoint:pt toCoordinateFromView:self.mapView];
    
    CLGeocoder * geocoder = [CLGeocoder new];

    [geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude] completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark * placemark = placemarks[0];
        
        MKPointAnnotation * ann = [MKPointAnnotation new];
        ann.coordinate = location;
        ann.title = [NSString stringWithFormat:@"%@ %@", placemark.country, placemark.administrativeArea];
        ann.subtitle = placemark.name;
        
        [self.mapView addAnnotation:ann];
    }];
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!self.gotUserLocation) {
        self.gotUserLocation = YES;
        
        MKCoordinateSpan span = MKCoordinateSpanMake(fabs(userLocation.coordinate.latitude-self.placemark.location.coordinate.latitude)+1, fabs(userLocation.coordinate.longitude-self.placemark.location.coordinate.longitude)+1);
        
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake((userLocation.coordinate.latitude+self.placemark.location.coordinate.latitude)/2, (userLocation.coordinate.longitude+self.placemark.location.coordinate.longitude)/2);
        
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        [self.mapView setRegion:region animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
