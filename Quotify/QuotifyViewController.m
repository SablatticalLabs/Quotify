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

@synthesize settingsView;
@synthesize locLabel;
@synthesize quoteText;
@synthesize speaker;
@synthesize witnesses;
@synthesize imageBox;
@synthesize quotifyButton;
@synthesize imgPicker;
@synthesize settingsViewController;
@synthesize firstView;
@synthesize hideKeyboardButton;
@synthesize timestampLabel;
@synthesize settingsButton;
@synthesize quotifier;
@synthesize successViewController;
@synthesize quotifyingActivityIndicator;

- (void)dealloc
{
    [quoteText release];
    [speaker release];
    [witnesses release];
    [imageBox release];
    [quotifyButton release];
    [CLController release];
    //save (if necessary) and release currentQuote
    [myComm release];
    [imageBoxPressed release];
    [firstView release];
    [hideKeyboardButton release];
    [hideKeyboardButton release];
    [timestampLabel release];
    [timestampLabel release];
    [settingsButton release];
    [settingsView release];
    [settingsViewController release];
    [quotifier release];
    [successViewController release];
    [quotifyingActivityIndicator release];
    [locLabel release];
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
    
    ((UIScrollView *)self.view).contentSize=CGSizeMake(320, self.view.frame.size.height);
    
    quoteText.clipsToBounds = YES;
    quoteText.layer.cornerRadius = 10.0f;
    
    currentQuote = [[Quote alloc] init];
    myComm = [[Comm alloc] init];
    myComm.delegate = self;
    
    //get location and tag
    CLController = [[CoreLocationController alloc] init];
	CLController.delegate = self;
	[CLController.locMgr startUpdatingLocation];
    
    
    self.imgPicker = [[UIImagePickerController alloc] init];
	self.imgPicker.allowsEditing = YES;
	self.imgPicker.delegate = self;
    if ( ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]))
	{	
        self.imgPicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        self.imgPicker.showsCameraControls = YES;
    }
    else{
        self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self registerForKeyboardNotifications];
    quoteTextWasEdited = NO;
    
    //[self viewDidAppear:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    currentQuote.quotifier = [[NSUserDefaults standardUserDefaults]objectForKey:@"quotifier"];
    self.quotifier.text = currentQuote.quotifier;
    if ([currentQuote.quotifier rangeOfString:@"@"].location == NSNotFound) {
        [self showFirstTimeSettings];
    }
    
}

- (void)locationUpdate:(MKPlacemark *)location {
	currentQuote.location = location;
    locLabel.text = [NSString stringWithFormat:@"%@, %@",location.thoroughfare, location.locality];
}

- (void)locationError:(NSError *)error {
	locLabel.text = [error description];
}


- (void)showFirstTimeSettings{
    [self presentModalViewController:self.settingsViewController animated:YES];
    [self raiseFailurePopupWithTitle:@"Welcome to Quotify!" andMessage:@"Enter your email address to get started."];
}

- (void)viewDidUnload
{
    [currentQuote release];
    [myComm release];
    [quoteText release];
    [imgPicker release];
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
    [self setSettingsButton:nil];
    [self setSettingsView:nil];
    [self setSettingsViewController:nil];
    [self setQuotifier:nil];
    [self setSuccessViewController:nil];
    [self setQuotifyingActivityIndicator:nil];
    [self setLocLabel:nil];
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

- (void) quoteTextSent:(BOOL)success {
    if (success){
        if(currentQuote.image != nil){
            [myComm addImage:imageBox.image toQuoteWithID:currentQuote.postID];
        }
        else{
            [quotifyingActivityIndicator stopAnimating];
            [self showSuccessView];
        }
        
    }
    else{
        [self raiseFailurePopupWithTitle:@"Quotification Failed!" andMessage:@"Neither your quote nor photo were sent! Check your connection and try again later..."];
    }
}

- (void) quoteImageSent:(BOOL)success {
    [quotifyingActivityIndicator stopAnimating];
    if (success) {
        [self showSuccessView];
    }
    else{
        [self raiseFailurePopupWithTitle:@"Quotification Failed!" andMessage:@"Your quote was sent successfully but the picture was not included."];
    }
}

- (IBAction)quotifyPressed:(id)sender {
    if(([quoteText.text rangeOfString:@"What was said?"].location == NSNotFound)//quoteText was edited 
       && !([quoteText.text isEqualToString:@""]) && !([speaker.text isEqualToString:@""]))//quoteText and speaker are not blank
    {
        currentQuote.text = quoteText.text;
        currentQuote.speaker = (NSString *)speaker.text;
        currentQuote.witnesses = [NSDictionary dictionaryWithObjects:[witnesses.text componentsSeparatedByString:@","] 
                                                             forKeys:[witnesses.text componentsSeparatedByString:@","]];
                              
        [quotifyingActivityIndicator startAnimating];
        [myComm sendQuote:currentQuote];//result will be delegated to quoteTextSent method
    }
    
    else {
        //Popup saying to fill in the fields
        [self raiseFailurePopupWithTitle:@"Oops!" andMessage:@"We need at least a quote and a speaker for it to be awesome..."];
    }
}

- (IBAction)imageBoxPressed:(id)sender {
    if ( ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]))
	{	
    UIActionSheet *pictureSourceActionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Picture", @"Choose from Library", nil];
    pictureSourceActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [pictureSourceActionSheet showFromRect:imageBox.frame inView:self.view animated:YES];
    }
    else
    {
        [self presentModalViewController:self.imgPicker animated:YES];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Take Picture"]) {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:self.imgPicker animated:YES];
    }
    else if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Choose from Library"]){
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:self.imgPicker animated:YES];
    }
}

-(IBAction)settingsPressed:(id)sender {
    [self presentModalViewController:self.settingsViewController animated:YES];
}

- (IBAction)backToQuoteEntry:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)showSuccessView{
    if (!self.successViewController) {
        self.successViewController = [[SuccessViewController alloc] initWithQuote:currentQuote];
    }
    else{
        [self.successViewController displayQuote:currentQuote];
    }
    
    [self presentModalViewController:self.successViewController animated:YES];
}

- (IBAction)emailEditingEnded:(id)sender {
    //save this forever (settings file)
    currentQuote.quotifier = quotifier.text;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:currentQuote.quotifier forKey:@"quotifier"];
    [prefs synchronize];
}

- (IBAction)hideKeyboard:(id)sender {
    [quoteText resignFirstResponder];
	[speaker resignFirstResponder];
	[witnesses resignFirstResponder];
}

// Allow user to move between text fields via "Next" button
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSInteger nextTag = textField.tag + 1;
	// Try to find next responder
	UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
	if (nextResponder) {
		// Found next responder, so set it.
		[nextResponder becomeFirstResponder];
	} else {
		// Not found, so remove keyboard.
		[textField resignFirstResponder];
	}
	return NO; // We do not want UITextField to insert line-breaks.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (void)raiseFailurePopupWithTitle:(NSString *) alertTitle andMessage:(NSString *) alertMessage
{
    UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [failureAlert show];
    [failureAlert release];
}

- (void)setupNewQuote
{
    [currentQuote release];
    currentQuote = [[Quote alloc] init];
    quoteText.text = @"What was said?";
    quoteText.textColor = [UIColor lightGrayColor];
    quoteTextWasEdited = NO;
    speaker.text = @"";
    imageBox.image = nil;
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
    if(((UIView*)self.quoteText).isFirstResponder){
        if (!quoteTextWasEdited) {
            quoteText.text = @"";
            quoteTextWasEdited = YES;
            quoteText.textColor = [UIColor blackColor];
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
    if (quoteTextWasEdited) {
        [currentQuote timestamp];
        self.timestampLabel.text = currentQuote.time;
    }
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    ((UIScrollView *)self.view).contentInset = contentInsets;
    ((UIScrollView *)self.view).scrollIndicatorInsets = contentInsets;
}

@end
