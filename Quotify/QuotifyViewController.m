//
//  QuotifyViewController.m
//  Quotify
//
//  Created by Max Rosenblatt on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QuotifyViewController.h"

@implementation QuotifyViewController

@synthesize quoteText;
@synthesize speaker;
@synthesize witnesses;
@synthesize imageBox;
@synthesize quotifyButton;
@synthesize imgPicker;
@synthesize firstView;
@synthesize hideKeyboardButton;

- (void)dealloc
{
    [quoteText release];
    [speaker release];
    [witnesses release];
    [imageBox release];
    [quotifyButton release];
    //save (if necessary) and release currentQuote
    [myComm release];
    [imageBoxPressed release];
    [firstView release];
    [hideKeyboardButton release];
    [hideKeyboardButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    ((UIScrollView *)self.view).contentSize=CGSizeMake(320,720);
    
    
    currentQuote = [[Quote alloc] init];
    myComm = [[Comm alloc] init];
    
    self.imgPicker = [[UIImagePickerController alloc] init];
	self.imgPicker.allowsEditing = YES;
	self.imgPicker.delegate = self;
    self.imgPicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    //self.imgPicker.showsCameraControls = YES;
    
    
    
}


- (void)viewDidUnload
{
    [quoteText release];
    quoteText = nil;
    [self setSpeaker:nil];
    [self setQuoteText:nil];
    [self setWitnesses:nil];
    [self setImageBox:nil];
    [self setQuotifyButton:nil];
    [self setFirstView:nil];
    [hideKeyboardButton release];
    hideKeyboardButton = nil;
    [self setHideKeyboardButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// Triggered once the user has chosen a picture
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)pickedImage editingInfo:(NSDictionary *)editInfo {
	currentQuote.image = pickedImage;	
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
    //release imgPicker if necessary
}


- (IBAction)quotifyPressed:(id)sender {
    
    currentQuote.text = quoteText.text;
    currentQuote.speaker = speaker.text;
    currentQuote.witnesses = [NSDictionary dictionaryWithObjects:[witnesses.text componentsSeparatedByString:@","] 
                                                         forKeys:nil];
                              
    
    if ([myComm sendQuote:currentQuote]) {
        if (![myComm addImage:imageBox.image toQuoteWithID:currentQuote.postID]) {
            //this point reached if quote succeeds and image fails
            //quote sent, image failed, save it for later
        }
    } else {
        //oh god the world is ending
        //this point reached if both quote and image fail
        //save the currentQuote and image for later sending
    };
    
}
- (IBAction)imageBoxPressed:(id)sender {
    [self presentModalViewController:self.imgPicker animated:YES];
}

- (IBAction)hideKeyboard:(id)sender {
    [quoteText resignFirstResponder];
	[speaker resignFirstResponder];
	[witnesses resignFirstResponder];
}

@end
