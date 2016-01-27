//
//  RefreshTableViewController.m
//  FunLife
//
//  Created by qianfeng on 15/9/1.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "RefreshTableViewController.h"
#import "MJRefresh.h"
#import "AFNetworking.h"

@interface RefreshTableViewController ()

@end

@implementation RefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.data = [NSMutableArray new];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.path]) {
        NSLog(@"file exist");
        [self loadFromFile];
    }
    else {
        [self loadDataFromServer];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setRefreshType:(RefreshType)refreshType
{
    _refreshType = refreshType;
    
    if (refreshType & FLRefreshTypeHeader) {
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    }
    if (refreshType & FLRefreshTypeFooter) {
        self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    }
}

- (void) headerRefresh
{
    [self loadDataFromServer];
}

- (void) loadDataFromServer
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:[self.url absoluteString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.header endRefreshing];
        if (!responseObject) {
            return;
        }
        [operation.responseData writeToFile:self.path atomically:NO];
        [self loadFromFile];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.header endRefreshing];
        
        NSLog(@"load data from server network error");
    }];
}

- (void) loadFromFile
{
    NSData * data = [NSData dataWithContentsOfFile:self.path];
    
    NSDictionary * object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (!object) {
        return;
    }
    
    [self.data removeAllObjects];
    
    NSArray * dataArray = object[@"data"];
    
    for (id item in dataArray) {
        id dataObject = [self createDataObjectWithJSONNode:item];
  
//        id dataObject = [NSClassFromString(self.dataClassName) alloc];
//        [dataObject performSelector:@selector(initWithJSONNode:) withObject:item];
        
        [self.data addObject:dataObject];
    }
    
    [self.tableView reloadData];
    
}

- (id) createDataObjectWithJSONNode: (id) node
{
    NSLog(@"Please don't use this method, use derives.");
    return nil;
}

- (BOOL) footerRefresh
{
    if (self.data.count==0) {
        [self.tableView.footer endRefreshing];
        return NO;
    }
    
    return YES;
}

- (void) endFooterRefreshing
{
    [self.tableView.footer endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
