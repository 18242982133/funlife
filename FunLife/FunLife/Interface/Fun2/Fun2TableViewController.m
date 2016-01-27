//
//  Fun2TableViewController.m
//  FunLife
//
//  Created by qianfeng on 15/9/1.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "Fun2TableViewController.h"
#import "FLGlobal.h"
#import "Funny2Data.h"
#import "AFNetworking.h"
#import "Fun2Cell.h"
#import "NSString+Frame.h"
#import "UIViewAdditions.h"
#import "PhotoViewController.h"

@interface Fun2TableViewController () <Fun2CellDelegate>

@end

@implementation Fun2TableViewController

- (void)viewDidLoad {
    
    self.url = [FLGlobal funny2Url];
    self.path = [FLGlobal funny2CachePath];
    self.dataClassName = @"Funny2Data";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.refreshType = FLRefreshTypeAll;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onImageCleaned:) name:@"ImageCleaned" object:nil];
}

- (void) onImageCleaned: (NSNotification *) notify
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) createDataObjectWithJSONNode: (id) node
{
    return [[Funny2Data alloc] initWithJSONNode:node];
}

- (BOOL) footerRefresh
{
    if (![super footerRefresh]) {
        return NO;
    }
    
    Funny2Data * data = [self.data lastObject];
    NSString * url = [FLGlobal funny2MoreUrl:data.addon];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self endFooterRefreshing];
        if (!responseObject) {
            return;
        }
        
        NSInteger index = self.data.count-1;
        
        NSArray * dataArray = responseObject[@"data"];
        for (id item in dataArray) {
            Funny2Data * f2Data = [[Funny2Data alloc] initWithJSONNode:item];
            [self.data addObject:f2Data];
        }
        
        [self.tableView reloadData];
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self endFooterRefreshing];
        NSLog(@"Footer Refresh Network Error");
    }];
    
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Funny2Data * data = self.data[indexPath.row];

    BOOL hasImage = data.previewImageUrl.length!=0;
    
    float contentHeight = [data.content heightWithFont:[UIFont systemFontOfSize:17] withinWidth:self.tableView.width-16];
    
    return 180 + contentHeight - (hasImage?0:128);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * cellID = @"Fun2CellID";
    
    Fun2Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    // Configure the cell...
    
    Funny2Data * data = self.data[indexPath.row];
    
    cell.delegate = self;
    cell.data = data;
    
    return cell;
}

- (void) cellImageButtonClicked:(Fun2Cell *)cell withData:(Funny2Data *)data
{
    [self performSegueWithIdentifier:@"ShowPhoto" sender:data];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ShowPhoto"]) {
        PhotoViewController * vc = (PhotoViewController *)segue.destinationViewController;
        Funny2Data * data = sender;
        vc.urlArray = [NSArray arrayWithObject:data.imageUrl];
        vc.index = 0;
    }
}

@end
