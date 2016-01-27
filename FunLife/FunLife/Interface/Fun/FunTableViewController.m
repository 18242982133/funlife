//
//  FunTableViewController.m
//  FunLife
//
//  Created by qianfeng on 15/8/31.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "FunTableViewController.h"
#import "UIViewAdditions.h"
#import "ASIHTTPRequest.h"
#import "FLGlobal.h"
#import "FunCellBase.h"

@interface FunTableViewController ()

@property (nonatomic) NSArray * data;

@end

@implementation FunTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.5];
    
}

- (void) loadData
{
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[FLGlobal funnyUrl]];
    request.delegate = self;
    
    [request startAsynchronous];
}

- (void) requestFinished: (ASIHTTPRequest *) request
{
//    NSLog(@"%@", request.responseString);
    NSDictionary * object = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if (!object) {
        NSLog(@"JSON error");
        return;
    }
    
    NSMutableArray * array = [NSMutableArray new];
    NSArray * dataArray = object[@"items"];
    for (id item in dataArray) {
        FunData * data = [[FunData alloc] initWithJSONNode:item];
        [array addObject:data];
    }
    
    self.data = array;
    [self.tableView reloadData];
}

- (void) requestFailed: (ASIHTTPRequest *) request
{
    NSLog(@"Request Failed");
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row==0 ? self.tableView.width*0.45 : 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellID = indexPath.row==0 ? @"LargeCell" : @"SmallCell";
    FunCellBase *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    // Configure the cell...
    cell.data = self.data[indexPath.row];
    
    return cell;
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
