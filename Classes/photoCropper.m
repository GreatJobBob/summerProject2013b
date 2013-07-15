//
//  photoCropper.m
//  ThrashingTime
//
//  Created by Robert kessler on 7/7/13.
//  Copyright (c) 2013 roslyn-Robot.com. All rights reserved.
//

#import "photoCropper.h"
#import "SimpleAudioEngine.h"
#import "HelloWorldScene.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import "PhotoPicker.h"


@implementation photoCropper


+(id) scene {
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	photoCropper *layer = [photoCropper node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init {
    
    
//   [[[CCDirector sharedDirector] openGLView] addSubview:picker.view];
	return self;
}

- (void)doSomething:(UIButton*)sender {
    //[[CCDirector sharedDirector] replaceScene: [photoCropper scene]];
    //[self pickPhoto:nil];
    

//This method is executed as soon as you button is pressed.
UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,100)];
//[ addSubview:newView];  //Add the newView to another View
[newView release];
}
                        
@end
