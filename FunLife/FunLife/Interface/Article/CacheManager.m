//
//  CacheManager.m
//  FunLife
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 HYZ. All rights reserved.
//

#import "CacheManager.h"
#import "AFNetworking.h"
#import "ArticleData.h"
#import "FLGlobal.h"

@interface CacheManager ()

@property (nonatomic) NSString * baseUrl;
@property (nonatomic) NSArray * sectionArray;

@property (nonatomic, getter=isDownloading) BOOL downloading;

@end

@implementation CacheManager


- (void) loadSectionsSuccess: (void(^)(NSArray * sectionArray))successBlock
                     waiting: (void(^)())waitingBlock
                      failed: (void(^)())failedBlock
{
    if (self.isDownloading) {
        waitingBlock();
        return;
    }
    
    if (self.sectionArray.count!=0) {
        successBlock(self.sectionArray);
        return;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FLGlobal articleCachePath]]) {
        [self loadSectionsDataFromFile];
        successBlock(self.sectionArray);
        return;
    }
    
    self.downloading = YES;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:[FLGlobal articleUrl]
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             self.downloading = NO;
             if (!responseObject) {
                 failedBlock();
                 return;
             }
             [operation.responseData writeToFile:[FLGlobal articleCachePath] atomically:NO];
             [self loadSectionsDataFromFile];
             successBlock(self.sectionArray);
             return;
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             self.downloading = NO;
             failedBlock();
             return;
    }];
}

- (void) loadSectionsDataFromFile
{
    NSData * data = [NSData dataWithContentsOfFile:[FLGlobal articleCachePath]];
    
    NSDictionary * object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (!object) {
        return;
    }
    
    self.baseUrl = object[@"base_url"];
    
    NSMutableArray * array = [NSMutableArray new];
    
    NSArray * dataArray = object[@"items"];
    for (id item in dataArray) {
        ArticleSectionData * data = [[ArticleSectionData alloc] initWithJSONNode:item];
        [array addObject:data];
    }

    self.sectionArray = array;
}

- (NSString *) sectionPathWithTag: (NSString *)tag
{
    NSString * path = [NSTemporaryDirectory() stringByAppendingPathComponent:tag];
    
    return [path stringByAppendingString:@".json"];
}

- (void) loadSectionIndex: (NSInteger)index
                  refresh: (BOOL)isRefresh
                  success: (void(^)(NSString * path))successBlock
                  waiting: (void(^)())waitingBlock
                   failed: (void(^)())failedBlock
{
    ArticleSectionData * sectionData = self.sectionArray[index];
    if (sectionData.isDownloading) {
        waitingBlock();
        return;
    }
    
    NSString * path = [self sectionPathWithTag:sectionData.tag];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        successBlock(path);
        return;
    }
    
    sectionData.downloading = YES;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    NSString * url = [NSString stringWithFormat:@"%@%@.json", self.baseUrl, sectionData.tag];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        sectionData.downloading = NO;
        if (!responseObject) {
            failedBlock();
            return;
        }
        [operation.responseData writeToFile:path atomically:NO];
        successBlock(path);
        return;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        sectionData.downloading = NO;
        failedBlock();
        return;
    }];
    
    waitingBlock();
}

@end
