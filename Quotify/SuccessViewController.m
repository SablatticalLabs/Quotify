//
//  SuccessViewController.m
//  Quotify
//
//  Created by Lior Sabag on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SuccessViewController.h"
//#import "Quote.h"


@implementation SuccessViewController
@synthesize quoteView;
@synthesize imageBox;
@synthesize speaker;
@synthesize witnesses;
@synthesize time;
@synthesize location;
@synthesize newQuoteButton;
@synthesize quote;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithQuote:(Quote *)theQuote
{
    if ((self = [super init])) 
    {
        self.quote = theQuote;
    }
    
    return self;
}

- (IBAction)newQuotePressed:(id)sender 
{
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

-(void)displayQuote:(Quote *)theQuote
{
    self.quoteView.text = theQuote.text;
    self.speaker.text = theQuote.speaker;
    self.witnesses.text = @"work, in, progress"; //theQuote.witnesses;
    self.imageBox.image = theQuote.image;
    self.time.text = theQuote.time;
    //self.location = theQuote.location;
    
}

- (void)dealloc
{
    [quoteView release];
    [imageBox release];
    [speaker release];
    [witnesses release];
    [time release];
    [location release];
    [newQuoteButton release];
    [quote release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.quoteView setBackgroundColor:[UIColor clearColor]];
    [self displayQuote:self.quote];
}

- (void)viewDidUnload
{
    [self setQuoteView:nil];
    [self setImageBox:nil];
    [self setSpeaker:nil];
    [self setWitnesses:nil];
    [self setTime:nil];
    [self setLocation:nil];
    [self setNewQuoteButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
