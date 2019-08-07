//
//  FileHandler.h
//  StringParser
//
//  Created by Константин Трехперстов on 03.08.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileHandler : NSObject

@property (assign, nonatomic) const char* resultsLogPath;
@property (strong, nonatomic) NSMutableArray<NSNumber*>* positions;
@property (assign, nonatomic) long currentOffset;

- (void) clearLogFile;
- (NSMutableArray<NSString*>*) getNewStrings;
- (BOOL) writeNewLines:(NSMutableArray<NSString*>*) lines;
- (long long) countLines;

@end

NS_ASSUME_NONNULL_END
