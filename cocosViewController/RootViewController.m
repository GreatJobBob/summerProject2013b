//
//  RootViewController.m
//  cocosViewController
//
//  Created by toni on 25/06/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

//
// RootViewController + iAd
// If you want to support iAd, use this class as the controller of your iAd
//

#import "cocos2d.h"

#import "RootViewController.h"
#import "GameConfig.h"
#import "AppDelegate.h"
#import "GameConfig.h"
#import "HelloWorldLayer.h"
#import "RootViewController.h"
#import "RootViewControllerInterface.h"
#import "HelloWorldScene.h"
#import "IntroScene.h"


@implementation RootViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	// Custom initialization
	}
	return self;
 }
 */

 
/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
     
     
 }
 */
- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
    
    //	CC_ENABLE_DEFAULT_GL_STATES();
    //	CCDirector *director = [CCDirector sharedDirector];
    //	CGSize size = [director winSize];
    //	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
    //	sprite.position = ccp(size.width/2, size.height/2);
    //	sprite.rotation = -90;
    //	[sprite visit];
    //	[[director openGLView] swapBuffers];
    //	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController
}



-(void) moveBannerOffScreen
{
    CGSize windowSize = [[CCDirector sharedDirector] winSize];
    
    //bannerView.frame = CGRectMake(0, (-1) * windowSize.height, 480, 32);
    bannerView.frame = CGRectMake(0, (-1) * 800, 480, 32);

}




 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
	[super viewDidLoad];
     
     
       
     
     /************************ iad *******************************************/
     
     static NSString * const kADBannerViewClass = @"ADBannerView";
     
     if (NSClassFromString(kADBannerViewClass) != nil) {
         
         
         
         bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
         
         [bannerView setRequiredContentSizeIdentifiers:[NSSet setWithObjects:
                                                        
                                                        ADBannerContentSizeIdentifierLandscape,
                                                        
                                                        nil]];
         
         
         
         bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
         
         
         
         [bannerView setDelegate:self];
         
         
         
        [self moveBannerOffScreen];
         
         
         
     }
     
     //*******************************************************
     
     
     
     // Try to use CADisplayLink director
     // if it fails (SDK < 3.1) use the default director
     if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
         [CCDirector setDirectorType:kCCDirectorTypeDefault];
     
     
     CCDirector *director = [CCDirector sharedDirector];
    
     
     //
     // Create the EAGLView manually
     //  1. Create a RGB565 format. Alternative: RGBA8
     //	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
     //
     //
     EAGLView *glView = [EAGLView viewWithFrame:[self.view bounds]
                                    pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
                                    depthFormat:0						// GL_DEPTH_COMPONENT16_OES
                         ];
     
     // attach the openglView to the director
     [director setOpenGLView:glView];
  
     
     
     // ********* I commented this out, it turns Retina display support off ? ************************** bk
     //	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
     if( ! [director enableRetinaDisplay:YES] )
         CCLOG(@"Retina Display Not supported");
   
     
     
     
     //
     // VERY IMPORTANT:
     // If the rotation is going to be controlled by a UIViewController
     // then the device orientation should be "Portrait".
     //
     // IMPORTANT:
     // By default, this template only supports Landscape orientations.
     // Edit the RootViewController.m file to edit the supported orientations.
     //
#if GAME_AUTOROTATION == kGameAutorotationUIViewController || GAME_AUTOROTATION == kGameAutorotationNone
     [director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
     [director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
     
     [director setAnimationInterval:1.0/60];
     [director setDisplayFPS:YES];
     
     
     // make the OpenGLView a child of the view controlle
    // [viewController setView:glView];
     
     
     [self.view addSubview:glView];
     
     
     //add banner on top
     [self.view addSubview:bannerView];
     
     
     // make the View Controller a child of the main window
   //  [window addSubview: viewController.view];
     
     
     
  //  [window makeKeyAndVisible];
     
     // Default texture format for PNG/BMP/TIFF/JPEG/GIF images
     // It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
     // You can change anytime.
     [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
     
     
     
     
     
     
     
     
     
     
     
     
     
     // Removes the startup flicker
     [self removeStartupFlicker];
     
     // Run the intro Scene
     [[CCDirector sharedDirector] runWithScene: [Intro scene]];
     
     // Add the viewController to the RootViewControllerInterface.
     [[RootViewControllerInterface rootViewControllerInterfaceSharedInstance] setRootViewController:self];
     
  
 }


-(void) moveBannerOnScreen{
  
    [UIView beginAnimations:@"BannerViewIntro" context:NULL];
    
    bannerView.frame = CGRectZero;
    [UIView commitAnimations];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    
    [self moveBannerOnScreen];
}


- (BOOL)shouldAutorotate   {
    
   
    
    // I added tbis method because shouldAutorotate replaces old method in ios 6 bk
    
   UIInterfaceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
    interfaceOrientation = UIInterfaceOrientationLandscapeRight;
  
 
 
 
    //
	// There are 2 ways to support auto-rotation:
	//  - The OpenGL / cocos2d way
	//     - Faster, but doesn't rotate the UIKit objects
	//  - The ViewController way
	//    - A bit slower, but the UiKit objects are placed in the right place
	//
	
#if GAME_AUTOROTATION==kGameAutorotationNone
	//
	// EAGLView won't be autorotated.
	// Since this method should return YES in at least 1 orientation,
	// we return YES only in the Portrait orientation
	//
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION==kGameAutorotationCCDirector
	//
	// EAGLView will be rotated by cocos2d
	//
	// Sample: Autorotate only in landscape mode
	//
	if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
	} else if( interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
	}
	
	// Since this method should return YES in at least 1 orientation,
	// we return YES only in the Portrait orientation
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION == kGameAutorotationUIViewController
	//
	// EAGLView will be rotated by the UIViewController
	//
	// Sample: Autorotate only in landscpe mode
	//
	// return YES for the supported orientations
	
	return ( UIInterfaceOrientationIsLandscape( interfaceOrientation ) );
	
#else
#error Unknown value in GAME_AUTOROTATION
	
#endif // GAME_AUTOROTATION
	
	
	// Shold not happen
	return NO;
    
    
    
    
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	//
	// There are 2 ways to support auto-rotation:
	//  - The OpenGL / cocos2d way
	//     - Faster, but doesn't rotate the UIKit objects
	//  - The ViewController way
	//    - A bit slower, but the UiKit objects are placed in the right place
	//
	
#if GAME_AUTOROTATION==kGameAutorotationNone
	//
	// EAGLView won't be autorotated.
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	//
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION==kGameAutorotationCCDirector
	//
	// EAGLView will be rotated by cocos2d
	//
	// Sample: Autorotate only in landscape mode
	//
	if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
	} else if( interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
	}
	
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION == kGameAutorotationUIViewController
	//
	// EAGLView will be rotated by the UIViewController
	//
	// Sample: Autorotate only in landscpe mode
	//
	// return YES for the supported orientations
	
	return ( UIInterfaceOrientationIsLandscape( interfaceOrientation ) );
	
#else
#error Unknown value in GAME_AUTOROTATION
	
#endif // GAME_AUTOROTATION
	
	
	// Shold not happen
	return NO;
}

//
// This callback only will be called when GAME_AUTOROTATION == kGameAutorotationUIViewController
//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
	//
	// Assuming that the main window has the size of the screen
	// BUG: This won't work if the EAGLView is not fullscreen
	///
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect = CGRectZero;

	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)		
		rect = screenRect;
	
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
	
	CCDirector *director = [CCDirector sharedDirector];
	EAGLView *glView = [director openGLView];
	float contentScaleFactor = [director contentScaleFactor];
	
	if( contentScaleFactor != 1 ) {
	//	rect.size.width *= contentScaleFactor;
	//	rect.size.height *= contentScaleFactor;
	}
	glView.frame = rect;
}
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController


-(void)viewWillLayoutSubviews{
   
    
    // copied most of code from willRotatToInterfaceOrientation above so initial view scales correctly
    
    //
	// Assuming that the main window has the size of the screen
	// BUG: This won't work if the EAGLView is not fullscreen
	///
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect = CGRectZero;
    
	
		rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
	
	CCDirector *director = [CCDirector sharedDirector];
	EAGLView *glView = [director openGLView];
	float contentScaleFactor = [director contentScaleFactor];
	
	if( contentScaleFactor != 1 ) {
	//	rect.size.width *= contentScaleFactor;
	//	rect.size.height *= contentScaleFactor;
	}
	glView.frame = rect;
     
	}

    



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark - Mail Composer Delegate Methods
-(void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissModalViewControllerAnimated:YES];
}


@end

