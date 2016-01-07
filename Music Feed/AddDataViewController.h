//
//  AddDataViewController.h
//  Music Feed
//
//  Created by Luke sammut on 6/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>

@protocol AddDataViewControllerDelegate <NSObject>

-(void) addDataViewControllerAddedData:(id) objectToBeAdded;

@end

@interface AddDataViewController : UIViewController <NSFetchedResultsControllerDelegate>

//fetched results controller
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

//delegate for passing data back to the AddSongViewController
@property (nonatomic, assign) id<AddDataViewControllerDelegate> myDelegate;

-(void) configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*) indexPath;

-(void) createObjectWithName:(NSString*)name;

@end
