//
//  QuotifyViewController.h
//  Quotify
//
//  Created by Max Rosenblatt on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quote.h"
#import "Comm.h"

@interface QuotifyViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate> {
    
    Quote *currentQuote;
    Comm *myComm;
    UITextField *speaker;
    UITextField *witnesses;
    UIImageView *imageBox;
    UIButton *quotifyButton;
    UITextView *quoteText;
    UIImagePickerController *imgPicker;
    UIView *firstView;
    UIButton *hideKeyboardButton;
    UIButton *imageBoxPressed;

}

@property (nonatomic, retain) IBOutlet UITextView *quoteText;
@property (nonatomic, retain) IBOutlet UITextField *speaker;
@property (nonatomic, retain) IBOutlet UITextField *witnesses;
@property (nonatomic, retain) IBOutlet UIImageView *imageBox;
@property (nonatomic, retain) IBOutlet UIButton *quotifyButton;
@property (nonatomic, retain) UIImagePickerController *imgPicker;
@property (nonatomic, retain) IBOutlet UIView *firstView;
@property (nonatomic, retain) IBOutlet UIButton *hideKeyboardButton;

- (IBAction)quotifyPressed:(id)sender;
- (IBAction)imageBoxPressed:(id)sender;
- (IBAction)hideKeyboard:(id)sender;


@end
