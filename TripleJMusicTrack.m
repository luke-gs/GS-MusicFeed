//
//  TripleJMusicTrack.m
//  Music Feed
//
//  Created by Luke sammut on 7/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "TripleJMusicTrack.h"
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>

@implementation TripleJMusicTrack

/**
 *  Creates and returns a Triple J Music Track and saves in in the context that has been passed in
 *
 *  @param dictionary The dictionary that has been passed in (parsed XML)
 *  @param context    The context in which the Triple J Music Track will be saved and stored
 *
 *  @return The triple J music track that has been created
 */
+(TripleJMusicTrack*) tripleJMusicTrackFromDictionary:(NSDictionary*) dictionary inContext:(NSManagedObjectContext*) context
{
    TripleJMusicTrack *tripleJMusicTrack = [TripleJMusicTrack MR_createEntityInContext:context];
    tripleJMusicTrack.title = dictionary[@"title"];
    tripleJMusicTrack.url = dictionary[@"link"];
    tripleJMusicTrack.detail = dictionary[@"description"];
    tripleJMusicTrack.duration = dictionary[@"itunes:duration"];
    
    NSLog(@"%@", tripleJMusicTrack);
    
    return tripleJMusicTrack;
}

@end
