#import "GameViewController.h"
#import <AssimpKit/PostProcessingFlags.h>
#import <AssimpKit/SCNNode+AssimpImport.h>
#import <AssimpKit/SCNScene+AssimpImport.h>

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Load the scene
    SCNAssimpScene *scene =
        [SCNScene assimpSceneWithURL:[NSURL URLWithString:self.modelFilePath]
                    postProcessFlags:AssimpKit_Process_FlipUVs |
                                     AssimpKit_Process_Triangulate];

    // Load the animation scene
    if (self.animFilePath)
    {
        SCNAssimpScene *animScene =
            [SCNScene assimpSceneWithURL:[NSURL URLWithString:self.animFilePath]
                        postProcessFlags:AssimpKit_Process_FlipUVs |
                                         AssimpKit_Process_Triangulate];
        NSArray *animationKeys = animScene.animationKeys;
        // If multiple animations exist, load the first animation
        if (animationKeys.count > 0)
        {
            SCNAssimpAnimSettings *settings =
                [[SCNAssimpAnimSettings alloc] init];
            settings.repeatCount = 3;

            NSString *key = [animationKeys objectAtIndex:0];
            SCNAnimationEventBlock eventBlock =
                ^(CAAnimation *animation, id animatedObject,
                  BOOL playingBackward) {
                  NSLog(@" Animation Event triggered ");

                  // To test removing animation uncomment
                  // Then the animation wont repeat 3 times
                  // as it will be removed after 90% of the first loop
                  // is completed, as event key time is 0.9
                  // [scene.rootNode removeAnimationSceneForKey:key
                  //                            fadeOutDuration:0.3];
                  // [scene.rootNode pauseAnimationSceneForKey:key];
                  // [scene.rootNode resumeAnimationSceneForKey:key];
                };
            SCNAnimationEvent *animEvent =
                [SCNAnimationEvent animationEventWithKeyTime:0.5f
                                                       block:eventBlock];
            NSArray *animEvents =
                [[NSArray alloc] initWithObjects:animEvent, nil];
            settings.animationEvents = animEvents;
            settings.delegate = self;

            SCNScene *animation = [animScene animationSceneForKey:key];
            [scene.modelScene.rootNode addAnimationScene:animation
                                                  forKey:key
                                            withSettings:settings];
        }
    }

    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;

    // set the scene to the view
    scnView.scene = scene.modelScene;

    // allows the user to manipulate the camera
    scnView.allowsCameraControl = YES;

    // show statistics such as fps and timing information
    scnView.showsStatistics = YES;

    // configure the view
    scnView.backgroundColor = [UIColor blackColor];

    scnView.playing = YES;
}

- (void)animationDidStart:(CAAnimation *)anim
{
    NSLog(@" animation did start...");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@" animation did stop...");
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==
        UIUserInterfaceIdiomPhone)
    {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    else
    {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
