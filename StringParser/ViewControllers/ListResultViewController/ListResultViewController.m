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

static const double TimerInterval = 0.5;

@interface ListResultViewController () <UITableViewDataSource, UITableViewDelegate, FacadeDelegate>

@property (strong, nonatomic) FacadeService* service;

@property (strong, nonatomic) NSMutableArray<NSString*>* parsedLines;

@property (strong, nonatomic) NSTimer* timer;

@property (assign, nonatomic) BOOL allDataDownloaded;

@end

@implementation ListResultViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.parsedLines = [[NSMutableArray new] autorelease];
        self.service = [[[FacadeService alloc] init] autorelease];
        self.service.delegate = self;
        
        _fileURL = nil;
        _stringPattern = nil;
        _allDataDownloaded = NO;
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    BOOL success = [self.service configureScannerWith:self.stringPattern];
    if (!success) {
        [self showAlert:@"Error" message:@"Can't set filter string\nWrong characters"];
    }
    
    [self.service downloadFileAt:self.fileURL];
    
    // Timer checking bottom position and reading new lines from file results.log
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TimerInterval target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

- (void) timerFired {
    
    if (self.allDataDownloaded && self.service.linesCount == [self.parsedLines count]) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    
    
    CGFloat height = self.tableView.frame.size.height;
    CGFloat contentYoffset = self.tableView.contentOffset.y;
    CGFloat distanceFromBottom = self.tableView.contentSize.height - contentYoffset;
    
    // Checking position at bottom
    if (distanceFromBottom <= height) {
        
        // When at bottom read new lines from file
        NSMutableArray* newLines = [[self.service readNewLines] autorelease];
        if ([newLines count]) {
            [self.parsedLines addObjectsFromArray:newLines];
            [self.tableView reloadData];
        }
    }
    
}

- (void) showAlert:(NSString*) title message:(NSString*) message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - FacadeServiceProtocol


- (void) failedDownloadWithError:(nullable NSError*) err {
    self.allDataDownloaded = YES;
    NSString* message = @"Failed download\nResponse is not 200 OK";
    if (err) {
        message = [err localizedDescription];
    }
    [self showAlert:@"Error" message:message];
}

- (void) successDownload {
    self.allDataDownloaded = YES;
    if ([self.parsedLines count] == 0) {
        [self showAlert:@"Warning" message:@"All data has been processed\nNo one line has been filtered"];
    }
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


#pragma mark - Clear

- (void) clear {
    [_timer invalidate];
    [_timer release];
    
    [_tableView release];
    [_service release];
    [_parsedLines release];
    [_fileURL release];
    [_stringPattern release];
    
    _timer = nil;
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
