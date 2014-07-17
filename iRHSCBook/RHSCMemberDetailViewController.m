//
//  RHSCMemberDetailViewController.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-07-08.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCMemberDetailViewController.h"
#import <MessageUI/MessageUI.h>

@interface RHSCMemberDetailViewController ()

@end

@implementation RHSCMemberDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@",_member.firstName,_member.lastName];
    self.emailLabel.text = @"";
    self.emailBtn.hidden = YES;
    if (_member.email != (NSString *)[NSNull null]) {
        if (![_member.email isEqualToString:@"NULL"]) {
            self.emailLabel.text = _member.email;
            self.emailBtn.hidden = NO;
        }
    }
    self.phone1Label.text = @"";
    self.ph1SMSBtn.hidden = YES;
    self.ph1CallBtn.hidden = YES;
    if (_member.phone1 != (NSString *)[NSNull null]) {
        if (![_member.phone1 isEqualToString:@"NULL"]) {
            self.phone1Label.text = _member.phone1;
            self.ph1SMSBtn.hidden = NO;
            self.ph1CallBtn.hidden = NO;
        }
    }
    self.phone2Label.text = @"";
    self.ph2SMSBtn.hidden = YES;
    self.ph2CallBtn.hidden = YES;
    if (_member.phone2 != (NSString *)[NSNull null]) {
        if (![_member.phone2 isEqualToString:@"NULL"]) {
            self.phone2Label.text = _member.phone2;
            self.ph2SMSBtn.hidden = NO;
            self.ph2CallBtn.hidden = NO;
        }
    }
}

- (IBAction)emailMember:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        // Email Subject
        NSString *emailTitle = @"";
        // Email Content
        NSString *messageBody = @"";
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:[self.member email]];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot send email"
                                                        message:@"Cannot email from this device"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)phone1Member:(id)sender {
    NSLog(@"Phoning using number 1");
    NSString *cleanedString = [[[self.member phone1] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:cleanedString];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneNumber]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot place call"
                                                        message:@"Cannot phone from this device"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}

- (IBAction)phone2Member:(id)sender {
    NSLog(@"Phoning using number 2");
    NSString *cleanedString = [[[self.member phone2] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:cleanedString];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneNumber]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot place call"
                                                        message:@"Cannot phone from this device"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}

- (IBAction)sms1Member:(id)sender {
	MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    NSLog(@"Sending SMS using number 1");
    NSString *cleanedString = [[[self.member phone1] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
	if([MFMessageComposeViewController canSendText])
	{
		controller.body = @"";
		controller.recipients = [NSArray arrayWithObject:cleanedString];
		controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:NULL];
	}
}

- (IBAction)sms2Member:(id)sender {
	MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    NSLog(@"Sending SMS using number 2");
    NSString *cleanedString = [[[self.member phone2] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
	if([MFMessageComposeViewController canSendText])
	{
		controller.body = @"";
		controller.recipients = [NSArray arrayWithObject:cleanedString];
		controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:NULL];
	}
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
//			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot send message"
                                                            message:@"Cannot SMS from this device"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
			break;
        }
		case MessageComposeResultSent:
			break;
		default:
			break;
	}
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
