//
//  RestTimeViewController.m
//  FunLife
//
//  Created by qianfeng on 15/9/6.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "RestTimeViewController.h"

@interface RestTimeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic) NSDate * startTime;
@property (nonatomic) NSDate * endTime;

@property (nonatomic) BOOL start;

@end

@implementation RestTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString * fromTime = [[NSUserDefaults standardUserDefaults] valueForKey:@"RestStartTime"];
    NSString * toTime = [[NSUserDefaults standardUserDefaults] valueForKey:@"RestEndTime"];

    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"HH:mm"];
    
    self.startTime = [formatter dateFromString:fromTime];
    self.endTime = [formatter dateFromString:toTime];
    
    self.start = NO;
    [self setButtonTitleWithTime];
    
    self.start = YES;
    [self setButtonTitleWithTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setButtonTitleWithTime
{
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"HH:mm"];

    if (self.start) {
        NSString * fromTime = [formatter stringFromDate:self.startTime];
        NSString * title = [@"从 " stringByAppendingString: fromTime];
        [self.startButton setTitle:title forState:UIControlStateNormal];
    }
    else {
        NSString * fromTime = [formatter stringFromDate:self.endTime];
        NSString * title = [@"至 " stringByAppendingString: fromTime];
        [self.endButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)setStart:(BOOL)start
{
    _start = start;
    
    self.startButton.backgroundColor = start ? [UIColor darkGrayColor] : [UIColor whiteColor];
    self.endButton.backgroundColor = start ? [UIColor whiteColor] : [UIColor darkGrayColor];
    
    [self.datePicker setDate:start?self.startTime:self.endTime animated:YES];
}

- (IBAction)startButtonClicked:(UIButton *)sender {
    self.start = YES;
}

- (IBAction)endButtonClicked:(UIButton *)sender {
    self.start = NO;
}

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender
{
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"HH:mm"];
    NSString * timeString = [formatter stringFromDate:sender.date];
        
    if (self.start) {
        self.startTime = sender.date;
        [[NSUserDefaults standardUserDefaults] setObject:timeString forKey:@"RestStartTime"];
    }
    else {
        self.endTime = sender.date;
        [[NSUserDefaults standardUserDefaults] setObject:timeString forKey:@"RestEndTime"];
    }
    
    [self setButtonTitleWithTime];
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
