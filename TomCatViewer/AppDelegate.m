#import "AppDelegate.h"
#import "STPrivilegedTask.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[self settingsWindow]setIsVisible:false];
}

- (IBAction)startTomCat:(id)sender {
    NSString *path = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"tomCatPath"];
    
    if (path == nil) {
        path = TOMCAT;
    }
    
    NSString *first = AS(DEFAULT , path);
    NSString *command = AS(first, START);
    
    [self runTask:[[command componentsSeparatedByString:@" "] mutableCopy]];
    return;
}

- (IBAction)stopTomCat:(id)sender {
    NSString *path = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"tomCatPath"];
    
    if (path == nil) {
        path = TOMCAT;
    }
    
    NSString *first = AS(DEFAULT , path);
    NSString *command = AS(first, STOP);
    
    [self runTask:[[command componentsSeparatedByString:@" "] mutableCopy]];
    return;
}

- (IBAction)openSettings:(id)sender {
    [[self settingsWindow]setIsVisible:true];
    
    NSString *port = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"tomCatPort"];
    
    if (port == nil) {
        port = @"8080";
        [[NSUserDefaults standardUserDefaults] setObject:@"8080" forKey:@"tomCatPort"];
    }
    
    NSString *path = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"tomCatPath"];
    
    if (path == nil) {
        path = TOMCAT;
        [[NSUserDefaults standardUserDefaults] setObject:path forKey:@"tomCatPath"];
    }
    
    [[self portTextField]setStringValue:port];
    [[self tomCatTextField]setStringValue:path];
}

- (IBAction)saveSettings:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:_tomCatTextField.stringValue forKey:@"tomCatPath"];
    [[NSUserDefaults standardUserDefaults] setObject:_portTextField.stringValue forKey:@"tomCatPort"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[self settingsWindow]setIsVisible:false];
}

- (void)openTomCat:(id)sender {
    
    NSString *port = [[NSUserDefaults standardUserDefaults]
                      stringForKey:@"tomCatPort"];
    
    if (port == nil) {
        port = @"8080";
        [[NSUserDefaults standardUserDefaults] setObject:@"8080" forKey:@"tomCatPort"];
    }

    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:AS(@"http://localhost:", port)]];
}


- (BOOL)runTask:(NSMutableArray*)components {
    
    STPrivilegedTask *privilegedTask = [[STPrivilegedTask alloc] init];
    
    NSString *launchPath = components[0];
    [components removeObjectAtIndex:0];
    
    [privilegedTask setLaunchPath:launchPath];
    [privilegedTask setArguments:components];
    [privilegedTask setCurrentDirectoryPath:[[NSBundle mainBundle] resourcePath]];
    
    //set it off
    OSStatus err = [privilegedTask launch];
    if (err != errAuthorizationSuccess) {
        if (err == errAuthorizationCanceled) {
            NSLog(@"User cancelled");
            return false;
        }  else {
            NSLog(@"Something went wrong: %d", (int)err);
            // For error codes, see http://www.opensource.apple.com/source/libsecurity_authorization/libsecurity_authorization-36329/lib/Authorization.h
        }
    }
    
    [privilegedTask waitUntilExit];
    
    NSFileHandle *readHandle = [privilegedTask outputFileHandle];
    NSData *outputData = [readHandle readDataToEndOfFile];
    NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
    NSString *exitStr = [NSString stringWithFormat:@"Exit status: %d", privilegedTask.terminationStatus];
    return true;
}

@end
