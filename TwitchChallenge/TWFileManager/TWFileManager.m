//
//  TWFileManager.m
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/24/20.
//

#import "TWFileManager.h"

@implementation TWFileManager

@synthesize pathName = _pathName;

- (instancetype)initWithPath:(NSString *)pathName {
  self = [super init];
  if (self) {
    _pathName = pathName;
  }
  return self;
}

- (BOOL)isValidPathName {
  if (self.pathName != nil) {
    // Instantiate FileManager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *localFileName = self.pathName;
    //Check if the file exists at the given path
    if ([fileManager fileExistsAtPath: localFileName] == YES) {
      // Check if the given path from the user is 1. Readable 2. Writable and 3. Executable
      if ([fileManager isWritableFileAtPath: localFileName] && [fileManager isReadableFileAtPath: localFileName] && [fileManager isExecutableFileAtPath: localFileName]) {
        return true;
      }
    }
  }
  return false;
}

@end
