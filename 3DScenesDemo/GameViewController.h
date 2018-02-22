#import <SceneKit/SceneKit.h>
#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController <CAAnimationDelegate>

@property(readwrite, nonatomic) NSString* modelFilePath;
@property(readwrite, nonatomic) NSString* animFilePath;

@end
