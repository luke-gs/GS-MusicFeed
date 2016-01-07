//
//  Artist+CoreDataProperties.h
//  Music Feed
//
//  Created by Luke sammut on 6/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Artist.h"

NS_ASSUME_NONNULL_BEGIN

@interface Artist (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Song *> *songs;

@end

@interface Artist (CoreDataGeneratedAccessors)

- (void)addSongsObject:(Song *)value;
- (void)removeSongsObject:(Song *)value;
- (void)addSongs:(NSSet<Song *> *)values;
- (void)removeSongs:(NSSet<Song *> *)values;

@end

NS_ASSUME_NONNULL_END
