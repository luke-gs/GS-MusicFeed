//
//  TripleJMusicTrack.h
//  Music Feed
//
//  Created by Luke sammut on 7/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface TripleJMusicTrack : NSManagedObject

+(TripleJMusicTrack*) tripleJMusicTrackFromDictionary:(NSDictionary*) dictionary inContext:(NSManagedObjectContext*) context;

@end

NS_ASSUME_NONNULL_END

#import "TripleJMusicTrack+CoreDataProperties.h"
