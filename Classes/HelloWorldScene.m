//
//  HelloWorldLayer.m
//  WhackAMole
//
//  Created by Ray Wenderlich on 1/5/11.
//  Copyright Ray Wenderlich 2011. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "SimpleAudioEngine.h"
#import "IntroScene.h"

// HelloWorld implementation
@implementation HelloWorld
@synthesize myMole;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (CGPoint)convertPoint:(CGPoint)point {    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return ccp(32 + point.x*2, 64 + point.y*2);
    } else {
        return point;
    }    
}

- (CCAnimation *)animationFromPlist:(NSString *)animPlist delay:(float)delay {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:animPlist ofType:@"plist"];
    NSArray *animImages = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *animFrames = [NSMutableArray array];
    for(NSString *animImage in animImages) {
        [animFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:animImage]];
    }
    return [CCAnimation animationWithFrames:animFrames delay:delay];
    
}

- (float)convertFontSize:(float)fontSize {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return fontSize * 2;
    } else {
        return fontSize;
    }
}





// on "init" you need to initialize your instance
-(id) init
{
    
    
    
    
    
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
        // Determine names of sprite sheets and plists to load
        NSString *bgSheet = @"background.pvr.ccz";
        NSString *bgPlist = @"background.plist";
        NSString *fgSheet = @"foreground.pvr.ccz";
        NSString *fgPlist = @"foreground.plist";
        NSString *sSheet = @"sprites.pvr.ccz";
        NSString *sPlist = @"sprites.plist";
       
        NSString *thulpEmSprites = @"ThulpEm.png";
        NSString *thulpPlist = @"ThulpEm.plist";
        
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            bgSheet = @"background-hd.pvr.ccz";
            bgPlist = @"background-hd.plist";
            fgSheet = @"foreground-hd.pvr.ccz";
            fgPlist = @"foreground-hd.plist";
            sSheet = @"sprites-hd.pvr.ccz";
            sPlist = @"sprites-hd.plist";
            
             thulpEmSprites = @"ThulpEm-hd.png";
             thulpPlist = @"ThulpEm-hd.plist";
            
            
           // NSLog(@"scale = %f",[[UIScreen mainScreen] scale]);
            
            if ( [UIScreen mainScreen].scale == 2.0) {
                thulpEmSprites = @"ThulpEm-ipadhd.png";
                thulpPlist = @"ThulpEm-ipadhd.plist";
                
                
            }
            
        }

     
        
        
        
        
        // Load background and foreground
        //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:bgPlist];
       // [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:fgPlist];
      //  [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:molePlist];
   
        
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:thulpPlist];

      
        
        
        // Add background
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        
        // log size
        NSLog(@"width = %f", winSize.width);
       
        /*
        CCSprite *dirt = [CCSprite spriteWithSpriteFrameName:@"thulpHoles.png"];
        dirt.scale = 1.0;
        dirt.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:dirt z:-2]; 
         */

        // Add foreground
        CCSprite *lower = [CCSprite spriteWithSpriteFrameName:@"thulpBoothBottom.png"];
        //lower.anchorPoint = ccp(0.5, 1);
        lower.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:lower z:1];

        CCSprite *upper = [CCSprite spriteWithSpriteFrameName:@"thulpBoothTop.png"];
      //  upper.anchorPoint = ccp(0.5, 0);
        upper.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:upper z:-1];

        // Load sprites
        CCSpriteBatchNode *spriteNode = [CCSpriteBatchNode batchNodeWithFile:thulpEmSprites];
       
        [self addChild:spriteNode z:0];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:thulpPlist];

        moles = [[NSMutableArray alloc] init];


        CCSprite *mole1 = [CCSprite spriteWithSpriteFrameName:@"singer400face.png"];
        mole1.position = [self convertPoint:ccp(370, 30)];
        [spriteNode addChild:mole1];
        [moles addObject:mole1];
        
 
 
        CCSprite *mole2 = [CCSprite spriteWithSpriteFrameName:@"Construction400Face.png"];
        mole2.position = [self convertPoint:ccp(240, 30)];
        [spriteNode addChild:mole2];
        [moles addObject:mole2];

        
        // load custom mole
      
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"myMole.png"]; //Add the file name
        
        //If file exist in documents folder use that one
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSData *pngData = [NSData dataWithContentsOfFile:filePath];
            
            UIImage *pickedImage = [UIImage imageWithData:pngData];
            
            myMole = [CCSprite spriteWithFile:filePath];
        }
        else {
            //Do somthing else.
        }

        
        // Images are stored in larger size so scale to fit
        myMole.scale=(.55 * [UIScreen mainScreen].scale);
        
        myMole.position = [self convertPoint:ccp(34, 60)];
        
        
        // Load sprites
        CCSpriteBatchNode *spriteNodeA = [CCSpriteBatchNode batchNodeWithFile:thulpEmSprites];
        
        [self addChild:spriteNodeA z:1];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:thulpPlist];
       
       
        CCSprite *moleA = [CCSprite spriteWithSpriteFrameName:@"Headset400.png"];
       
        
        moleA.position = [self convertPoint:ccp(110,30)];
        
        //[spriteNodeA addChild:moleA];
        [moleA addChild:myMole z:-1];
       
        [moles addObject:moleA];
    
        /*
        
        CCNode *stars = [CCNode node];
        
        CCSprite *star1 = [CCSprite spriteWithFile:@"star.png"];
        star1.position = ccp(-10, 0);
        [stars addChild:star1];
        
        CCSprite *star2 = [CCSprite spriteWithFile:@"star.png"];
        star2.position = ccp(0, 0);
        [stars addChild:star2];
        
        CCSprite *star3 = [CCSprite spriteWithFile:@"star.png"];
        star3.position = ccp(10, 0);
        [stars addChild:star3];
        
        [self addChild:stars];
        
        */
        
        
 
        
        // load custom mole
        
        //[photoImage setImage:pickedImage];
        

        
        
        
        
      //  CCSprite *mole3 = [CCSprite spriteWithFile:filePath];
       // mole3.texture = mole2.texture;
        myMole.visible = true;
        
       [self addChild:moleA z:0];
       // CCSprite *mole3 = [CCSprite spriteWithSpriteFrameName:@"mole_1.png"];
       
        
        
      
       
        
        
        
        // [spriteNode addChild:mole3];
        //[moles addObject:myMole];
        
        [self schedule:@selector(tryPopMoles:) interval:0.5];
        
        // Create animations
      /*
        laughAnim = [self animationFromPlist:@"laughAnim" delay:0.1];
        hitAnim = [self animationFromPlist:@"hitAnim" delay:0.02];
        [[CCAnimationCache sharedAnimationCache] addAnimation:laughAnim name:@"laughAnim"];
        [[CCAnimationCache sharedAnimationCache] addAnimation:hitAnim name:@"hitAnim"];
        */
        
        
        // Set touch enabled
        self.isTouchEnabled = YES;

        // Add label
        float margin = 10;
        label = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Verdana" fontSize:[self convertFontSize:14.0]];
        label.anchorPoint = ccp(1, 0);
        label.position = ccp(winSize.width - margin, margin);
        [self addChild:label z:10];
        
        // Preload sound effects
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"laugh.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"ow.caf"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ThulpEm1.aiff" loop:YES];
        
        CCMenu * myMenu = [CCMenu menuWithItems:nil];
        CCMenuItemImage *menuItem1 = [CCMenuItemImage itemFromNormalImage: @"Icon@2x.png"
                                                            selectedImage: @"Icon-Small.png"
                                                                   target:self
                                                                 selector:@selector(buttonClicked:)];
        myMenu.position = ccp(320,180);
        myMenu.scale = 0.75;
        [myMenu addChild:menuItem1];
        [self addChild:myMenu z:1];
        
        
        
	}
	return self;
}

- (void)buttonClicked:(UIButton*)sender {
    [[CCDirector sharedDirector] replaceScene: [Intro scene]];
    
    
    
    
}







- (void)setTappable:(id)sender {
    CCSprite *mole = (CCSprite *)sender;    
    [mole setUserData:TRUE];
   // [[SimpleAudioEngine sharedEngine] playEffect:@"laugh.caf"];
}

- (void)unsetTappable:(id)sender {
    CCSprite *mole = (CCSprite *)sender;
    [mole setUserData:FALSE];
}

- (void) popMole:(CCSprite *)mole {
    
     totalSpawns++;
    
 //   [mole setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"mole_1.png"]];
    
    // Pop mole
    CCMoveBy *moveUp = [CCMoveBy actionWithDuration:0.3 position:ccp(0, mole.contentSize.height)];   // changing this to 200 makes the game a lot different bk
    CCCallFunc *setTappable = [CCCallFuncN actionWithTarget:self selector:@selector(setTappable:)];
    CCEaseInOut *easeMoveUp = [CCEaseInOut actionWithAction:moveUp rate:6.0];
    CCAction *wait = [CCMoveBy actionWithDuration:0.5 position:ccp(0,0)];

 //   CCAnimate *laugh = [CCAnimate actionWithAnimation:laughAnim restoreOriginalFrame:YES];
    CCCallFunc *unsetTappable = [CCCallFuncN actionWithTarget:self selector:@selector(unsetTappable:)];    
    CCAction *easeMoveDown = [easeMoveUp reverse];
 //   [mole runAction:[CCSequence actions:easeMoveUp, setTappable, laugh, unsetTappable, easeMoveDown, nil]];
  
    /// bk  turn off laugh
  
    
    
    [mole runAction:[CCSequence actions:setTappable, easeMoveUp, wait,  unsetTappable, easeMoveDown, nil]];

 /*   if(((arc4random() % 10) + 1) > 7){
   [myMole runAction:[CCSequence actions: easeMoveUp, setTappable,  unsetTappable, easeMoveDown, nil]];
    }
  
  */
  }

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:kCCMenuTouchPriority swallowsTouches:NO];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{ 
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    for (CCSprite *mole in moles) {
        if (mole.userData == FALSE) continue;
        if (CGRectContainsPoint(mole.boundingBox, touchLocation)) {
            
            [[SimpleAudioEngine sharedEngine] playEffect:@"ow.caf"];
            
            mole.userData = FALSE;            
            score+= 10;
            
            [mole stopAllActions];
          //  CCAnimate *hit = [CCAnimate actionWithAnimation:hitAnim restoreOriginalFrame:NO];
            //CCMoveBy *moveDown = [CCMoveBy actionWithDuration:0.2 position:ccp(0, -mole.contentSize.height)];
            CCMoveBy *moveDown = [CCMoveBy actionWithDuration:0.2 position:ccp(0, -mole.contentSize.height)];
                                                                               
            CCEaseInOut *easeMoveDown = [CCEaseInOut actionWithAction:moveDown rate:3.0];
            [mole runAction:[CCSequence actions: easeMoveDown, nil]];
        }
    }    
    return TRUE;
}

- (void)tryPopMoles:(ccTime)dt {
    
    if (gameOver) return;

    [label setString:[NSString stringWithFormat:@"Score: %d", score]];

    if (totalSpawns >= 50) {
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCLabelTTF *goLabel = [CCLabelTTF labelWithString:@"Level Complete!" fontName:@"Verdana" fontSize:[self convertFontSize:48.0]];
        goLabel.position = ccp(winSize.width/2, winSize.height/2);
        goLabel.scale = 0.1;
        [self addChild:goLabel z:10];                
        [goLabel runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
        
        
      
        
        gameOver = true;
        
        return;
        
    }
    
    for (CCSprite *mole in moles) {            
        if (arc4random() % 2 == 0) {
            if (mole.numberOfRunningActions == 0) {
                [self popMole:mole];
            }
        }
    }     
}



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[moles release];
    moles = nil;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
