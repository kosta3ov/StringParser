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

@interface DownloadService : NSObject <DownloaderDelegate>

- (void) configureScannerWith:(NSString*) pattern;
- (void) downloadFileAt:(NSString*) fileURL;
- (NSMutableArray<NSString*>*) fetchNewStrings;

@end

NS_ASSUME_NONNULL_END
