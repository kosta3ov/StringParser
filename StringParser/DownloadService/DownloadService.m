//
//  DownloadService.m
//  StringParser
//
//  Created by Константин Трехперстов on 26.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import "DownloadService.h"
#import "StringScanner.hh"

@interface DownloadService() {
    FILE* file;
}

@property (strong, nonatomic) Downloader* downloader;
@property (strong, nonatomic) StringScanner* scanner;
@property (strong, nonatomic) NSString* resultsLogPath;

@property (strong, nonatomic) NSMutableArray<NSNumber*>* positions;
@property (assign, nonatomic) long currentOffset;

@end

@implementation DownloadService

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDir = (NSString*)[paths objectAtIndex:0];
        NSString *fileName = [documentsDir stringByAppendingPathComponent:@"results.log"];
        
        self.resultsLogPath = [NSString stringWithString:fileName];
        Downloader* downloader = [[Downloader alloc] init];
        self.downloader = downloader;
        [downloader release];
        
        self.downloader.delegate = self;
        
        StringScanner* scanner = [[StringScanner alloc] init];
        self.scanner = scanner;
        [scanner release];
        
        NSMutableArray<NSNumber*>* pos = [NSMutableArray array];
        [pos addObject:@(0)];
        
        self.positions = pos;
        
        
        self.currentOffset = 0;
        
        file = fopen([self.resultsLogPath cStringUsingEncoding:NSUTF8StringEncoding], "a+");
        
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
    
}



#pragma mark - Downloader delegate

- (void) downloadPartDataFrom:(Downloader*) downloader {
    
    NSString* str = [[NSString alloc] initWithData:downloader.downloadData encoding:NSUTF8StringEncoding];
    
    NSArray<NSString*>* lines = [str componentsSeparatedByString:@"\n"];
    
    NSMutableArray<NSString*> *linesToWrite = [NSMutableArray array];
    
    NSString* lastLine = [lines lastObject];
    
    for (NSInteger i = 0; i < lines.count - 1; i++) {
        BOOL success = [self.scanner addSourceBlock:lines[i]];
        if (success) {
            [linesToWrite addObject:lines[i]];
        }
    }
    
    long position = [self writeLines:linesToWrite];
    
    if (position > 0) {
        [self.positions addObject:@(position)];
    }
    
    [downloader releaseData];

    NSMutableData* newData  = [[lastLine dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    downloader.downloadData = newData;
    [newData release];
    
    [str release];
}

#pragma mark - Disk operations

- (NSMutableArray<NSString*>*) fetchNewStrings {
    int firstUnreadPosition = 0;
    
    for (int i = 0; i < self.positions.count; i++) {
        NSNumber* pos = self.positions[i];
        long p = pos.longValue;
        if (p > self.currentOffset) {
            firstUnreadPosition = i;
        }
    }
    
    NSMutableArray<NSString*>* arr = [NSMutableArray array];
    
    FILE* f = fopen([self.resultsLogPath cStringUsingEncoding:NSUTF8StringEncoding], "rt");
    
    fseek(f, self.currentOffset, SEEK_SET);
    
    for (int i = firstUnreadPosition; i < self.positions.count; i++) {
        long pos = self.positions[i].longValue;
        long len = pos - self.currentOffset;
        char* string = (char*)malloc(sizeof(char) * len);
        fread(string, sizeof(char), len, f);
        NSString* bigString = [[NSString alloc] initWithCString:string encoding:NSUTF8StringEncoding];
        NSArray<NSString*>* lines = [bigString componentsSeparatedByString:@"\n"];
        [arr addObjectsFromArray:lines];
        self.currentOffset = pos;
    }
    
    fclose(f);
    
    return [arr autorelease];
}

- (void) createLogFile {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:self.resultsLogPath contents:nil attributes:nil];
}

- (long) writeLines:(NSArray<NSString*>*) lines {
    NSString* joined = [lines componentsJoinedByString:@"\n"];
    const char* joinedStr = [joined cStringUsingEncoding:NSUTF8StringEncoding];
    fwrite(joinedStr, sizeof(char), strlen(joinedStr), file);
    long position = ftell(file);
    return position;
}

- (void)dealloc {
    fclose(file);
    [_positions release];
    [_downloader release];
    [_scanner release];
    [_resultsLogPath release];
    [super dealloc];
}

@end
