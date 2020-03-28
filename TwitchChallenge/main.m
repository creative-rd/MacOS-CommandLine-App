//
//  main.m
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/21/20.
//

#import <Foundation/Foundation.h>
#import "CommandLine/TWConsoleIO.h"
#import "FileManager/TWFileManager.h"
#import "Home/TWAvatarHome.h"

NSString* EXIT_KEY = @"r";

BOOL isGivenPathValid(NSString* pathName) {
  if (![pathName isEqualToString:@""]) {
    TWFileManager *fileManager = [TWFileManager sharedManager];
    BOOL isvalid =  [fileManager isValid: pathName];
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
    
    TWAvatarHome *home = [[TWAvatarHome alloc] initWithPath: inputPath];
    [home loadGameAndAvatars];
    [home listGamesAndAvatars];

    [consoleIOObj writeMessage:@"**********  Select a game number from the above list *********"];
    
    NSString* selectedGame = [consoleIOObj getInput];
    [home loadRandomAvatars: selectedGame];
    [home loadAvatars];
    
    [consoleIOObj writeMessage:@"**********  Select an avatar number from the above list or > or <  *********"];

    NSString *selectedAvatar;
    do {
      [consoleIOObj writeMessage:@"Press R for a new Game anytime you want to restart!"];
      selectedAvatar = [consoleIOObj getInput];
      if ([selectedAvatar.lowercaseString isEqualToString: EXIT_KEY]) {
        TWFileManager *fileManager = [TWFileManager sharedManager];
        [fileManager clearDirectory];
      }
      [home processSelectedAvatar: selectedAvatar];
    } while (![selectedAvatar isEqualToString: EXIT_KEY]);
    
  } else {
    [consoleIOObj writeMessage:@"OOOPS !! specified path is invalid *** I'm so sorry please re-run the application to proceed"];
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
