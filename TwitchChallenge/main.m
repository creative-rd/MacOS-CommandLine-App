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
  
    ConsoleIO *consoleIOObj = [ConsoleIO sharedConsoleIOInstance];
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    if (([arguments count] != 0) && ([arguments count] > 1)) {
      //Arguments at [0] is the path for the binary
      NSString *inputPath = arguments[1];
      Avatar *avatarInstance = [[Avatar alloc] initWithPath: inputPath];
      [avatarInstance validateGivenPathName];
      [avatarInstance loadGameAndAvatars];
    } else {
      NSLog(@"Please supply at least one argument to proceed");
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
