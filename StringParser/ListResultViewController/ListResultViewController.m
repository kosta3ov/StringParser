//
//  ViewController.m
//  StringParser
//
//  Created by Константин Трехперстов on 25.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import "ListResultViewController.h"
#import "DownloadService.h"

@interface ListResultViewController () <ServiceProtocol, UITableViewDataSource>

@property (strong, nonatomic) DownloadService* service;

@property (strong, nonatomic) NSMutableArray<NSString*>* parsedLines;

@end

@implementation ListResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.parsedLines = [NSMutableArray array];
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
     
    self.service = [[DownloadService alloc] init];
    self.service.delegate = self;
        
    [self.service configureScannerWith:self.stringPattern];
    [self.service downloadFileAt:self.fileURL];
}

- (void) downloadService:(DownloadService *)service parsedLines:(NSArray<NSString *> *)lines {
    
    ListResultViewController* __weak weakSelf = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.parsedLines addObjectsFromArray:lines];
        [weakSelf.tableView reloadData];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.parsedLines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = self.parsedLines[indexPath.row];
    
    return cell;
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
