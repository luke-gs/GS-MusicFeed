//
//  ArtistViewController.m
//  Music Feed
//
//  Created by Luke sammut on 7/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "ArtistViewController.h"
#import "Artist.h"

@interface ArtistViewController ()

@end

@implementation ArtistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Artist";
    self.fetchedResultsController = [Artist MR_fetchAllSortedBy:@"name" ascending:NO withPredicate:nil groupBy:nil delegate:self];
    // Do any additional setup after loading the view.
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Artist *artist = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if(artist)
    {
        cell.textLabel.text = artist.name;
    }
}

//create an artist object
-(void)createObjectWithName:(NSString *)name
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        Artist *artist = [Artist MR_createEntityInContext:localContext];
        artist.name = name;
        
        NSLog(@"Created an artist: %@", artist.name);
    }];
}

@end
