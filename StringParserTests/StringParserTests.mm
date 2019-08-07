//
//  StringParserTests.m
//  StringParserTests
//
//  Created by Константин Трехперстов on 07.08.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StringScanner.hh"

@interface StringParserTests : XCTestCase

@property (strong, nonatomic) StringScanner* scanner;

@end

@implementation StringParserTests

- (void) setUp {
    self.scanner = [[[StringScanner alloc] init] autorelease];
}

- (void) tearDown {
    self.scanner = nil;
}


// I cant test, my xcode crashes
- (void) testCases {
    [self.scanner setFilter:@"aaa"];
    XCTAssertTrue([self.scanner addSourceBlock:@"aaa"]);
    
    [self.scanner setFilter:@"a?a"];
    XCTAssertTrue([self.scanner addSourceBlock:@"aaa"]);
    XCTAssertFalse([self.scanner addSourceBlock:@"aa"]);
    
    [self.scanner setFilter:@"*aaa*"];
    XCTAssertTrue([self.scanner addSourceBlock:@"aaa"]);
    XCTAssertTrue([self.scanner addSourceBlock:@"aaaaa"]);
    XCTAssertFalse([self.scanner addSourceBlock:@""]);
    
    [self.scanner setFilter:@"a*"];
    XCTAssertTrue([self.scanner addSourceBlock:@"aaa"]);
    XCTAssertTrue([self.scanner addSourceBlock:@"a"]);
    XCTAssertFalse([self.scanner addSourceBlock:@"b"]);
    
    [self.scanner setFilter:@"*a"];
    XCTAssertTrue([self.scanner addSourceBlock:@"aaa"]);
    XCTAssertTrue([self.scanner addSourceBlock:@"a"]);
    XCTAssertFalse([self.scanner addSourceBlock:@"ab"]);
    
    [self.scanner setFilter:@"a*b"];
    XCTAssertTrue([self.scanner addSourceBlock:@"ab"]);
    XCTAssertTrue([self.scanner addSourceBlock:@"adasdasdb"]);
    XCTAssertFalse([self.scanner addSourceBlock:@"abc"]);
    
    [self.scanner setFilter:@"**?**?a?*b?***"];
    XCTAssertTrue([self.scanner addSourceBlock:@"22bab11b1222"]);
}


@end
