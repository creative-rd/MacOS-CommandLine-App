//
//  main.m
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/21/20.
//

#import <Foundation/Foundation.h>
#import "Avatar.h"
#import "ConsoleIO.h"

void initializeAvatar() {
  ConsoleIO *consoleIOObj = [ConsoleIO sharedInstance];
  [consoleIOObj writeMessage:@"**********  Welcome to the game application, Please provide a directory to download the gameImages  **********"];
  NSString* inputPath = [consoleIOObj getInput];
  // Read the directory provided by the user.
  // 1. Initialize the Avaatar Class.
  // 2. Validate the given path
  // 3. Load the Game and Avatars from the Local JSON file.
  NSLog(@"Input Path ==== %@", inputPath);
  if (![inputPath isEqualToString:@""]) {
    Avatar *avatarInstance = [[Avatar alloc] initWithPath: inputPath];
    [avatarInstance validateGivenPathName];
    [avatarInstance loadGameAndAvatars];
  }
}

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    // ----- Intialize the game -----
    initializeAvatar();
  }
  return 0;
}
