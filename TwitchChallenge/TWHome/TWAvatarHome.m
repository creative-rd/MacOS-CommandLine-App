//
//  Avatar.m
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/23/20.
//

#import "TWAvatarHome.h"
#import "AvatarParser.h"

// Priavte property to hold the game object
@interface Avatar()
@property (nonatomic, strong) NSArray *gameModelObjects;
@end

@implementation Avatar

@synthesize gameModelObjects = _gameModelObjects;

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

// Getter to return the Game Model Object
- (NSArray *)modelObjects {
  return _gameModelObjects;
}

@end
