//
//  ViewController.m
//  StringParser
//
//  Created by Константин Трехперстов on 25.07.2019.
//  Copyright © 2019 Константин Трехперстов. All rights reserved.
//

#import "ListResultViewController.h"
#import "StringViewerController.h"
#import "FacadeService.h"

@interface ListResultViewController () <UITableViewDataSource, UITableViewDelegate, FacadeServiceProtocol>

@property (strong, nonatomic) FacadeService* service;

@property (strong, nonatomic) NSMutableArray<NSString*>* parsedLines;

@property (assign, nonatomic) BOOL isLoading;

@end

@implementation ListResultViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.parsedLines = [[NSMutableArray new] autorelease];
        self.isLoading = NO;
        self.service = [[[FacadeService alloc] init] autorelease];
        self.service.delegate = self;
        
        _fileURL = nil;
        _stringPattern = nil;
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self.service configureScannerWith:self.stringPattern];
    [self.service downloadFileAt:self.fileURL];
}

#pragma mark - FacadeServiceProtocol

- (void)serviceDownloadedFirstData {
    dispatch_async(dispatch_get_main_queue(), ^{
       
        NSMutableArray* newLines = [[self.service readNewLines] autorelease];
        [self.parsedLines addObjectsFromArray:newLines];
        [self.tableView reloadData];
        
    });
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.parsedLines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = self.parsedLines[indexPath.row];
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StringViewerController* svc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"StringViewerController"];
    svc.text = self.parsedLines[indexPath.row];
    
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.parsedLines.count - 1) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray<NSString*>* newStrings = [[self.service readNewLines] autorelease];
            
            if ([newStrings count]) {
                [self.parsedLines addObjectsFromArray:newStrings];
                [self.tableView reloadData];
            }
        });
        
    }
}

#pragma mark - Clear

- (void) clear {
    [_tableView release];
    [_service release];
    [_parsedLines release];
    [_fileURL release];
    [_stringPattern release];
    
    _tableView = nil;
    _service = nil;
    _parsedLines = nil;
    _fileURL = nil;
    _stringPattern = nil;
}

- (void)dealloc {
    [self clear];
    [super dealloc];
}

@end
