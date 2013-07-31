//
//  IntroScene.m
//  ThrashingTime
//
//  Created by Robert kessler on 6/30/13.
//  Copyright (c) 2013 roslyn-Robot.com. All rights reserved.
//

#import "IntroScene.h"
#import "SimpleAudioEngine.h"
#import "HelloWorldScene.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import "PhotoPicker.h"
#import "photoCropper.h"  
#import "RootViewControllerInterface.h"


@implementation Intro


+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Intro *layer = [Intro node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

    
  



-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
        // Determine names of sprite sheets and plists to load
        //To create a sprite from a file (png, jpg):
      
        
        CCSprite *mySprite = [CCSprite spriteWithFile:@"wallpaper.jpg"]; //make sure you have imported the image file to your resources folder.
  
        //To set it's position on your scene:
        mySprite.position = ccp(240,180);   // that position would be the center of an iPhone/iPod screen
        
        //To add it to the scene:
        [self addChild: mySprite];
        
        
        
        CCMenu * myMenu = [CCMenu menuWithItems:nil];
        CCMenuItemImage *menuItem1 = [CCMenuItemImage itemFromNormalImage: @"Icon@2x.png"
                                                            selectedImage: @"Icon-Small.png"
                                                                   target:self
                                                                 selector:@selector(doSomething:)];
        [myMenu addChild:menuItem1];
      
        
        
        CCMenuItemImage *menuItem2 = [CCMenuItemImage itemFromNormalImage: @"Icon@2x.png"
                                                            selectedImage: @"Icon-Small.png"
                                                                   target:self
                                                                 selector:@selector(selectPhotoPressed:)];
        
        
        
        
        [myMenu addChild:menuItem2];
        
        menuItem1.position =ccp(100,100);
     
        
        
        
        CCMenuItemImage *menuItem3 = [CCMenuItemImage itemFromNormalImage: @"Icon@2x.png"
                                                            selectedImage: @"Icon-Small.png"
                                                                   target:self
                                                                 selector:@selector(manipulateImage:)];
        
        
        
        
        [myMenu addChild:menuItem3];
        
        menuItem3.position =ccp(30,100);
        
        
        
        
        
        
        
        
        
        
        
        
        [self addChild:myMenu];
        myMenu.position = CGPointMake(200.0, 200.0);
        
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        
        CCLabelTTF *goLabel = [CCLabelTTF labelWithString:@"Thulpster" fontName:@"Verdana" fontSize:[self convertFontSize:48.0]];
        goLabel.position = ccp(winSize.width/2, winSize.height/2);
        
        goLabel.scale = 0.1;
        [self addChild:goLabel z:10];
        [goLabel runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
        
        
        
	}
	return self;
}


- (float)convertFontSize:(float)fontSize {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return fontSize * 2;
    } else {
        return fontSize;
    }
}



- (void)doSomething:(UIButton*)sender {
    [[CCDirector sharedDirector] replaceScene: [HelloWorld scene]];
    //[self pickPhoto:nil];
    
}

- (void)selectPhotoPressed:(UIButton*)sender {
      [[RootViewControllerInterface rootViewControllerInterfaceSharedInstance] sendContactMail];
}

- (void)manipulateImage:(UIButton*)sender {
    [[RootViewControllerInterface rootViewControllerInterfaceSharedInstance] manipulateImage];
}


@end
