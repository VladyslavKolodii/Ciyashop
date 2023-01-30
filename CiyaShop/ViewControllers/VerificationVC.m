//
//  VerificationVC.m
//  CiyaShop
//
//  Created by Kaushal Parmar on 03/06/19.
//  Copyright © 2019 Potenza. All rights reserved.
//

#import "VerificationVC.h"

@import Firebase;
@import AuthenticationServices;

@interface VerificationVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblVerification;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@property (weak, nonatomic) IBOutlet UIButton *btnVerify;
@property (weak, nonatomic) IBOutlet UIButton *btnResendOTP;

@property (weak, nonatomic) IBOutlet UITextField *txtVerificationCode;

@end

@implementation VerificationVC
@synthesize strPhoneNumber, delegate, strVerificationToken;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [Util setSecondaryColorButton:self.btnVerify];
    [Util setSecondaryColorButton:self.btnResendOTP];

    self.txtVerificationCode.font = Font_Size_Big_Title;
    self.lblVerification.font = Font_Size_Navigation_Title_Medium;
    self.lblDescription.font = Font_Size_Product_Name_Medium;
    
    if (@available(iOS 12.0, *)) {
        self.txtVerificationCode.textContentType = UITextContentTypeOneTimeCode;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.lblVerification.text = [MCLocalization stringForKey:@"Verification Code"];
    self.lblDescription.text = [NSString stringWithFormat:@"%@ %@", [MCLocalization stringForKey:@"Please type verification code sent to"], strPhoneNumber];
    
    [self.btnVerify setTitle:[MCLocalization stringForKey:@"Validate OTP"] forState:UIControlStateNormal];
    [self.btnResendOTP setTitle:[MCLocalization stringForKey:@"Resend OTP"] forState:UIControlStateNormal];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {// when the backward clicked, let it go :)
//        if (self.txtVerificationCode.text.length%2 == 0) {
//            NSRange r;
//            r.location = 0;
//            r.length = [self.txtVerificationCode.text length]-1;
//            NSString* shorted = [self.txtVerificationCode.text substringWithRange:r];
//            self.txtVerificationCode.text = shorted;
//        }
        return YES;
    } else if (textField.text.length == 6) {
        return false;
    }
//    else if ((textField.text.length >= 1) && (string.length > 0)) {
//        NSInteger nextTag = textField.tag + 1;
//        // Try to find next responder
//        UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
//        //        if (! nextResponder)
//        //            nextResponder = [textField.superview viewWithTag:1];
//
//        if (nextResponder)
//            // Found next responder, so set it.
//            [nextResponder becomeFirstResponder];
//
//        return NO;
//    }
    return YES;
}

- (IBAction)txtVerificationChanged:(id)sender {
    if (self.txtVerificationCode.text.length == 0) {
        //no text
    } else if (self.txtVerificationCode.text.length == 6) {
        //All text Added
    } else if (self.txtVerificationCode.text.length%2 != 0) {
        //Odd Number So add '-' after text
//        self.txtVerificationCode.text = [NSString stringWithFormat:@"%@-", self.txtVerificationCode.text];
    }
}

#pragma mark - UIButton Clicked

- (IBAction)btnBackClicked:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)btnVerifyClicked:(id)sender {
    if (self.txtVerificationCode.text.length == 0) {
        ALERTVIEW([MCLocalization stringForKey:@"Enter Verification Code"], self);
    } else {
        [self verifyOTP];
    }
}

- (IBAction)btnResendOTPClicked:(id)sender {
    self.txtVerificationCode.text = @"";
    [self sendMessage];
}

#pragma mark - Firebase OTP verification

-(void)sendMessage {
    SHOW_LOADER_ANIMTION_1(self);
    NSArray *arr = [strPhoneNumber componentsSeparatedByString:@" "];
    [[FIRPhoneAuthProvider provider] verifyPhoneNumber:[arr objectAtIndex:arr.count - 1] UIDelegate:nil completion:^(NSString * _Nullable verificationID, NSError * _Nullable error) {
        HIDE_PROGRESS_1(self);
        if (error) {
            ALERTVIEW(error.localizedDescription, self);
            NSLog(@"Error while sending confirmation code = %@",error.localizedDescription);
        } else {
            NSString *str = [NSString stringWithFormat:@"%@ %@", [MCLocalization stringForKey:@"OTP is sent again on"], self->strPhoneNumber];
            ALERTVIEW(str, self);
            NSLog(@"Confirmation code did sent  = %@",verificationID);
            self->strVerificationToken = verificationID;
        }
    }];
}

-(void)verifyOTP {
    NSString *strOTP = [self.txtVerificationCode.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    FIRAuthCredential *credential = [[FIRPhoneAuthProvider provider]
                                     credentialWithVerificationID:strVerificationToken
                                     verificationCode:strOTP];
    SHOW_LOADER_ANIMTION_1(self);
    
    [[FIRAuth auth] signInWithCredential:credential
                              completion:^(FIRAuthDataResult * _Nullable authResult,
                                           NSError * _Nullable error) {
                                  HIDE_PROGRESS_1(self);
                                  if (error) {
                                      // ...
                                      ALERTVIEW(error.localizedDescription, self);
                                      return;
                                  }
                                  // User successfully signed in. Get user data from the FIRUser object
//                                  if (authResult == nil) { return; }
//                                  FIRUser *user = authResult.user;
//                                  [self verifyUser];
                                  [self dismissViewControllerAnimated:true completion:^{
                                      if (self->delegate != nil) {
                                          [self->delegate successInVerification];
                                      }
                                  }];
                              }];

}

#pragma mark - API call

-(void)verifyUser
{
    SHOW_LOADER_ANIMTION_1(self);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.strUserId forKey:@"user_id"];
    [CiyaShopAPISecurity verifyCustomer:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        if (success)
        {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                HIDE_PROGRESS_1(self);
                [self dismissViewControllerAnimated:true completion:^{
                    if (self->delegate != nil) {
                        [self->delegate successInVerification];
                    }
                }];
            }
            else if ([[dictionary valueForKey:@"status"] isEqualToString:@"error"])
            {
                HIDE_PROGRESS_1(self);
                NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                NSAttributedString *decodedString;
                decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                 options:options
                                                      documentAttributes:NULL
                                                                   error:NULL];
                ALERTVIEW(decodedString.string, self);
            }
            else
            {
                HIDE_PROGRESS_1(self);
                ALERTVIEW([MCLocalization stringForKey:@"Your Email address or password is not correct"], self);
            }
        }
        else
        {
            HIDE_PROGRESS_1(self);
            if (dictionary.count > 0)
            {
                if ([[dictionary valueForKey:@"status"] isEqualToString:@"error"])
                {
                    NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                    NSAttributedString *decodedString;
                    decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                     options:options
                                                          documentAttributes:NULL
                                                                       error:NULL];
                    ALERTVIEW(decodedString.string, self);
                }
                else
                {
                    ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
                }
            }
            else
            {
                if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"]) {
                    NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                    NSAttributedString *decodedString;
                    decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                     options:options
                                                          documentAttributes:NULL
                                                                       error:NULL];
                    ALERTVIEW(decodedString.string, self);
                }
                else
                {
                    ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
                }
            }
        }
    }];
}

@end
