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
        
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        
        self.downloadData = [[NSMutableData alloc] init];
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


@end
