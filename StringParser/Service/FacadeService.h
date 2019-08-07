//
//  DownloadService.h
//  StringParser
//
//  Created by Константин Трехперстов on 26.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Downloader.h"
#import "FileHandler/FileHandler.h"
#import "StringScanner/StringScanner.hh"

NS_ASSUME_NONNULL_BEGIN

@class FacadeService;

@protocol FacadeDelegate

- (void) failedDownloadWithError:(nullable NSError*) err;
- (void) successDownload;

@end

@interface FacadeService : NSObject <DownloaderDelegate>

@property (weak, nonatomic) id<FacadeDelegate> delegate;

// Configuring scanner pattern
- (BOOL) configureScannerWith:(NSString*) pattern;

// Start downloading new file at url
- (void) downloadFileAt:(NSString*) fileURL;

// Receive new lines from file when scrolled to bottom
- (NSMutableArray<NSString*>*) readNewLines;

- (long long) linesCount;

@end

NS_ASSUME_NONNULL_END
