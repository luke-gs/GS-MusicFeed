//
//  NetworkManager.h
//  Music Feed
//
//  Created by Luke sammut on 7/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject
//singleton
+ (instancetype)sharedManager;

//fetch the data with a completion handler
-(void) fetchTripleJDataWithCompletionHandler:(void(^)(NSDictionary* tripleJData, NSError *error))completionHandler;

@end
