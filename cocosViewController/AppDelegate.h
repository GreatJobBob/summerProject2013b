//
//  AppDelegate.h
//  cocosViewController
//
//  Created by toni on 25/06/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;
@property(nonatomic, assign) id<UINavigationControllerDelegate> delegate;

@end
