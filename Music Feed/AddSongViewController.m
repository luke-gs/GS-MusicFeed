//
//  AddSongViewController.m
//  Music Feed
//
//  Created by Luke sammut on 6/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "AddSongViewController.h"
#import "AddDataViewController.h"
#import "ArtistViewController.h"
#import "Genre.h"
#import "Song.h"
#import "Artist.h"
#import "GenreViewController.h"

//static variables
static NSString *const SongNameCellIdentifier = @"songNameCellIdentifier";
static NSString *const ArtistGenreCellIdentifier = @"artistGenreCellIdentifier";
static NSString *const AddCellIdentifier = @"addCellIdentifier";


@interface AddSongViewController () <UITableViewDelegate, UITableViewDataSource, AddDataViewControllerDelegate>

//tableview property
@property (strong, nonatomic) UITableView *addSongTableView;

//song details
@property (strong, nonatomic) Artist *artist;
@property (strong, nonatomic) Genre *genre;

@end

@implementation AddSongViewController

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
    //setup the navigation button
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelAddSong)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    //setup addSongTableView
    self.addSongTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.addSongTableView.delegate = self;
    self.addSongTableView.dataSource = self;
    self.addSongTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.addSongTableView];
    
    
    
    //------------------------------------------------
    //                  Constraints
    //------------------------------------------------
    [NSLayoutConstraint activateConstraints:@[
    
    //tableView constraints
    [NSLayoutConstraint constraintWithItem:self.addSongTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
    [NSLayoutConstraint constraintWithItem:self.addSongTableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
    [NSLayoutConstraint constraintWithItem:self.addSongTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
    [NSLayoutConstraint constraintWithItem:self.addSongTableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
    
    ]];
}

//display an alert if the user wishes to delete all the songs in the database at once
-(void) displayAlertWithTitle:(NSString*)title withMessage:(NSString*)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"OK"
                                                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                      }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                     }];
    [alertController addAction:confirm];
    [alertController addAction:cancel];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - TableView DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 1;
        default:
            return 0;
            break;
    };
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:SongNameCellIdentifier];
                    if(!cell)
                    {
                        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:SongNameCellIdentifier];
                    }
                    
                    cell.textLabel.text = @"Song:";
                    UITextField *songTextField = [[UITextField alloc]initWithFrame:CGRectInset(cell.contentView.bounds,20,-5)];
                    songTextField.placeholder = @"Song Name";
                    cell.accessoryView = songTextField;
                    
                    break;
                }
                case 1:
                    //create the artist cell
                    cell = [tableView dequeueReusableCellWithIdentifier:ArtistGenreCellIdentifier];
                    if(!cell)
                    {
                        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:ArtistGenreCellIdentifier];
                        cell.textLabel.text = @"Artist";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                    break;
                case 2:
                    cell = [tableView dequeueReusableCellWithIdentifier:ArtistGenreCellIdentifier];
                    if(!cell)
                    {
                        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:ArtistGenreCellIdentifier];
                    }
                    cell.textLabel.text = @"Genre";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                default:
                    break;
            }
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:AddCellIdentifier];
            if(!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:AddCellIdentifier];
            }
            cell.textLabel.text = @"Add";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            
            break;
        default:
            break;
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Song Details";
        default:
            return @"";
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    break;
                case 1:
                    [self addData:indexPath.row];
                    break;
                case 2:
                    [self addData:indexPath.row];
                    break;
                default:
                    break;
            }
            break;
        case 1:{
            //create a weak pointer to self
            __weak AddSongViewController *weakSelf = self;
            
            NSIndexPath *songNameIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            UITextField *songNameTextField = (UITextField*)[tableView cellForRowAtIndexPath:songNameIndexPath].accessoryView;
            
            if(![songNameTextField.text length]>0)
            {
                [self displayAlertWithTitle:@"Error" withMessage:@"Please enter a name for the song"];
            }
            else {
            //create a new song entity based on the data presently in the table
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                Song *song = [Song MR_createEntityInContext:localContext];
                
                song.name = songNameTextField.text;
                song.artist = [weakSelf.artist MR_inContext:localContext];;
                song.genre = [weakSelf.genre MR_inContext:localContext];
                
            } completion:^(BOOL contextDidSave, NSError *error) {
                if([self.myDelegate respondsToSelector:@selector(addSongWithDetails)])
                {
                    //perform the delegate method from the delegate class  (previous VC)
                    [self.myDelegate addSongWithDetails];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Navigation Control

-(void) addData:(NSInteger) row
{
    if(row == 1)
    {
        ArtistViewController *artistVC = [[ArtistViewController alloc]init];
        artistVC.myDelegate = self;
        [self.navigationController pushViewController:artistVC animated:YES];
    }
    else
    {
        GenreViewController *genreVC = [[GenreViewController alloc]init];
        genreVC.myDelegate = self;
        [self.navigationController pushViewController:genreVC animated:YES];
    }
    
}

//dismiss the view controller and go back to the previous VC
-(void) cancelAddSong
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//enter data based on the selection the user made in the relative tableview
-(void) addDataViewControllerAddedData:(id)objectToBeAdded
{
    NSIndexPath *indexPath = nil;
    NSString *textToBeAdded;
    
    //if the object to be added is a Genre then change the text to be added to the name of the genre
    if([objectToBeAdded isKindOfClass:[Genre class]])
    {
        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        self.genre = objectToBeAdded;
        textToBeAdded = self.genre.name;
        
    }
    //if the object to be added is an artist then change the text to be added to the name of the artist
    else if ([objectToBeAdded isKindOfClass:[Artist class]])
    {
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        self.artist = objectToBeAdded;
        textToBeAdded = self.artist.name;
    }
    
    //change the information in the table view based on the text that has been added
    [self.addSongTableView cellForRowAtIndexPath:indexPath].textLabel.text = textToBeAdded;
    //pop the view controller and this will pop back to the previous VC
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
