//
//  main.m
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/21/20.
//

#import <Foundation/Foundation.h>
#import "TWAvatarHome.h"
#import "ConsoleIO.h"
#import "TWFileManager/TWFileManager.h"

BOOL isGivenPathValid(NSString* pathName) {
  if (![pathName isEqualToString:@""]) {
    TWFileManager *fileManager = [[TWFileManager alloc] initWithPath: pathName];
    BOOL isvalid =  [fileManager isValidPathName];
    return isvalid;
  }
  return false;
}

void initializeAvatar() {
  ConsoleIO *consoleIOObj = [ConsoleIO sharedInstance];
  [consoleIOObj writeMessage:@"**********  Welcome to Twitch Challenge  **********"];
  [consoleIOObj writeMessage:@"======> Please specify the directory to download the Game Images"];
  NSString* inputPath = [consoleIOObj getInput];
  NSString* trimmedPath = [inputPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if (isGivenPathValid(trimmedPath)) {
    NSLog(@"VALID PATH");
  } else {
    NSLog(@"OOOPS !! specified path is invalid *** I'm so sorry please re-run the application to proceed");
    exit(1);
  }
}

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    // ----- Intialize the game -----
    initializeAvatar();
  }
  return 0;
}
