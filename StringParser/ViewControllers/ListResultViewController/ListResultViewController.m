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

@interface ListResultViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) FacadeService* service;

@property (strong, nonatomic) NSMutableArray<NSString*>* parsedLines;

@property (strong, nonatomic) NSTimer* timer;

@end

@implementation ListResultViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.parsedLines = [[NSMutableArray new] autorelease];
        self.service = [[[FacadeService alloc] init] autorelease];
        
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
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TimerInterval target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

#pragma mark - FacadeServiceProtocol

- (void) timerFired {
    
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
