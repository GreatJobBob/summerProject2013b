//
//  RootViewControllerInterface.m
//  cocosViewController
//
//  Created by toni on 25/06/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewControllerInterface.h"
#import "ImageManipulationAppDelegate.h"
#import "PhotoBoothController.h"

@implementation RootViewControllerInterface

@synthesize rootViewController;

#pragma mark -
#pragma mark Singleton Variables
static RootViewControllerInterface *rootViewControllerInterfaceSingletonDelegate = nil;

#pragma mark -
#pragma mark Singleton Methods
+ (RootViewControllerInterface *) rootViewControllerInterfaceSharedInstance {
	@synchronized(self) {
		if (rootViewControllerInterfaceSingletonDelegate == nil) {
			[[self alloc] init]; // assignment not done here
		}
	}
	return rootViewControllerInterfaceSingletonDelegate;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (rootViewControllerInterfaceSingletonDelegate == nil) {
			rootViewControllerInterfaceSingletonDelegate = [super allocWithZone:zone];
			// assignment and return on first allocation
			return rootViewControllerInterfaceSingletonDelegate;
		}
	}
	// on subsequent allocation attempts return nil
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
	//do nothing
}

- (id)autorelease {
	return self;
}

-(void) presentModalViewController:(UIViewController*)controller animated:(BOOL)animated {
    [rootViewController presentModalViewController:controller animated:animated];
}


-(void) manipulateImage {
    PhotoBoothController *_photoBooth = [[PhotoBoothController alloc] initWithNibName:@"PhotoBoothController" bundle:nil];
    
    [rootViewController presentModalViewController:_photoBooth animated:YES];
    
    
  
}

-(void) sendContactMail {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = rootViewController;
    
    // Recipient.
    NSString *recipient = [NSString stringWithString:@"your_mail@gmail.com"];
    NSArray *recipientsArray = [NSArray arrayWithObject:recipient];
    [picker setToRecipients:recipientsArray];
    
    // Subject.
    [picker setSubject:NSLocalizedString(@"Feedback", "")];
    
    // Body.
    NSString *emailBody = @"";
    [picker setMessageBody:emailBody isHTML:NO];
    
    [rootViewController presentModalViewController:picker animated:YES];
    
    [picker release];
    
}

@end