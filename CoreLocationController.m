//
//  CoreLocationController.m
//  Quotify
//
//  Created by Max Rosenblatt on 6/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreLocationController.h"

@implementation CoreLocationController

@synthesize locMgr, delegate;

// Create a new instance of CLLocationManager and set delegate as self
- (id)init {
	self = [super init];
    
	if(self != nil) {
		self.locMgr = [[[CLLocationManager alloc] init] autorelease]; // Create new instance of locMgr
		self.locMgr.delegate = self; // Set the delegate as self.
	}
    
	return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {  // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
		[self.delegate locationUpdate:newLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {  // Check if the class assigning itself as the delegate conforms to our protocol.  If not, the message will go nowhere.  Not good.
		[self.delegate locationError:error];
	}
}

// Clean up locMgr
- (void)dealloc {
	[self.locMgr release];
	[super dealloc];
}

@end
