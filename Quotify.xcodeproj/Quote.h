//
//  Quote.h
//  Quotify
//
//  Created by Max Rosenblatt on 4/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Quote : NSObject {
    @private
    NSString *quotifier;
    NSString *speaker;
    NSString *text;
    NSString *time;
    NSString *postID;
    NSString *UrlWhereQuoteIsPosted;
    NSDictionary *witnesses;
    UIImage *image;    
               
}

@property (retain) NSString *quotifier, *speaker, *text, *time, *postID, *UrlWhereQuoteIsPosted;
@property (retain) NSDictionary *witnesses;
@property (retain) UIImage *image;

-(NSDictionary*)getQuoteAsDictionary;
-(NSString *)getQuoteAsJSONString;
-(void)timestamp;


@end
