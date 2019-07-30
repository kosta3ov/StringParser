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

- (void) downloadPartDataFrom:(Downloader*) downloader;

@end


@interface Downloader : NSObject <NSURLSessionDataDelegate>

@property (retain, nonatomic) NSMutableData* downloadData;

@property (weak, nonatomic) id<DownloaderDelegate> delegate;

- (void) startDownload:(NSURL*) url;
- (void) releaseData;

@end


