//
//  NetworkManager.m
//  Music Feed
//
//  Created by Luke sammut on 7/01/2016.
//  Copyright © 2016 Luke sammut. All rights reserved.
//

#import "NetworkManager.h"
#import <SHXMLParser/SHXMLParser.h>

@interface NetworkManager()

@property (strong,nonatomic) NSURLSession *session;

@end

@implementation NetworkManager


// singleton 
+ (instancetype)sharedManager {
    static NetworkManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[NetworkManager alloc] init];
    });
    
    return _sharedManager;
}

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

/**
 *  fetches the triple J data and provides a completion handler for when that is complete
    Using a XML parser library to convert the data returned into useable dictionary that
        contains parsed XML
    Logs the dictionary results
 *
 *  @param completionHandler Allows methods that call this to gain access to the data that has 
                             been saved into the dictionary
 */
-(void) fetchTripleJDataWithCompletionHandler:(void(^)(NSDictionary* tripleJData, NSError *error))completionHandler
{
    NSString *URLString = @"http://www.abc.net.au/triplej/listen/podcast.xml";
    NSURL *url = [NSURL URLWithString:URLString];
    
    // create a new download task using the Network Managers session
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        // perform on main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // get the data from url, parse it using SHXMLParser
            // store the resulting data in a dictionary
            NSData *XMLData = [NSData dataWithContentsOfURL:location];
            SHXMLParser *XMLParser = [[SHXMLParser alloc]init];
            NSDictionary *parsedXMLResults = [XMLParser parseData:XMLData];
            
            NSLog(@"%@",parsedXMLResults);
            //pass the completion handler the parsed XML results
            completionHandler(parsedXMLResults,error);
            
        });
        
    }];
    [downloadTask resume];

    
}



@end
