//
//  HelloTableViewController.m
//  FunLife
//
//  Created by qianfeng on 15/9/1.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "HelloTableViewController.h"
#import "FLGlobal.h"
#import "HelloData.h"
#import "UIViewAdditions.h"
#import "NSString+Frame.h"
#import "HelloCell.h"
#import "ImageFrameView.h"
#import "PhotoViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UserViewController.h"
#import "AllUsersViewController.h"

@interface HelloTableViewController () <CLLocationManagerDelegate>
{
    CLLocationManager * locationManager;
}

@end

@implementation HelloTableViewController

- (void)viewDidLoad {

    self.url = [FLGlobal helloUrl];
    self.path = [FLGlobal helloCachePath];
    self.dataClassName = @"HelloData";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.refreshType = FLRefreshTypeHeader;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    locationManager = [CLLocationManager new];

    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"locationServices disabled, go to settings and open it..... ");
        return;
    }
    
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation * location = locations[0];
    NSLog(@"%f, %f", location.coordinate.latitude, location.coordinate.longitude);
    
    [locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) createDataObjectWithJSONNode: (id) node
{
    HelloData * data = [[HelloData alloc] initWithJSONNode:node];
    
    float margin = 20;
    
    float contentHeight = [data.content heightWithFont:[UIFont systemFontOfSize:17] withinWidth:self.tableView.width-margin];
    if (contentHeight>21*5) {
        data.needExpand = YES;
        data.expanded = NO;
    }
    
    return data;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HelloData * data = self.data[indexPath.row];

    float contentWidth = self.tableView.width - 20;
    float contentHeight = [data.content heightWithFont:[UIFont systemFontOfSize:17] withinWidth:contentWidth];
    
    float expandButtonHeight = 0;

    if (data.needExpand) {
        if (!data.expanded) {
            contentHeight = 21 * 5;
        }
        
        expandButtonHeight = 30;
    }
    
    float imageFrameHeight = [ImageFrameView contentHeightWithImages:data.photoArray withinWidth:contentWidth];
    
    return contentHeight + imageFrameHeight + expandButtonHeight + 122;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * cellID = @"HelloCellID";
    
    HelloCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    // Configure the cell...
    
    HelloData * data = self.data[indexPath.row];
    
    cell.data = data;
    
    [cell.nameButton addTarget:self action:@selector(nameButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.expandButton addTarget:self action:@selector(expandButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    for (UIImageView * imageView in cell.imageFrameView.imageViewArray) {
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
        [imageView addGestureRecognizer:gesture];
        imageView.userInteractionEnabled = YES;
    }
    
    return cell;
}

- (void) imageViewClicked: (UITapGestureRecognizer *) gesture
{
    UIImageView * imageView = (UIImageView *)gesture.view;
    ImageFrameView * imageFrameView = (ImageFrameView *) imageView.superview;
    NSIndexPath * indexPath = [self findIndexPathByView:imageFrameView];
    
    HelloData * data = self.data[indexPath.row];
    NSInteger index = [imageFrameView.imageViewArray indexOfObject:imageView];
    
    [self performSegueWithIdentifier:@"ShowPhoto" sender:@{@"Data":data, @"Index":@(index)}];
}

- (void) nameButtonClicked:(UIButton *) sender
{
    NSIndexPath * indexPath = [self findIndexPathByView:sender];
    HelloData * data = self.data[indexPath.row];
    
    [self performSegueWithIdentifier:@"ShowUser" sender:data];
}

- (void) expandButtonClicked:(UIButton *) sender
{
    NSIndexPath * indexPath = [self findIndexPathByView:sender];
    HelloData * data = self.data[indexPath.row];
    
    data.expanded = !data.expanded;
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (NSIndexPath *) findIndexPathByView: (UIView *) view
{
    UIView * contentView = view.superview.superview;
    
    NSArray * indexPathArray = [self.tableView indexPathsForVisibleRows];
    
    for (NSIndexPath * indexPath in indexPathArray) {
        UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.contentView==contentView) {
            return indexPath;
        }
    }
    
    return nil;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowPhoto"]) {
        PhotoViewController * vc = (PhotoViewController *)segue.destinationViewController;
        
        HelloData * data = sender[@"Data"];
        NSMutableArray * urlArray = [NSMutableArray new];
        for (HelloImageData * imageData in data.photoArray) {
            [urlArray addObject:imageData.url];
        }
        
        vc.urlArray = urlArray;
        vc.index = [sender[@"Index"] integerValue];
    }
    else if([segue.identifier isEqualToString:@"ShowUser"]) {
        UserViewController * vc = segue.destinationViewController;
        vc.userData = sender;
    }
    else if ([segue.identifier isEqualToString:@"ShowAllUsers"]) {
        AllUsersViewController * vc = segue.destinationViewController;
        vc.data = [self.data mutableCopy];
    }
}

@end
