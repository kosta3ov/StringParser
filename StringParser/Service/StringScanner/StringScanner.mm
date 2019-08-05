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

- (BOOL) setFilter:(NSString*)filter {
    const char* filterString = [filter cStringUsingEncoding:NSASCIIStringEncoding];
    if (filterString) {
        reader->SetFilter(filterString);
        return YES;
    }
    return NO;
}

- (BOOL) addSourceBlock:(NSString*) string {
    const char* str = [string cStringUsingEncoding:NSASCIIStringEncoding];
    return (BOOL)reader->AddSourceBlock(str, strlen(str));
}

- (void)dealloc {
    delete reader;
    [super dealloc];
}

@end
