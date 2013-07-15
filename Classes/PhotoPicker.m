//
//  PhotoPicker.m
//  ThrashingTime
//
//  Created by Robert kessler on 7/2/13.
//  Copyright (c) 2013 roslyn-Robot.com. All rights reserved.
//

#import "PhotoPicker.h"
#import "IntroScene.h"
#import "SimpleAudioEngine.h"
#import "HelloWorldScene.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>



@implementation PhotoPicker



+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PhotoPicker *layer = [PhotoPicker node];
	
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
		
          [self pickPhoto:nil];
            
        
        
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
   // [[CCDirector sharedDirector] replaceScene: [HelloWorld scene]];
    [self pickPhoto:nil];
    
}



-(void)pickPhoto:(UIImagePickerControllerSourceType)sourceType{
    
    UIImagePickerController *picker    = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    picker.wantsFullScreenLayout = NO;
  //  [picker presentModalViewController:picker animated:YES];
    
    [[[CCDirector sharedDirector] openGLView] addSubview:picker.view];
    
}


//-(void)imagePickerController:(UIImagePickerController *)picker
//didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    
//    // newImage is a UIImage do not try to use a UIImageView
//    newImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    // Dismiss UIImagePickerController and release it
//    [picker dismissModalViewControllerAnimated:YES];
//    [picker.view removeFromSuperview];
//    [picker release];
//    // Let's create a sprite now that we have an image
//    CCSprite *imageFromPicker = [CCSprite spriteWithCGImage:newImage.CGImage  key:@"ImageFromPicker"];
//    imageFromPicker.position = ccp(200,200);
//    imageFromPicker.scale = .25;
//    //remove previous
//    [self removeChildByTag:1001 cleanup:TRUE];
//    // add new , but just work at the first time, not working since first time
//    [self addChild:imageFromPicker z:0 tag: 1001];
//    
//}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *anImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(anImage, 1.0);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *tmpPathToFile = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/specificImagedName.jpg", path]];
    
    if([imageData writeToFile:tmpPathToFile atomically:YES]){
        //Write was successful.
        
    }
}

@end
