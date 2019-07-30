//
//  Downloader.m
//  StringParser
//
//  Created by Константин Трехперстов on 26.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import "Downloader.h"

@interface Downloader() <NSURLSessionDataDelegate>

@property (retain, nonatomic) NSURLSession* session;
@property (retain, nonatomic) NSURLSessionDataTask* task;

@end


@implementation Downloader

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        
        NSMutableData* newData = [NSMutableData new];
        self.downloadData = newData;
        [newData release];
    }
    return self;
}

- (void) startDownload:(NSURL*) url {
    NSURLRequest* req = [[NSURLRequest alloc] initWithURL:url];

    self.task = [self.session dataTaskWithRequest:req];
    [self.task resume];
    
    [req release];
}



- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.downloadData appendData:data];
    [self.delegate downloadPartDataFrom:self];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        
    }
    else {
        NSLog(@"Response: %@", task.response);
    }
}

- (void) releaseData {
    [_downloadData release];
    _downloadData = nil;
}

- (void)dealloc {
    [_downloadData release];
    [_session release];
    [_task release];
    [super dealloc];
}

@end
