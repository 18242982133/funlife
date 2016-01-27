//
//  MoreTableViewController.m
//  FunLife
//
//  Created by qianfeng on 15/9/2.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "MoreTableViewController.h"

@interface MoreTableViewController ()
{
    BOOL showRestTime;
}

@property (weak, nonatomic) IBOutlet UITableViewCell *addFriendCell;

@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;


@end

@implementation MoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    showRestTime = YES;
}

- (IBAction)addFriendSwitchValueChanged:(UISwitch *)sender
{
    self.addFriendCell.textLabel.enabled = sender.isOn;
    
    self.addFriendCell.contentView.userInteractionEnabled = sender.isOn ? YES : NO;
}

- (IBAction)restSwitchValueChanged:(UISwitch *)sender {
    showRestTime = sender.isOn;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadRestTime
{
    NSString * fromTime = [[NSUserDefaults standardUserDefaults] valueForKey:@"RestStartTime"];
    NSString * toTime = [[NSUserDefaults standardUserDefaults] valueForKey:@"RestEndTime"];
    
    if (fromTime.length==0) {
        fromTime = @"22:00";
        toTime = @"06:00";
        
        [[NSUserDefaults standardUserDefaults] setObject:fromTime forKey:@"RestStartTime"];
        [[NSUserDefaults standardUserDefaults] setObject:toTime forKey:@"RestEndTime"];
    }
    
    self.fromLabel.text = fromTime;
    self.toLabel.text = toTime;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadRestTime];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==2) {
        return showRestTime ? 2 : 1;
    }
    
    return [super tableView:tableView numberOfRowsInSection:section];
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
