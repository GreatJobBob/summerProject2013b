//
//  HelloWorldLayer.m
//  cocosViewController
//
//  Created by toni on 25/06/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "RootViewControllerInterface.h"
#import "HelloWorldScene.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init {
	if( (self=[super init])) {
        
        // ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        // The button.
        CCMenuItemFont *button = [CCMenuItemFont itemFromString:@"Present modal view" target:self selector:@selector(menuCallback:)];
        button.position = ccp( size.width /2 , size.height/2 );
        
        
        
        // the menu.
        CCMenu *menu = [CCMenu menuWithItems:button, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
        
         
        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) menuCallback:(id)sender {
    [[RootViewControllerInterface rootViewControllerInterfaceSharedInstance] sendContactMail];
}

@end
