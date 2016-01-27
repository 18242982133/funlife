//
//  CacheManager.h
//  FunLife
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject


- (void) loadSectionsSuccess: (void(^)(NSArray * sectionArray))successBlock
                     waiting: (void(^)())waitingBlock
                      failed: (void(^)())failedBlock;

- (void) loadSectionIndex: (NSInteger)index
                  refresh: (BOOL)isRefresh
                  success: (void(^)(NSString * path))successBlock
                  waiting: (void(^)())waitingBlock
                   failed: (void(^)())failedBlock;

@end
