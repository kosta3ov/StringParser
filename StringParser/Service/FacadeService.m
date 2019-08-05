//
//  DownloadService.m
//  StringParser
//
//  Created by Константин Трехперстов on 26.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import "FacadeService.h"

@interface FacadeService()

@property (strong, nonatomic) Downloader* downloader;
@property (strong, nonatomic) StringScanner* scanner;
@property (strong, nonatomic) FileHandler* fileHandler;

@end

@implementation FacadeService

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        
        // Setting fileHandler
        self.fileHandler = [[[FileHandler alloc] init] autorelease];
        
        // Setting Downloader
        self.downloader = [[[Downloader alloc] init] autorelease];
        self.downloader.delegate = self;
        
        // Setting String Scanner
        self.scanner = [[[StringScanner alloc] init] autorelease];
    }
    
    return self;
}


#pragma mark - Downloader delegate

- (void) completedWithResponse:(NSURLResponse*) response {
    NSInteger code = [response statusCode];
    if (code >= 200 && code < 300) {
        [self.delegate successDownload];
    }
    else {
        [self.delegate failedDownloadWithError:nil];
    }
}

- (void) completedWithError:(NSError*) err {
    [self.delegate failedDownloadWithError:err];
}


- (void) downloadPartDataFrom:(Downloader*) downloader {
    
    @autoreleasepool {
        // Creating string from recieved data
        NSString* str = [[[NSString alloc] initWithData:downloader.downloadData encoding:NSASCIIStringEncoding] autorelease];
        
        // Creating array for lines to write in the file
        NSMutableArray<NSString*> *linesToWrite = [[NSMutableArray new] autorelease];
        
        // Splitting string into lines
        NSArray<NSString*>* lines = [str componentsSeparatedByString:@"\n"];
        
        // Getting last incomplete line constructed from data
        NSString* lastLine = [lines lastObject];
        
        // Filtering lines up to pre-last
        for (NSInteger i = 0; i < lines.count - 1; i++) {
            if ([lines[i] length] > 0) {
                BOOL success = [self.scanner addSourceBlock:lines[i]];
                if (success) {
                    [linesToWrite addObject:lines[i]];
                }
            }
        }
        
        // Writing filtered lines into file results.log
        if ([linesToWrite count]) {
            [self.fileHandler writeNewLines:linesToWrite];
        }
        
        // Updating cached data
        downloader.downloadData = nil;
        
        NSMutableData* newData = [[[lastLine dataUsingEncoding:NSASCIIStringEncoding] mutableCopy] autorelease];
        downloader.downloadData = newData;
    }
    
}

#pragma mark - Functions

- (BOOL) configureScannerWith:(NSString*) pattern {
    
    return [self.scanner setFilter:pattern];
}

- (void) downloadFileAt:(NSString*) fileURL {
    
    NSURL* url = [NSURL URLWithString:fileURL];
    
    // Creating log file
    [self.fileHandler clearLogFile];
    
    // Starting dowload
    [self.downloader startDownload:url];
}

- (NSMutableArray<NSString *> *)readNewLines {
    NSMutableArray* newLines = [self.fileHandler getNewStrings];
    [newLines filterUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.length > 0"]];
    return newLines;
}

#pragma mark - Clear

- (void) clear {
    
    [_downloader release];
    [_scanner release];
    [_fileHandler release];
    
    _downloader = nil;
    _scanner = nil;
    _fileHandler = nil;
}

- (void)dealloc {
    
    [self clear];
    
    [super dealloc];
}

@end
