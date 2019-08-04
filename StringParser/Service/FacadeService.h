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

@protocol FacadeServiceProtocol <NSObject>

- (void) serviceDownloadedFirstData;

@end

@class FacadeService;

@interface FacadeService : NSObject <DownloaderDelegate>

@property (weak, nonatomic) id<FacadeServiceProtocol> delegate;

// Configuring scanner pattern
- (void) configureScannerWith:(NSString*) pattern;

// Start downloading new file at url
- (void) downloadFileAt:(NSString*) fileURL;

// Receive new lines from file when scrolled to bottom
- (NSMutableArray<NSString*>*) readNewLines;

@end

NS_ASSUME_NONNULL_END
