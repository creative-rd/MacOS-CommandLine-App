//
//  Avatar.m
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/23/20.
//

#import "Avatar.h"
#import "AvatarParser.h"

// Priavte property to hold the game object
@interface Avatar()
@property (nonatomic, strong) NSArray *gameModelObjects;
@end

@implementation Avatar

@synthesize pathName = _pathName;
@synthesize gameModelObjects = _gameModelObjects;

- (instancetype)initWithPath:(NSString *)pathName {
  self = [super init];
  if (self) {
    _pathName = pathName;
  }
  return self;
}

- (void)validateGivenPathName {
  if (self.pathName != nil) {
    // Instantiate FileManager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *localFileName = self.pathName;
    
    //Check if the file exists at the given path
    if ([fileManager fileExistsAtPath: localFileName] == YES) {
      // Check if the given path from the user is 1. Readable 2. Writable and 3. Executable
      if ([fileManager isWritableFileAtPath: localFileName] && [fileManager isReadableFileAtPath: localFileName] && [fileManager isExecutableFileAtPath: localFileName]) {
        NSLog(@"File exists");
      }
    }
  }
}

- (void)loadGameAndAvatars {
  NSArray *jsonFileData = [self JSONFromFile];
  if ([jsonFileData count] > 0) {
    AvatarParser *parser = [[AvatarParser alloc] initWithJSONData: jsonFileData];
    _gameModelObjects = [parser gameModelData];
  }
}

- (NSArray *)JSONFromFile {
  NSURL *currentDirectoryURL = [NSURL fileURLWithPath:[[NSFileManager defaultManager] currentDirectoryPath]];
  NSURL *bundleURL = [NSURL fileURLWithPath: @"JSON.bundle" relativeToURL: currentDirectoryURL];
  NSBundle *bundle = [NSBundle bundleWithURL: bundleURL];
  NSURL *filePath = [bundle URLForResource:@"avatarGame"
                                withExtension:@"json"];
  // Check for filePath else it can't find the content of the URL
  NSArray *json;
  if (filePath != nil) {
    NSString *myJSON = [[NSString alloc] initWithContentsOfURL: filePath encoding: NSUTF8StringEncoding error: NULL];
    NSError *error =  nil;
    json = [[NSArray alloc] init];
    json = [NSJSONSerialization JSONObjectWithData: [myJSON dataUsingEncoding: NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error:&error];
  }
  return json;
}

@end
