//
//  Downloader.m
//  StringParser
//
//  Created by Константин Трехперстов on 26.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import "Downloader.h"

@interface Downloader() <NSURLSessionDataDelegate>

@property (strong, nonatomic) NSURLSession* session;
@property (strong, nonatomic) NSURLSessionDataTask* task;

@end


@implementation Downloader

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        // Session configuration
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        
        // Cached data for processing recieved data
        self.downloadData = [[NSMutableData new] autorelease];
    }
    return self;
}

- (void) startDownload:(NSURL*) url {
    // Creating request
    NSURLRequest* req = [[[NSURLRequest alloc] initWithURL:url] autorelease];

    // Creating task
    self.task = [self.session dataTaskWithRequest:req];
    
    // Start task
    [self.task resume];
}

#pragma mark - URLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.downloadData appendData:data];
    [self.delegate downloadPartDataFrom:self];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        [self.delegate completedWithError:error];
        NSLog(@"%@", [error localizedDescription]);
    }
    else {
        [self.delegate completedWithResponse:task.response];
        NSLog(@"Response: %@", task.response);
    }
}

#pragma mark - Clear

- (void)dealloc {
    [_task cancel];
    
    [_downloadData release];
    [_session release];
    [_task release];
    
    _downloadData = nil;
    _session = nil;
    _task = nil;
    
    [super dealloc];
}

@end
