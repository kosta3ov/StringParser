//
//  DownloadService.h
//  StringParser
//
//  Created by Константин Трехперстов on 26.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Downloader.h"

NS_ASSUME_NONNULL_BEGIN

@class DownloadService;

@protocol ServiceProtocol

- (void) downloadService:(DownloadService*) service parsedLines:(NSArray<NSString*>*) lines;

@end


@interface DownloadService : NSObject <DownloaderDelegate>

@property (weak, nonatomic) id<ServiceProtocol> delegate;

- (void) configureScannerWith:(NSString*) pattern;
- (void) downloadFileAt:(NSString*) fileURL;

@end

NS_ASSUME_NONNULL_END
