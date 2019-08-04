//
//  FileHandler.m
//  StringParser
//
//  Created by Константин Трехперстов on 03.08.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import "FileHandler.h"

@interface FileHandler()

@property (assign, nonatomic) FILE* file;

@end

@implementation FileHandler

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self setupPath];
        [self setupFile];
    }
    return self;
}

- (void) setupPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = (NSString*)[paths objectAtIndex:0];
    NSString *fileName = [documentsDir stringByAppendingPathComponent:@"results.log"];
    const char* path = [fileName cStringUsingEncoding:NSUTF8StringEncoding];
    self.resultsLogPath = strdup(path);
}

- (void) setupFile {
    self.positions = [NSMutableArray arrayWithObjects:@(0), nil];

    self.currentOffset = 0;
    
    self.file = fopen(self.resultsLogPath, "w+");
}

- (BOOL) writeNewLines:(NSMutableArray<NSString*>*) lines {
    long position = [self writeLines:lines];
    
    long lastValue = [self.positions lastObject].longValue;
    
    if (lastValue == position) {
        return NO;
    }
    else {
        [self.positions addObject:@(position)];
        return YES;
    }
}

#pragma mark - Disk operations

- (NSMutableArray<NSString*>*) getNewStrings {
    
    // Getting first unread position in file
    int firstUnreadPosition = 0;
    
    for (int i = 0; i < self.positions.count; i++) {
        NSNumber* pos = self.positions[i];
        long p = pos.longValue;
        if (p > self.currentOffset) {
            firstUnreadPosition = i;
        }
    }
    
    // Opening file for reading new lines
    NSMutableArray<NSString*>* arr = [NSMutableArray new];
    
    if (firstUnreadPosition == 0) {
        return [[arr retain] autorelease];
    }
    
    FILE* f = fopen(self.resultsLogPath, "r+");
    
    // Moving to current offset
    fseek(f, self.currentOffset, SEEK_SET);
    
    // Reading up to last position
    for (int i = firstUnreadPosition; i < self.positions.count; i++) {
        
        @autoreleasepool {
            
            // Calculating delta
            long pos = self.positions[i].longValue;
            long len = pos - self.currentOffset;
            
            // Reading from file
            char* string = (char*)malloc(sizeof(char) * len);
            fread(string, sizeof(char), (size_t)len, f);
            
            // Adding new lines + converting
            NSString* bigString = [[[NSString alloc] initWithCString:string encoding:NSUTF8StringEncoding] autorelease];
            
            // Releasing memmory
            free(string);
            
            NSArray<NSString*>* lines = [bigString componentsSeparatedByString:@"\n"];
            [arr addObjectsFromArray:lines];
            
            // Updating current position
            self.currentOffset = pos;
        }
    }
    
    // Closing file
    fclose(f);
    
    return [[arr retain] autorelease];
}

- (void) clearLogFile {
    fclose(self.file);
    self.file = fopen(self.resultsLogPath, "w+");
}

- (long) writeLines:(NSArray<NSString*>*) lines {
    // Getting united string from lines by \n char
    NSString* joined = [lines componentsJoinedByString:@"\n"];
    
    // C-string
    const char* joinedStr = [joined cStringUsingEncoding:NSUTF8StringEncoding];
    
    // Writing to file
    size_t count = fwrite(joinedStr, sizeof(char), strlen(joinedStr), self.file);
    
    // Getting last position in file and return
    long position = ftell(self.file);
    
    return position;
}

- (void)dealloc {
    fclose(_file);
    free((void*)_resultsLogPath);
    [_positions release];

    _file = nil;
    _positions = nil;
    _resultsLogPath = nil;

    [super dealloc];
}

@end