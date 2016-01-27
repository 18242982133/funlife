//
//  ArticleHeaderView.m
//  FunLife
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "ArticleHeaderView.h"
#import "Masonry.h"
#import "UIViewAdditions.h"
#import "ArticleData.h"

#define SECTION_ITEM_WIDTH  50.
#define FRAME_LINE_HEIGHT   2.


@interface ArticleHeaderView ()

@property (nonatomic, weak) IBOutlet UIScrollView * scrollView;
@property (nonatomic, weak) IBOutlet UIButton * modifyButton;

@property (nonatomic, weak) UIView * leftView;
@property (nonatomic, weak) UIView * indicatorView;

@property (nonatomic) NSArray * buttonArray;
@property (nonatomic) NSArray * frameLineArray;

@property (nonatomic, readonly) UIButton * currentButton;
@property (nonatomic, getter=isModify) BOOL modify;
@end

@implementation ArticleHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _selectedIndex = -1;
    
    UIImage * image = [[UIImage imageNamed:@"dropdown"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.modifyButton.tintColor = [UIColor whiteColor];
    
    [self.modifyButton setImage:image forState:UIControlStateNormal];
}

- (void)setSectionArray:(NSArray *)sectionArray
{
    _sectionArray = sectionArray;
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:leftView];
    self.leftView = leftView;
    
    float leftViewWidthConstraint = 0;
    float contentWidth = sectionArray.count * SECTION_ITEM_WIDTH;
    if (contentWidth<self.scrollView.width) {
        leftViewWidthConstraint = (self.scrollView.width-contentWidth) / 2;
    }
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@(leftViewWidthConstraint));
        make.height.equalTo(@44);
    }];
    
    NSMutableArray * buttonArray = [NSMutableArray arrayWithCapacity:sectionArray.count];
    NSMutableArray * frameLineArray = [NSMutableArray arrayWithCapacity:sectionArray.count];
    
    for (ArticleSectionData * data in sectionArray) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:data.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        [buttonArray addObject:button];
        
        UIView * frameLine = [[UIView alloc] initWithFrame:CGRectZero];
        [self.scrollView addSubview:frameLine];
        [frameLineArray addObject:frameLine];
    }
    self.buttonArray = buttonArray;
    self.frameLineArray = frameLineArray;
    
    for (NSInteger i=0; i<self.buttonArray.count; i++) {
        UIButton * button = self.buttonArray[i];
        UIView * lastView = i==0 ? self.leftView : self.buttonArray[i-1];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastView.mas_right);
            make.top.equalTo(@5);
            make.width.equalTo(@(SECTION_ITEM_WIDTH));
            make.height.equalTo(@(30));
        }];
        
        UIView * view = self.frameLineArray[i];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastView.mas_right).offset(5);
            make.top.equalTo(button.mas_bottom).offset(7);
            make.width.equalTo(@(SECTION_ITEM_WIDTH-10));
            make.height.equalTo(@(FRAME_LINE_HEIGHT));
        }];
    }
    
    UIView * indicatorView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:indicatorView];
    indicatorView.backgroundColor = [UIColor redColor];
    self.indicatorView = indicatorView;
    
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.scrollView.height);
    
}

- (UIButton *)currentButton
{
    return self.buttonArray[self.selectedIndex];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex==selectedIndex) {
        return;
    }
    
    if (_selectedIndex>=0) {
        self.currentButton.selected = NO;
        UIView * frameLine = self.frameLineArray[self.selectedIndex];
        frameLine.backgroundColor = [UIColor blackColor];
    }
    
    _selectedIndex = selectedIndex;
    self.currentButton.selected = YES;
    
    UIView * frameLine = self.frameLineArray[self.selectedIndex];
    self.indicatorView.frame = frameLine.frame;
    self.indicatorView.hidden = YES;
    frameLine.backgroundColor = [UIColor redColor];

    if (self.currentButton.frame.origin.x+SECTION_ITEM_WIDTH>self.scrollView.contentOffset.x+self.scrollView.width) {
        [self.scrollView scrollRectToVisible:self.currentButton.frame animated:NO];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:selectedIndexChanged:)]) {
        [self.delegate headerView:self selectedIndexChanged:selectedIndex];
    }
}

- (void) setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animate
{
    if (!animate) {
        self.selectedIndex = selectedIndex;
        return;
    }
    
    if (_selectedIndex==selectedIndex) {
        return;
    }
    
    if (_selectedIndex>=0) {
        self.currentButton.selected = NO;
        UIView * frameLine = self.frameLineArray[self.selectedIndex];
        frameLine.backgroundColor = [UIColor blackColor];
    }
    
    _selectedIndex = selectedIndex;
    self.currentButton.selected = YES;
    self.indicatorView.hidden = NO;
    
    UIView * frameLine = self.frameLineArray[self.selectedIndex];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.indicatorView.frame = frameLine.frame;
    } completion:^(BOOL finished) {
        self.indicatorView.hidden = YES;
        frameLine.backgroundColor = [UIColor redColor];
        if (self.currentButton.frame.origin.x+SECTION_ITEM_WIDTH>self.scrollView.contentOffset.x+self.scrollView.width) {
            [self.scrollView scrollRectToVisible:self.currentButton.frame animated:YES];
        }
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:selectedIndexChanged:)]) {
        [self.delegate headerView:self selectedIndexChanged:selectedIndex];
    }
}

- (void) sectionButtonClicked: (UIButton *) sender
{
    NSInteger index = [self.buttonArray indexOfObject:sender];
    if (index==self.selectedIndex) {
        return;
    }
    
    [self setSelectedIndex:index animated:YES];
}

- (IBAction)modifyButtonClicked:(UIButton *)sender
{
    float angle = self.modify ? 0 : M_PI;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.modifyButton.transform = CGAffineTransformMakeRotation(angle);
    } completion:^(BOOL finished) {
        self.modify = !self.modify;
        if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:setModify:)]) {
            [self.delegate headerView: self setModify:self.modify];
        }
    }];
}

- (float) getVisibleButtonsTotalWidth
{
    float width = 0;
    for (ArticleSectionData * data in self.sectionArray) {
        if (!data.hidden) {
            width += SECTION_ITEM_WIDTH;
        }
    }
    
    return width;
}

- (NSInteger) getAvailableSelectIndex
{
    if (self.selectedIndex>1) {
        for (NSInteger i=_selectedIndex-1; i>=0; i--) {
            ArticleSectionData * data = self.sectionArray[i];
            if (!data.hidden) {
                return i;
            }
        }
    }
    
    for (NSInteger i=_selectedIndex+1; i<self.sectionArray.count; i++) {
        ArticleSectionData * data = self.sectionArray[i];
        if (!data.hidden) {
            return i;
        }
    }
    
    return -1;
}

- (void) updateSectionItemAtIndex: (NSInteger)index
{
    if (index==self.selectedIndex) {
        self.selectedIndex = [self getAvailableSelectIndex];
    }
    
    ArticleSectionData * data = self.sectionArray[index];
    
    UIButton * button = self.buttonArray[index];
    UIView * frameLine = self.frameLineArray[index];
    
    button.hidden = data.hidden;
    
    [button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(data.hidden?@0:@(SECTION_ITEM_WIDTH));
    }];
    
    [frameLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(data.hidden?@0:@(SECTION_ITEM_WIDTH-10));
    }];
    
    float leftViewWidthConstraint = 0;
    float contentWidth = [self getVisibleButtonsTotalWidth];
    if (contentWidth<self.scrollView.width) {
        leftViewWidthConstraint = (self.scrollView.width-contentWidth) / 2;
    }
    
    [self.leftView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(leftViewWidthConstraint));
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.scrollView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.scrollView.contentSize = CGSizeMake(contentWidth, self.scrollView.height);
    }];
}

@end
