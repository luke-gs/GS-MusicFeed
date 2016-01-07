//
//  MusicFeedViewController.m
//  Music Feed
//
//  Created by Luke sammut on 6/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "MusicFeedViewController.h"
#import "AddSongViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import <CoreData/CoreData.h>
#import "Song.h"
#import "Artist.h"
#import "Genre.h"

//static variables
static NSString *const MusicFeedViewControllerTitle = @"Your Music";
static NSString *const MusicFeedCellIdentifier = @"musicFeedCell";

@interface MusicFeedViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, AddSong>

//table view
@property (strong, nonatomic) UITableView *musicFeedTable;

//fetched results controller
@property (strong , nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation MusicFeedViewController

//call the view setup in the view did load
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

#pragma mark - Setup Views
//setup simpleNSFetchedResultsController
-(NSFetchedResultsController*) fetchedResultsController {
    if(!_fetchedResultsController){
        _fetchedResultsController = [Song MR_fetchAllSortedBy:@"name" ascending:NO withPredicate:nil groupBy:nil delegate:self];
    }
    return _fetchedResultsController;
}

/**
 *  Sets up all the views for this view controller, also sets the constraints of the table view 
    Adds bar button items to the navigation controller, with actions that are called upon press
 */
-(void) setupViews
{
    // set the title of the VC
    [self setTitle:MusicFeedViewControllerTitle];
    
    // add right navigation button
    UIBarButtonItem *addSongButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSong)];
    self.navigationItem.rightBarButtonItem = addSongButton;
    
    // add left navigation button
    UIBarButtonItem *deleteTableData = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(displayWarning)];
    self.navigationItem.leftBarButtonItem = deleteTableData;
    
    // Setup the tableView
    self.musicFeedTable = [[UITableView alloc]init];
    self.musicFeedTable.translatesAutoresizingMaskIntoConstraints  = NO;
    self.musicFeedTable.delegate = self;
    self.musicFeedTable.dataSource = self;
    [self.view addSubview:self.musicFeedTable];
    
    //----------------------------------------
    //              Constraints
    //----------------------------------------
        [NSLayoutConstraint activateConstraints:@[
                                        
        // Table view constraints
        [NSLayoutConstraint constraintWithItem:self.musicFeedTable attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:self.musicFeedTable attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:self.musicFeedTable attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
        [NSLayoutConstraint constraintWithItem:self.musicFeedTable attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0],
        ]];
}

//display an alert if the user wishes to delete all the songs in the database at once
-(void) displayWarning
{
    //the message that will be displayed to the user if they attempt to delete the songs
    NSString *message = [NSString stringWithFormat:@"Delete all songs?"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteSongs];
    }];
    
    //the action to complete when the action button is pressed
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    //add the actions to the alert controller
    [alertController addAction:confirm];
    [alertController addAction:cancel];
    
    //present the alert controller modally
    [self presentViewController:alertController animated:YES completion:nil];
}


// create the navigation controller and add a bar button item
-(UINavigationController*) createNavigationControllerWithViewController:(UIViewController*)viewController
{
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:viewController];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeAddSongViewController)];
    viewController.navigationItem.leftBarButtonItem = cancel;
    
    return navigationController;
}

#pragma mark - TableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections]count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Initialise the cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MusicFeedCellIdentifier];
    
    //if a cell doesnt exist create a cell with a subtitle using the reuse identifier
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MusicFeedCellIdentifier ];
    }
    
    //configure the cell accordingly
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        Song *song = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            Song *localSong = [song MR_inContext:localContext];
            [localSong MR_deleteEntityInContext:localContext];
        }];
    }
    else if( editingStyle == UITableViewCellEditingStyleInsert) {
        //create a new entity and save
    }
}


/**
 *  Helper method to allow easy creation of cells in the table view
 *
 *  @param cell      A cell containing basic information on a song and its name
 *  @param indexPath The index path of the cell
 */
-(void) configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*) indexPath
{
    //fetch the song from the fetchedREsultsController at the indexPath
    Song *song = [self.fetchedResultsController objectAtIndexPath:indexPath];

    NSString *subtitle = [NSString stringWithFormat:@"%@ | %@", song.artist.name, song.genre.name];
    
    if(song)
    {
        cell.textLabel.text = song.name;
        cell.detailTextLabel.text  = subtitle;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightThin];
    }
    
    // Sets the cell so that when it is selected there is no style
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - Fetched Results Controller Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.musicFeedTable beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.musicFeedTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.musicFeedTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            //insert funcationality
            break;
        case NSFetchedResultsChangeUpdate:
            //insert functionality
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.musicFeedTable;
    
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
    [self.musicFeedTable endUpdates];
}



#pragma mark - Navigation Control
/**
 *  creates the Add Song View Controller which has its delegate set to self and then initialises 
    a naviagtion controller with the Add Song View Controller as its root View Controller
 
    Presents the navigation controller after the view controller has been created
 */
-(void) addSong
{
    AddSongViewController *addSongVC = [[AddSongViewController alloc]init];
    addSongVC.myDelegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:addSongVC];
    
    //bar button item
    [self presentViewController:navigationController animated:YES completion:nil];
}

// Called when the user clicks the trash bar button item
// performs a truncate on all the objects in the Song database, which deletes all the entries
-(void) deleteSongs
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [Song MR_truncateAllInContext:localContext];
    }];
}

/**
 *  Dismiss the add song view controller
    This will bring you back to the Music Feed View Controller
    Called from the bar button item in the navigation controller
 */
-(void) closeAddSongViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Bar button Action Methods
//protocol method to add song
-(void) addSongWithDetails
{
    NSLog(@"Added a new song");
}

@end
