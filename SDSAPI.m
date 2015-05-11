//
//  SDSAPI.m
//  EcstaticFM
//
//  Created by David Hernon on 2015-02-28.
//  Copyright (c) 2015 David Hernon. All rights reserved.
//
#import "SDSAPI.h"
#import "EcstaticFM-Swift.h"

@implementation SDSAPI

@class SocketIOClient;

static SocketIOClient *static_socket;

+(NSString*)getWebsiteURL
{
    return @"http://54.173.157.204/appindex/";
}

+(NSArray*) getUpcomingEvents
{
    __block NSArray *eventD;
    __block BOOL returned;
    NSURLSession *defaultSession = [NSURLSession sharedSession];
    
    NSURL * url = [NSURL URLWithString:[SDSAPI getWebsiteURL]];
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL:url
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                       if(error == nil)
                                                       {
                                                           eventD = [NSJSONSerialization JSONObjectWithData:data
                                                                                                    options:kNilOptions
                                                                                                      error:&error];
                                                           for(NSDictionary *item in eventD) {
                                                               NSLog (@"nsdic = %@", item);
                                                           }
                                                           returned = TRUE;
                                                       }
                                                   }];
    [dataTask resume];
    returned = FALSE;
    while(returned == FALSE){
        [NSThread sleepForTimeInterval:0.1f];
    }
    return eventD;
}

+(void) login:(NSString*)username password:(NSString*)pass
{
    
    // at the top
    static NSString *csrf_cookie;
    
    // in a function:
    NSURL *url = [[NSURL alloc] initWithString:@"http://54.173.157.204/"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPShouldHandleCookies:YES];
    
    [request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url]]];
    
    // make GET request are store the csrf
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[(NSHTTPURLResponse *)response allHeaderFields] forURL:url];
                               [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies forURL:url mainDocumentURL:nil];
                               // for some reason we need to re-store the CSRF token as X_CSRFTOKEN
                               for (NSHTTPCookie *cookie in cookies) {
                                   if ([cookie.name isEqualToString:@"csrftoken"]) {
                                       csrf_cookie = cookie.value;
                                       NSLog(@"cookie.value=%@", cookie.value);
                                       break;
                                   }
                               }
                               NSString* urlString = @"http://54.173.157.204/auth/loginViewiOS/";
                               NSURL *url = [NSURL URLWithString:urlString];
                               
                               NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
                               [urlRequest setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url]]];
                               [urlRequest addValue:csrf_cookie forHTTPHeaderField:@"X_CSRFTOKEN"];
                               [urlRequest setHTTPMethod:@"POST"];
                               NSString* bodyData = [NSString stringWithFormat:@"username=%@&password=%@", username, pass];
                               [urlRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
                               NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                               
                               [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
                                {
                                    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                    
                                    if ([responseString  isEqual: @"successful_login"]) {
                                        NSLog(@"%@", responseString);
                                    }
                                    else{
                                        NSLog(@"%@", responseString);
                                    }
                                }];
                           }];
    
    
}
+(void) fbLogin{
    
}

+ (void) connect{
    static_socket = [[SocketIOClient alloc] initWithSocketURL:@"http://54.173.157.204:8888" options:nil];
    
	[static_socket on: @"connect" callback: ^(NSArray* data, void (^ack)(NSArray*)) {
		NSLog(@"here connected");
	}];
	
	[static_socket on: @"get_rooms_around_me" callback: ^(NSArray* data, void (^ack)(NSArray*)) {
		NSLog(@"get_rooms_around_me returned,%@", data[0]);
		NSDictionary* locationsDict =(NSDictionary*) data[0];
		NSArray* locationsArray = [locationsDict objectForKey:@"locations"];
		for(NSDictionary *item in locationsArray) {
		   NSLog(@"Item: %@", item);
		}
	}];

    [static_socket connect];
}

//Rewrite with Async timeout wait
+(void) createRoom:(NSString*)username{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        while(!static_socket.connected){
            NSLog(@"static_socket connected inside=%d", static_socket.connected);
            [NSThread sleepForTimeInterval:0.1f];
        }
        
        NSDictionary * postDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: username, @"test", nil]
                                                                    forKeys:[NSArray arrayWithObjects:@"username", @"room_name", nil]];
        
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONReadingMutableContainers error:nil];
        [static_socket emitObjc:@"create_room" withItems:@[jsonData]];
    });
}



+(void) aroundMe:(NSString*)username{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		while(!static_socket.connected){
			NSLog(@"static_socket connected inside=%d", static_socket.connected);
			[NSThread sleepForTimeInterval:0.1f];
		}
		
		NSDictionary * postDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: username, nil]
																	forKeys:[NSArray arrayWithObjects:@"username", nil]];
		
		NSData * jsonData = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONReadingMutableContainers error:nil];
		[static_socket emitObjc:@"get_rooms_around_me" withItems:@[jsonData]];
	});
}

@end