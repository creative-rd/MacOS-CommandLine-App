//
//  Avatar.m
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/23/20.
//

#import "TWAvatarHome.h"
#import "TWAvatarParser.h"

// Priavte property to hold the game object
@interface TWAvatarHome()
@property (nonatomic, strong) NSArray *gameModelObjects;
@property (nonatomic, strong) NSMutableDictionary *shuffledAvatarsDictionary;
@end

@implementation TWAvatarHome

@synthesize gameModelObjects = _gameModelObjects;
@synthesize gameMapperDictionary = _gameMapperDictionary;
@synthesize shuffledAvatarsDictionary = _shuffledAvatarsDictionary;

int AVATAR_LIMIT = 5;

// Getter to return the Game Model Object
- (void) listGamesAndAvatars {
  if (_gameModelObjects.count > 0) {
    _gameMapperDictionary = [[NSMutableDictionary alloc] initWithCapacity: _gameModelObjects.count];
    int index = 1;
    NSLog(@"TOTAL COUNT == %lu", [_gameModelObjects count]);
    for(TWGameModel* game in _gameModelObjects) {
      NSNumber *key = @(game.gameId);
      [_gameMapperDictionary setObject: key forKey: [NSNumber numberWithInt: index]];
      NSLog(@"%d %@ ----- Avatars available - %lu", index, game.name, [[game parseAvatarData] count]);
      index++;
    }
  } else {
    NSLog(@"Oh ! There is no game and avatars");
  }
}

- (void) loadRandomAvatars: (NSString*) game {
  NSNumber* gameId = [_gameMapperDictionary objectForKey: [NSNumber numberWithInt: (int)[game integerValue]]];
  if (gameId) {
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"gameId == %d", gameId.intValue];
    NSArray *filteredArray = [_gameModelObjects filteredArrayUsingPredicate:bPredicate];
    if ([filteredArray count] > 0 ) {
      _shuffledAvatarsDictionary = [[NSMutableDictionary alloc] initWithCapacity: AVATAR_LIMIT];
      TWGameModel *model = [filteredArray objectAtIndex: 0];
      NSArray *avatarData = [model parseAvatarData];
      NSArray *randomAvatars = [self generate: AVATAR_LIMIT randomUniqueNumbersBetween: 0 upperLimit: (int)[avatarData count]];
      if ([randomAvatars count] > 0 && [randomAvatars count] > 0) {
        int index = 1;
        for (NSString *ids in randomAvatars) {
          NSString *avatarIndex = randomAvatars[ids.intValue];
          TWAvatarModel *avatarModel = avatarData[avatarIndex.intValue];
          NSLog(@"%d %@", index, avatarModel.name);
          [_shuffledAvatarsDictionary setObject: avatarIndex forKey: [NSNumber numberWithInt: index]];
          index++;
        }
      }
    }
  }
}

- (void)loadGameAndAvatars {
  NSArray *jsonFileData = [self JSONFromFile];
  if ([jsonFileData count] > 0) {
    TWAvatarParser *parser = [[TWAvatarParser alloc] initWithJSONData: jsonFileData];
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


- (NSArray *)generate:(int)n randomUniqueNumbersBetween:(int)lowerLimit upperLimit:(int)upperLimit {
  NSMutableArray *randomNumberArray = [NSMutableArray arrayWithCapacity: upperLimit - lowerLimit];
  for (int i = lowerLimit; i < upperLimit; i++) {
    [randomNumberArray addObject:@(i)];
  }
  for (NSUInteger i = 0; i < [randomNumberArray count]; i++) {
    int j = arc4random_uniform([randomNumberArray count]);
    NSNumber *jNumber = randomNumberArray[j];
    NSNumber *iNumber = randomNumberArray[i];
    randomNumberArray[j] = iNumber;
    randomNumberArray[i] = jNumber;
  }
  return [randomNumberArray subarrayWithRange: NSMakeRange(0, n)];
}
@end
