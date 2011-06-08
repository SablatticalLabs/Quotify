//
//  QuotifyViewController.h
//  Quotify
//
//  Created by Max Rosenblatt on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Quote.h"
#import "Comm.h"
#import "SuccessViewController.h"
#import "CoreLocationController.h"

@interface QuotifyViewController : UIViewController <UIActionSheetDelegate, CommDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate, CoreLocationControllerDelegate> {
    
    Quote *currentQuote;
    Comm *myComm;
    CoreLocationController *locationController;
    UITextField *speaker;
    UITextField *witnesses;
    UIImageView *imageBox;
    UIButton *quotifyButton;
    UITextView *quoteText;
    UIImagePickerController *imgPicker;
    UIViewController *settingsViewController;
    UIView *firstView;
    UIButton *hideKeyboardButton;
    UIButton *imageBoxPressed;
    UIView *activeField;
    UILabel *timestampLabel;
    UIButton *settingsButton;
    UITextField *quotifier;
    SuccessViewController *successViewController;
    UIActivityIndicatorView *quotifyingActivityIndicator;
    BOOL quoteTextWasEdited;
    UIView *settingsView;
    UILabel *locLabel;
}

@property (nonatomic, retain) IBOutlet UIView *settingsView;
@property (nonatomic, retain) IBOutlet UILabel *locLabel;
@property (nonatomic, retain) IBOutlet UITextView *quoteText;
@property (nonatomic, retain) IBOutlet UITextField *speaker;
@property (nonatomic, retain) IBOutlet UITextField *witnesses;
@property (nonatomic, retain) IBOutlet UIImageView *imageBox;
@property (nonatomic, retain) IBOutlet UIButton *quotifyButton;
@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (nonatomic, retain) IBOutlet UIViewController *settingsViewController;
@property (nonatomic, retain) IBOutlet UIView *firstView;
@property (nonatomic, retain) IBOutlet UIButton *hideKeyboardButton;
@property (nonatomic, retain) IBOutlet UILabel *timestampLabel;
@property (nonatomic, retain) IBOutlet UIButton *settingsButton;
@property (nonatomic, retain) IBOutlet UITextField *quotifier;
@property (nonatomic, retain) IBOutlet SuccessViewController *successViewController;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *quotifyingActivityIndicator;
@property (nonatomic, retain) CoreLocationController *locationController;


- (IBAction)quotifyPressed:(id)sender;
- (IBAction)imageBoxPressed:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)settingsPressed:(id)sender;
- (IBAction)backToQuoteEntry:(id)sender;
- (IBAction)emailEditingEnded:(id)sender;
- (void)registerForKeyboardNotifications;
- (void)showSuccessView;
- (void)raiseFailurePopupWithTitle:(NSString *) alertTitle andMessage:(NSString *) alertMessage;
- (void)setupNewQuote;
- (void)showFirstTimeSettings;


@end
