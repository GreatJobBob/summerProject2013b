//
//  RootViewController.h
//  cocosViewController
//
//  Created by toni on 25/06/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <iAd/iAd.h>
#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface RootViewController : UIViewController <ADBannerViewDelegate,  MFMailComposeViewControllerDelegate>  {

    ADBannerView *bannerView;

    
}

+(void) moveBannerOnScreen;
-(void) moveBannerOffScreen;
- (void)bannerViewDidLoadAd:(ADBannerView *)banner;


@end
