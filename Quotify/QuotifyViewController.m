//  Can you see this?!?!
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
@synthesize timestampLabel;

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
    [timestampLabel release];
    [timestampLabel release];
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
    
    [currentQuote timestamp];
    self.timestampLabel.text = currentQuote.time;
    //get location and tag
    
    self.imgPicker = [[UIImagePickerController alloc] init];
	self.imgPicker.allowsEditing = YES;
	self.imgPicker.delegate = self;
    self.imgPicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    //self.imgPicker.showsCameraControls = YES;
    
    [self registerForKeyboardNotifications];
    quoteTextWasEdited = NO;
    
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
    [timestampLabel release];
    timestampLabel = nil;
    [self setTimestampLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// Triggered once the user has chosen a picture
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)pickedImage editingInfo:(NSDictionary *)editInfo {
	currentQuote.image = pickedImage;	
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
    //release imgPicker if necessary
    
    imageBox.image = currentQuote.image;
}


- (IBAction)quotifyPressed:(id)sender {
    
    currentQuote.text = quoteText.text;
    currentQuote.speaker = (NSString *)speaker.text;
    currentQuote.witnesses = [NSDictionary dictionaryWithObjects:[witnesses.text componentsSeparatedByString:@","] 
                                                         forKeys:[witnesses.text componentsSeparatedByString:@","]];
                              
    
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if(((UIView*)quoteText).isFirstResponder){
        if (!quoteTextWasEdited) {
            quoteText.text = @"";
            quoteTextWasEdited = YES;
            //change the font
        }
        
        activeField = quoteText;
    }
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    ((UIScrollView *)self.view).contentInset = contentInsets;
    ((UIScrollView *)self.view).scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [((UIScrollView *)self.view) setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    ((UIScrollView *)self.view).contentInset = contentInsets;
    ((UIScrollView *)self.view).scrollIndicatorInsets = contentInsets;
}

@end
