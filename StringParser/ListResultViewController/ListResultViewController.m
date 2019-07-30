//
//  ViewController.m
//  StringParser
//
//  Created by Константин Трехперстов on 25.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import "ListResultViewController.h"
#import "DownloadService.h"

@interface ListResultViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) DownloadService* service;

@property (strong, nonatomic) NSMutableArray<NSString*>* parsedLines;

@property (assign, nonatomic) BOOL isLoading;

@end

@implementation ListResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.parsedLines = [NSMutableArray array];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.isLoading = NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    DownloadService* service = [[DownloadService alloc] init];
    self.service = service;
    [service release];
    
    [self.service configureScannerWith:self.stringPattern];
    [self.service downloadFileAt:self.fileURL];
    
    [self.service fetchNewStrings];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.parsedLines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = self.parsedLines[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row + 1 > self.parsedLines.count && self.isLoading == NO) {
        self.isLoading = YES;
        NSMutableArray<NSString*>* newStrings = [self.service fetchNewStrings];
        [self.parsedLines addObjectsFromArray:newStrings];
        [self.tableView reloadData];
        self.isLoading = NO;
    }
}

- (void)dealloc {
    [_tableView release];
    [_service release];
    [_parsedLines release];
    [_fileURL release];
    [_stringPattern release];
    [super dealloc];
}

@end
