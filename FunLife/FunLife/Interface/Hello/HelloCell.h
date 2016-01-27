//
//  HelloCell.h
//  FunLife
//
//  Created by qianfeng on 15/9/2.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageFrameView.h"
#import "HelloData.h"

@interface HelloCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet ImageFrameView *imageFrameView;
@property (weak, nonatomic) IBOutlet UIButton *expandButton;

@property (nonatomic, weak) HelloData * data;

@end
