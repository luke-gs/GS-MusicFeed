//
//  AddDataViewController.m
//  Music Feed
//
//  Created by Luke sammut on 6/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "AddDataViewController.h"


//static cell identifier
static NSString *const AddDataCellIdentifier = @"addDataCellIdentifier";



@interface AddDataViewController () <UITableViewDelegate, UITableViewDataSource>

//tableview property
@property (strong,nonatomic) UITableView *addDataTableView;


@end

@implementation AddDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Views

-(void) setupViews
{
    //setup the navigation bar items
    UIBarButtonItem *addData = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(alertViewDataEntry)];
    self.navigationItem.rightBarButtonItem = addData;
    
    
    //setup the table
    self.addDataTableView = [[UITableView alloc]init];
    self.addDataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.addDataTableView.delegate = self;
    self.addDataTableView.dataSource = self;
    [self.view addSubview: self.addDataTableView];
    
    //------------------------------------------------
    //                  Constraints
    //------------------------------------------------
    
    [NSLayoutConstraint activateConstraints:@[
                                              
    [NSLayoutConstraint constraintWithItem:self.addDataTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
    [NSLayoutConstraint constraintWithItem:self.addDataTableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
    [NSLayoutConstraint constraintWithItem:self.addDataTableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
    [NSLayoutConstraint constraintWithItem:self.addDataTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
    
    ]];
}

#pragma mark - Table View DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddDataCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddDataCellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return  cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.myDelegate respondsToSelector:@selector(addDataViewControllerAddedData:)])
    {
        [self.myDelegate addDataViewControllerAddedData:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
}

#pragma mark - Fetched Results Controller Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.addDataTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo
atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.addDataTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.addDataTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
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
    
    UITableView *tableView = self.addDataTableView;
    
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
            if(indexPath != newIndexPath){
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.addDataTableView endUpdates];
}

-(void) configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*) indexPath
{
    //fetch the song from the fetchedREsultsController at the indexPath
}

#pragma mark - Navigation Control


//method that handles the alert views when a user wants to add data to the fields
-(void) alertViewDataEntry
{
    //intitialise an alertController which manages the alert view and is styles
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Add %@",self.title]
                                                                             message:[NSString stringWithFormat:@"Please enter a %@", self.title]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = self.title;
    }];
    UIAlertAction *addData = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self createObjectWithName: [alertController.textFields firstObject].text];
    }];
    
    //add the two actions to the alert view controller
    [alertController addAction:addData];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        //cancel code
        }]];
    [self presentViewController:alertController animated:YES completion:nil];
}




@end
