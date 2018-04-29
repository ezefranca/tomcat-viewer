#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

#define DEFAULT @"/bin/sh "
#define TOMCAT  @"/Library/Tomcat"
#define START   @"/bin/startup.sh"
#define STOP  @"/bin/shutdown.sh"
#define AS(A,B)    [(A) stringByAppendingString:(B)]

@property (assign, nonatomic) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSWindow *settingsWindow;
@property (assign, nonatomic) IBOutlet NSTextField *tomCatTextField;
@property (assign, nonatomic) IBOutlet NSTextField *portTextField;

- (IBAction)startTomCat:(id)sender;
- (IBAction)stopTomCat:(id)sender;
- (IBAction)openTomCat:(id)sender;
- (IBAction)openSettings:(id)sender;
- (IBAction)saveSettings:(id)sender;

@end

