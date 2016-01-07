//
//  Song.h
//  Music Feed
//
//  Created by Luke sammut on 6/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Artist, Genre;

NS_ASSUME_NONNULL_BEGIN

@interface Song : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Song+CoreDataProperties.h"
