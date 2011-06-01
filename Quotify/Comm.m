//
//  Comm.m
//  Quotify
//
//  Created by Max Rosenblatt on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Comm.h"


@implementation Comm

@synthesize quoteToSend, quoteSentSuccessfully, delegate;

NSString * const sendQuoteToURL = @"http://www.quotify.it/api/addquote";
NSString * const sendImageToURLwithPrefix = @"http://quotify.it/api/postphoto/";


-(void)sendQuote:(Quote*)theQuote{
    //Send JSON data
    
    // Send HTTP POST request and get response
	//NSString* response = 
    [self sendHTTPrequest:theQuote.getQuoteAsJSONString];
    self.quoteToSend = theQuote;
	//NSLog(@"Output: %@",response);
	
	// Parse the response
	//NSDictionary* result = [response JSONValue];
    //[response release];
    
	//int success = 0;//[[result valueForKey:@"success"] intValue];
	//theQuote.UrlWhereQuoteIsPosted = [result valueForKey:@"url"];
	//theQuote.postID = [result valueForKey:@"guid"];

    
    //Return bool valued success
    //return success;
    //self.quoteSentSuccessfully = success;
}

- (void)sendHTTPrequest:(NSString*)myData{
	NSMutableURLRequest *request = 
	[NSMutableURLRequest requestWithURL:[NSURL URLWithString:sendQuoteToURL] 
                            cachePolicy:NSURLRequestReturnCacheDataElseLoad 
                        timeoutInterval:30];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[myData dataUsingEncoding:NSUTF8StringEncoding]];
	[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	
    //[[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	
	//NSData *urlData;
	//NSURLResponse *urlResponse;
	//NSError *error;
	
	// Make synchronous request
	NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    //NSLog(@"urlResponse: %@",urlResponse);
    //NSLog(@"error: %@",error);
    
 	// Construct a String around the Data from the response and return
	//return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"urlResponse: %@",response);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    int success = 0;
    NSString* dataAsString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"urlData: %@",dataAsString);
    NSDictionary* result = [dataAsString JSONValue];
    if ([result objectForKey:@"success"]) {
        //sent quote succeeded
        success = 1;//[[result valueForKey:@"success"] intValue];
        self.quoteToSend.UrlWhereQuoteIsPosted = [result valueForKey:@"url"];
        self.quoteToSend.postID = [result valueForKey:@"guid"];
        self.quoteSentSuccessfully = success;
        [[self delegate] quoteTextSent];
    }
    if ([result objectForKey:@"Success"]) {
        //image uploaded successfully
        success = 1;
        [[self delegate] quoteImageSent];
    }
    //self.quoteSentSuccessfully = success;
}

-(void)addImage:(UIImage*)theImage toQuoteWithID:(NSString*)postID{
    //Send data
    //Return bool valued success
    //Handle failure in controller
    /*
	 turning the image into a NSData object
	 getting the image back out of the UIImageView
	 setting the quality to 0.9
	 */
	NSData *imageData = UIImageJPEGRepresentation(theImage, 0.9);
	// setting up the URL to post to
    NSString *urlString = [sendImageToURLwithPrefix stringByAppendingString:postID]; 
	
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	[body appendData:[NSData dataWithData:imageData]];
    
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
	//NSString *responseString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
	
    //NSDictionary* result = [responseString JSONValue];
    
    //NSLog(@"image response: %@",responseString);
    
	//int success = [[result valueForKey:@"Success"] intValue];
    
    //return success;    
}

@end
