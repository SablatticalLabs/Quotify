//
//  Comm.h
//  Quotify
//
//  Created by Max Rosenblatt on 4/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Quote.h"


@interface Comm : NSObject {
    

    @private
    
}
extern NSString * const sendQuoteToURL;
extern NSString * const sendImageToURLwithPrefix;


-(BOOL)sendQuote:(Quote*)theQuote;
-(BOOL)addImage:(UIImage*)theImage toQuoteWithID:(NSString*)postID;
-(NSString *)sendHTTPrequest:(NSString*)myData;


@end
