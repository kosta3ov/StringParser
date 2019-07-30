//
//  DownloadService.m
//  StringParser
//
//  Created by Константин Трехперстов on 26.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import "DownloadService.h"
#import "StringScanner.hh"

@interface DownloadService() 

@property (strong, nonatomic) Downloader* downloader;
@property (strong, nonatomic) StringScanner* scanner;

@property (strong, nonatomic) NSString* resultsLogPath;

@end

@implementation DownloadService

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDir = (NSString*)[paths objectAtIndex:0];
        NSString *fileName = [documentsDir stringByAppendingPathComponent:@"results.log"];
        
        self.resultsLogPath = [NSString stringWithString:fileName];
        self.downloader = [[Downloader alloc] init];
        self.downloader.delegate = self;
        
        self.scanner = [[StringScanner alloc] init];
        
    }
    
    return self;
}

#pragma mark - Functions

- (void) configureScannerWith:(NSString*) pattern {
    [self.scanner setFilter:pattern];
}

- (void) downloadFileAt:(NSString*) fileURL {
    
    NSURL* url = [NSURL URLWithString:fileURL];
    
    [self createLogFile];
    
    [self.downloader startDownload:url];
    
    [url release];
}

#pragma mark - Downloader delegate

- (void) downloadPartDataFrom:(Downloader*) downloader {
    @autoreleasepool {
        NSString* str = [[[NSString alloc] initWithData:downloader.downloadData encoding:NSUTF8StringEncoding] autorelease];
        
        NSArray<NSString*>* lines = [str componentsSeparatedByString:@"\n"];
        
        NSMutableArray<NSString*> *linesToWrite = [NSMutableArray array];
        
        NSString* lastLine = [lines lastObject];
        
        for (NSInteger i = 0; i < lines.count - 1; i++) {
            BOOL success = [self.scanner addSourceBlock:lines[i]];
            if (success) {
                [linesToWrite addObject:lines[i]];
            }
        }
        
        BOOL successWrite = [self writeLines:linesToWrite];
        
        if (successWrite) {
            [self.delegate downloadService:self parsedLines:linesToWrite];
        }
        
        [downloader.downloadData release];
    
        downloader.downloadData = [[[lastLine dataUsingEncoding:NSUTF8StringEncoding] mutableCopy] retain];
        
    }
    
}

#pragma mark - Disk operations

- (void) createLogFile {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:self.resultsLogPath contents:nil attributes:nil];
}

- (BOOL) writeLines:(NSArray<NSString*>*) lines {
    NSError* err;
    
    NSString* joined = [lines componentsJoinedByString:@"\n"];
    
    NSLog(@"%@", self.resultsLogPath);
    BOOL success = [joined writeToFile:self.resultsLogPath atomically:NO encoding:NSUTF8StringEncoding error:&err];
    
    if (!success || err) {
        if (err) {
            NSLog(@"Err != nil");
        }
        else {
            NSLog(@"Error writing to results.log");
        }
    }
    else {
        NSLog(@"Sucessfuly write");
    }
    
    //[joined release];
    
    return success;
}

- (void)dealloc {
    [_downloader release];
    [_scanner release];
    [_resultsLogPath release];
    [super dealloc];
}

@end
