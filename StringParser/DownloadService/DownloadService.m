//
//  DownloadService.m
//  StringParser
//
//  Created by Константин Трехперстов on 26.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import "DownloadService.h"

@interface DownloadService()

@end

@implementation DownloadService

- (instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) downloadFileAt:(NSString*) fileURL {
    NSURLSession* session = [NSURLSession sharedSession];
    
    NSURL* url = [NSURL URLWithString:fileURL];
    
    [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    
    [url release];
}

@end
