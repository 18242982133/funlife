//
//  Fun2Cell.h
//  FunLife
//
//  Created by qianfeng on 15/9/1.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Funny2Data.h"

@class Fun2Cell;

@protocol Fun2CellDelegate <NSObject>

- (void) cellImageButtonClicked: (Fun2Cell *)cell
                       withData: (Funny2Data *)data;

@end

@interface Fun2Cell : UITableViewCell

@property (nonatomic, weak) Funny2Data * data;
@property (nonatomic, weak) id<Fun2CellDelegate> delegate;

@end
