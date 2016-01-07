//
//  TripleJViewController.m
//  Music Feed
//
//  Created by Luke sammut on 7/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "TripleJViewController.h"
#import "NetworkManager.h"
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>
#import "TripleJMusicTrack.h"

//static properties
static NSString *const ViewControllerTitle = @"Triple J Feed";
static NSString *const TripleJCellIdentifier = @"tripleJCellIdentifier";

@interface TripleJViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UITableView *tripleJTableView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TripleJViewController

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.title = ViewControllerTitle;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up the views
    [self setupViews];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup Views
-(void) setupViews
{
    // Setup the table view
    self.tripleJTableView = [[UITableView alloc]init];
    self.tripleJTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tripleJTableView.delegate = self;
    self.tripleJTableView.dataSource = self;
    [self.view addSubview:self.tripleJTableView];
    
    //----------------------------------------------------
    //                     Constraints
    //----------------------------------------------------
    
    [NSLayoutConstraint activateConstraints:@[
        
        [NSLayoutConstraint constraintWithItem:self.tripleJTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:self.tripleJTableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:self.tripleJTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:self.tripleJTableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
    
        ]];
    
    // Fetch the data from the triple J Website
    [self fetchRemoteXMLData];
}

/**
 *  Fetches the XML data using the singleton network manager
    For each track in the XML, it will create n entity and save it
 */
-(void) fetchRemoteXMLData
{
    // using the Network managers singleton fetch the json data
    [[NetworkManager sharedManager] fetchTripleJDataWithCompletionHandler:^(NSDictionary *tripleJData, NSError *error) {
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            
            //clear existing data
            [TripleJMusicTrack MR_truncateAllInContext:localContext];
            
            //creates a track entity for each track in the XML
            for (NSDictionary *dictionary in tripleJData[@"rss"][@"channel"][@"item"]) {
                [TripleJMusicTrack tripleJMusicTrackFromDictionary:dictionary inContext:localContext];
            }
        } completion:nil];
    }];

}

#pragma mark - Table View Data Source

// Number of sections
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

// NUmber of rows in section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TripleJCellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TripleJCellIdentifier];
    }
    
    //helper method called to configure the cell
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Fetched Results Controller Delegate

//setup simpleNSFetchedResultsController
-(NSFetchedResultsController*) fetchedResultsController {
    if(!_fetchedResultsController){
        _fetchedResultsController = [TripleJMusicTrack MR_fetchAllSortedBy:@"title" ascending:NO withPredicate:nil groupBy:nil delegate:self];
    }
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tripleJTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo
atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tripleJTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tripleJTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            //insert funcationality
            break;
        case NSFetchedResultsChangeUpdate:
            //insert functioanlity
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tripleJTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tripleJTableView endUpdates];
}

/**
 *  Helper method that given a cell sets up the information to be presented in the cell
 *
 *  @param cell      the cell at the index path to be configured
 *  @param indexPath The indexpath at which the cell that resides here will be configured
 */
-(void) configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*) indexPath
{
    //fetch the song from the fetchedREsultsController at the indexPath
    TripleJMusicTrack *tripleJMusicTrack = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // If a triple J Music Track was successfully created
    if(tripleJMusicTrack)
    {
        NSString *details = [NSString stringWithFormat:@"Duration: %@",tripleJMusicTrack.duration];
        
        cell.textLabel.text = tripleJMusicTrack.title;
        cell.detailTextLabel.text  = details;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightThin];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end


