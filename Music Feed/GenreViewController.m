//
//  GenreViewController.m
//  Music Feed
//
//  Created by Luke sammut on 7/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "GenreViewController.h"
#import "Genre.h"

@interface GenreViewController ()

@end

@implementation GenreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Genre";
    
    self.fetchedResultsController = [Genre MR_fetchAllSortedBy:@"name" ascending:NO withPredicate:nil groupBy:nil delegate:self];
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

//overrides the super class configure cell to layout the cell accordingly
-(void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Genre *genre = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if(genre)
    {
        cell.textLabel.text = genre.name;
    }
}

//create a Genre object and add it to the database
-(void)createObjectWithName:(NSString *)name
{
    if([name length] >0) {
        
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        Genre *genre = [Genre MR_createEntityInContext:localContext];
        genre.name = name;
        
        NSLog(@"Created new Genre: %@", genre.name);
    }];
        
    }
}

@end
