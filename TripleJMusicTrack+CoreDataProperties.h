//
//  TripleJMusicTrack+CoreDataProperties.h
//  Music Feed
//
//  Created by Luke sammut on 7/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TripleJMusicTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface TripleJMusicTrack (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSString *duration;

@end

NS_ASSUME_NONNULL_END
