//
//  StringScanner.m
//  StringParser
//
//  Created by Константин Трехперстов on 26.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import "StringScanner.hh"
#import "CLogReader/CLogReader.hpp"


@interface StringScanner() {
    CLogReader* reader;
}

@end

@implementation StringScanner

- (instancetype)init
{
    self = [super init];
    if (self) {
        reader = new CLogReader();
    }
    return self;
}

- (void) setFilter:(NSString*)filter {
    const char* filterString = [filter cStringUsingEncoding:NSUTF8StringEncoding];
    reader->SetFilter(filterString);
}

- (BOOL) addSourceBlock:(NSString*) string {
    const char* str = [string cStringUsingEncoding:NSUTF8StringEncoding];
    char* strCopy = strdup(str);
    return (BOOL)reader->AddSourceBlock(strCopy, strlen(strCopy) + 1);
}

- (void)dealloc {
    delete reader;
    [super dealloc];
}

@end
