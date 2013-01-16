//
//  AppDelegate.m
//  GuessMyFriend
//
//  Created by bilal demirci on 10/15/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "IntroLayer.h"

@implementation AppController

@synthesize window=window_, navController=navController_, director=director_,friendController = friendController_;
@synthesize selectedFriends;
@synthesize audioPlayer;
@synthesize appInstalledFriends;
@synthesize showAllFriends;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:0	//GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];

	director_.wantsFullScreenLayout = YES;

	// Display FSP and SPF
	[director_ setDisplayStats:NO];

	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];

	// attach the openglView to the director
	[director_ setView:glView];

	// for rotation and other messages
	[director_ setDelegate:self];

	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
//	[director setProjection:kCCDirectorProjection3D];

	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");

	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"

	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

	// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
	[director_ pushScene: [IntroLayer scene]];
    
	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;
	
	// set the Navigation Controller as the root view controller
//	[window_ addSubview:navController_.view];	// Generates flicker.
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];
    appInstalledFriends  = [[NSArray alloc] init];
	return YES;
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
    [FBSession.activeSession handleDidBecomeActive];
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];

	[super dealloc];
}

//#pragma mark FacebookConnection

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}


//FriendSelection
-(void) showFriendSelector:(BOOL) showAll {
    self.friendController = [[FBFriendPickerViewController alloc] initWithNibName:nil bundle:nil];
    self.friendController.delegate = self;
    self.friendController.title = @"Select Friend to Play";
    self.friendController.allowsMultipleSelection = false;
    if(showAll==NO){
        NSSet *fields = [NSSet setWithObjects:@"installed", nil];
        self.friendController.fieldsForRequest = fields;
    }
    [self.friendController loadData];
    navController_.navigationBarHidden = NO;
    self.showAllFriends = showAll;
    [self.navController pushViewController:self.friendController animated:true];
    
}



-(void)friendPickerViewControllerSelectionDidChange:(FBFriendPickerViewController *)friendPicker {
    self.selectedFriends = friendPicker.selection;
    navController_.navigationBarHidden = YES;
    [self.navController popViewControllerAnimated:YES];
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[IntroLayer scene] withColor:ccWHITE]];
    NSDictionary<FBGraphUser> *friend = [self.selectedFriends objectAtIndex:0];
    
    [[GameData sharedInstance] setOpponent:friend.id];
    [GameData sharedInstance].opponentId = friend.id;
    
    [GameData sharedInstance].gameStatus=[NSNumber numberWithInt:0];
    [GameData sharedInstance].stringLength=[NSNumber numberWithInt:3];
    [[GameManager sharedInstance] createGameWithSelector:@selector(createGameResult:) delegate:self];
    
    //[[SceneManager sharedSceneManager] changeScene:kCreateGameLayer];
    
}
- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker shouldIncludeUser:(id<FBGraphUser>)user
{
    //[user objectForKey:]
    //NSLog(@"count %i",[appInstalledFriends count]);
    if(showAllFriends) {
        return YES;
    }
    else {
        BOOL installed = [user objectForKey:@"installed"] != nil;
        return installed;
    }
    return NO;
}
- (void)playSound:(NSString *)sound format:(NSString *)format {
    [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"%@.%@",sound,format]];
    
}

-(void) createGameResult:(NSDictionary*) jsonData{
    NSDictionary* values = [jsonData objectForKey:@"values"];
    NSNumber* gameId = (NSNumber*)[values objectForKey:@"gameId"];
    [GameData sharedInstance].gameId = gameId;
    [[SceneManager sharedSceneManager] changeScene:kCreateGameLayer];
}
-(void) showProfileScreen {
    [[SceneManager sharedSceneManager] changeScene:kProfileLayer];
}
-(void) getAppInstalledFriends{
 /*   NSString *query =
    @"select uid from user where uid in (select uid2 from friend where uid1=me()) and is_app_user=1";
    // Set up the query parameter
    NSDictionary *queryParam =
    [NSDictionary dictionaryWithObjectsAndKeys:query, @"q", nil];
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (error) {
                                  NSLog(@"Error: %@", [error localizedDescription]);
                              } else {
                                  appInstalledFriends = (NSArray*)[result data];
                                  NSLog(@"count:%i",[appInstalledFriends count]);
                              }
                          }];*/
}
@end

