//
//  main.m
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/21/20.
//

#import <Foundation/Foundation.h>
#import "CommandLine/TWConsoleIO.h"
#import "FileManager/TWFileManager.h"
#import "TWAvatarHome/TWAvatarHome.h"

BOOL isGivenPathValid(NSString* pathName) {
  if (![pathName isEqualToString:@""]) {
    TWFileManager *fileManager = [[TWFileManager alloc] initWithPath: pathName];
    BOOL isvalid =  [fileManager isValidPathName];
    return isvalid;
  }
  return false;
}

void initializeAvatar() {
  TWConsoleIO *consoleIOObj = [TWConsoleIO sharedInstance];
  [consoleIOObj writeMessage:@"**********  Welcome to Twitch Challenge  **********"];
  [consoleIOObj writeMessage:@"======> Please specify the directory to download the Game Images"];
  NSString* inputPath = [consoleIOObj getInput];
  NSString* trimmedPath = [inputPath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if (isGivenPathValid(trimmedPath)) {
    
    TWAvatarHome *home = [[TWAvatarHome alloc] init];
    [home loadGameAndAvatars];
    [home listGamesAndAvatars];

    [consoleIOObj writeMessage:@"**********  Select a game number from the above list *********"];
    
    NSString* selectedGame = [consoleIOObj getInput];
    [home loadRandomAvatars: selectedGame];
    
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
