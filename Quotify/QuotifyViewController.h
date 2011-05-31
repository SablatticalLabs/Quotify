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

@interface QuotifyViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate> {
    
    Quote *currentQuote;
    Comm *myComm;
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
    BOOL quoteTextWasEdited;
    UIView *settingsView;
}

@property (nonatomic, retain) IBOutlet UIView *settingsView;
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

- (IBAction)quotifyPressed:(id)sender;
- (IBAction)imageBoxPressed:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)settingsPressed:(id)sender;
- (IBAction)backToQuoteEntry:(id)sender;
- (IBAction)emailEditingEnded:(id)sender;
- (void)registerForKeyboardNotifications;
- (void)showSuccessView;
- (void)raiseFailurePopupWithTitle:(NSString *) alertTitle andMessage:(NSString *) alertMessage;


@end
