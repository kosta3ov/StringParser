//
//  Downloader.h
//  StringParser
//
//  Created by Константин Трехперстов on 26.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Downloader;

@protocol DownloaderDelegate <NSObject>

// Delegate method called each time after recieving data

- (void) downloadPartDataFrom:(Downloader*) downloader;
- (void) completedWithResponse:(NSURLResponse*) response;
- (void) completedWithError:(NSError*) err;

@end


@interface Downloader : NSObject <NSURLSessionDataDelegate>

@property (strong, nonatomic) NSMutableData* downloadData;
@property (weak, nonatomic) id<DownloaderDelegate> delegate;

- (void) startDownload:(NSURL*) url;

@end


