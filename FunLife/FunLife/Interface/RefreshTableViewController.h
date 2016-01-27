//
//  RefreshTableViewController.h
//  FunLife
//
//  Created by qianfeng on 15/9/1.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RefreshType)
{
    FLRefreshTypeHeader = 1,
    FLRefreshTypeFooter = 1 << 1,
    FLRefreshTypeAll = FLRefreshTypeHeader | FLRefreshTypeFooter
};

@interface RefreshTableViewController : UITableViewController

@property (nonatomic) NSMutableArray * data;

@property (nonatomic) RefreshType refreshType;
@property (nonatomic) NSURL * url;
@property (nonatomic) NSString * path;

@property (nonatomic) NSString * dataClassName;

- (id) createDataObjectWithJSONNode: (id) node;
- (BOOL) footerRefresh;
- (void) endFooterRefreshing;

@end
