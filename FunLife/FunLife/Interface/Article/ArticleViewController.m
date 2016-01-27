//
//  ArticleViewController.m
//  FunLife
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "ArticleViewController.h"
#import "CacheManager.h"
#import "ArticleHeaderView.h"
#import "MJRefresh.h"
#import "ArticleData.h"
#import "MBProgressHUD.h"
#import "UIViewAdditions.h"
#import "ArticleCellBase.h"
#import "ArticleContentViewController.h"
#import "ModalPushTransition.h"

@interface ArticleViewController () <ArticleHeaderViewDelegate, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate, UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ArticleHeaderView *headerView;
@property (nonatomic) CacheManager * cacheManager;
@property (nonatomic) NSMutableArray * data;
@property (nonatomic) NSArray * modifyData;

@property (nonatomic, weak) MBProgressHUD * hud;

@property (nonatomic, weak) UITableView * modifyTableView;
@property (nonatomic) ModalPushTransition * animation;


@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.data = [NSMutableArray new];
    
    MBProgressHUD * hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.tableView addSubview:hud];
    hud.delegate = self;
    hud.labelText = @"下载中...";
    [hud hide:NO];
    self.hud = hud;
    
    self.headerView.delegate = self;
    
    self.cacheManager = [CacheManager new];
    
    [self loadSectionsData];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self performSelector:@selector(doRefresh) withObject:nil afterDelay:3];
    }];
    
    self.animation = [ModalPushTransition new];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) doRefresh
{
    [self loadSectionDataAtIndex:self.headerView.selectedIndex refresh:YES];
}

- (void) loadSectionsData
{
    [self.cacheManager loadSectionsSuccess:^(NSArray *sectionArray) {
        self.headerView.sectionArray = sectionArray;
        self.modifyData = sectionArray;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"LastIndex"];
            if (index<sectionArray.count) {
                [self.headerView setSelectedIndex:index animated:YES];
            }
        }];
        
    } waiting:^{
        
    } failed:^{
        [self performSelector:@selector(loadSectionsData) withObject:nil afterDelay:10];
    }];
}

#pragma mark - HeaderViewDelegate

- (void)headerView:(ArticleHeaderView *)headerView selectedIndexChanged:(NSInteger)newIndex
{
    [[NSUserDefaults standardUserDefaults] setInteger:newIndex forKey:@"LastIndex"];
    [self loadSectionDataAtIndex:newIndex refresh:NO];
}

- (void)headerView:(ArticleHeaderView *)headerView setModify: (BOOL)modify
{
    if (!self.modifyTableView) {
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.width/2, self.headerView.bottom, self.view.width/2, 0)];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        
        [self.view addSubview:tableView];
        self.modifyTableView = tableView;
    }
    
    CGRect targetRect = modify ? CGRectMake(self.view.width/2, self.headerView.bottom, self.view.width/2, self.view.height*0.6) :CGRectMake(self.view.width/2, self.headerView.bottom, self.view.width/2, 0);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.modifyTableView.frame = targetRect;
    } completion:^(BOOL finished) {
        
    }];
}

- (void) loadSectionFromFile: (NSString *)sectionPath
{
    NSData * data = [NSData dataWithContentsOfFile:sectionPath];
    
    NSDictionary * object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (!object) {
        return;
    }
    
    [self.data removeAllObjects];
    
    NSArray * dataArray = object[@"items"];
    for (id item in dataArray) {
        ArticleItemData * data = [[ArticleItemData alloc] initWithJSONNode:item];
        [self.data addObject:data];
    }

    [self.tableView reloadData];
}

- (void) loadSectionDataAtIndex: (NSInteger)index refresh: (BOOL)isRefresh
{
    [self.cacheManager loadSectionIndex:index
                                refresh:isRefresh
                                success:^(NSString *path) {
                                    if (index!=self.headerView.selectedIndex) {
                                        return;
                                    }
                                    if (isRefresh) {
                                        [self.tableView.header endRefreshing];
                                    }
                                    else {
                                        [self.hud hide:NO];
                                    }
                                    
                                    [self loadSectionFromFile:path];
                                }
                                waiting:^{
                                    if (!isRefresh) {
                                        [self.hud show:NO];
                                    }
                                }
                                 failed:^{
                                     if (isRefresh) {
                                         [self.tableView.header endRefreshing];
                                         return;
                                     }
                                     [self.hud hide:NO];
                                }];
}

#pragma mark - UITableViewDelegate and DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==self.modifyTableView) {
        return self.modifyData.count;
    }
    
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.modifyTableView) {
        return 36;
    }
    
    ArticleSectionData * data = self.modifyData[self.headerView.selectedIndex];
    
    return [ArticleCellBase cellHeightByType:data.contentType];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==self.modifyTableView) {
        NSString * cellID = @"cell1";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        }
        
        ArticleSectionData * data = self.modifyData[indexPath.row];
        cell.textLabel.text = data.title;
        
        cell.accessoryType = data.hidden ? UITableViewCellAccessoryNone:UITableViewCellAccessoryCheckmark;
        
        return cell;
    }


    ArticleSectionData * data = self.modifyData[self.headerView.selectedIndex];
    
    NSString * cellID = data.contentType;

    ArticleCellBase *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.data = self.data[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.modifyTableView) {
        ArticleSectionData * data = self.modifyData[indexPath.row];
        data.hidden = !data.hidden;

        BOOL bExist = NO;
        for (ArticleSectionData * sectionData in self.modifyData) {
            if (!sectionData.hidden) {
                bExist = YES;
            }
        }
        
        if (!bExist) {
            data.hidden = NO;
            return;
        }
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.headerView updateSectionItemAtIndex:indexPath.row];
    }
    else {
        [self performSegueWithIdentifier:@"ShowContent" sender:indexPath];
    }
        
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.animation.push = YES;
    return self.animation;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.animation.push = NO;
    return self.animation;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ShowContent"]) {
        ArticleContentViewController * vc = (ArticleContentViewController *)segue.destinationViewController;
        NSIndexPath * indexPath = (NSIndexPath *)sender;
        vc.index = indexPath.row;
        vc.data = self.data;
        vc.transitioningDelegate = self;
    }
}

@end
