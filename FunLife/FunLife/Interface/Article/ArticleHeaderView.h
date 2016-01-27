//
//  ArticleHeaderView.h
//  FunLife
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArticleHeaderView;

@protocol ArticleHeaderViewDelegate <NSObject>

- (void)headerView: (ArticleHeaderView *)headerView selectedIndexChanged: (NSInteger)newIndex;
- (void)headerView:(ArticleHeaderView *)headerView setModify: (BOOL)modify;

@end

@interface ArticleHeaderView : UIView

@property (nonatomic, weak) NSArray * sectionArray;
@property (nonatomic, weak) id<ArticleHeaderViewDelegate> delegate;
@property (nonatomic) NSInteger selectedIndex;

- (void) updateSectionItemAtIndex: (NSInteger)index;
- (void) setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animate;

@end
