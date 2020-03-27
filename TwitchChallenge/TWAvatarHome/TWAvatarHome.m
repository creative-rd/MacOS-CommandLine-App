//
//  Avatar.m
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/23/20.
//

#import "TWAvatarHome.h"
#import "TWAvatarParser.h"
#import "ImageDownloaderService.h"
#import "Utilities.h"

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
    NSArray *filteredArray = [_gameModelObjects filteredArrayUsingPredicate: bPredicate];
    if ([filteredArray count] > 0 ) {
      _shuffledAvatarsDictionary = [[NSMutableDictionary alloc] initWithCapacity: AVATAR_LIMIT];
      TWGameModel *model = [filteredArray objectAtIndex: 0];
      NSArray *avatarData = [model parseAvatarData];
      NSArray *randomAvatars = [Utilities generate: AVATAR_LIMIT randomUniqueNumbersBetween: 0 upperLimit: (int)[avatarData count]];
      if ([randomAvatars count] > 0 && [randomAvatars count] > 0) {
        int index = 1;
        NSLog(@"Game %@ has %lu avatars below are suggested %d avatars", model.name, (unsigned long)[avatarData count], AVATAR_LIMIT);
        for (NSString *ids in randomAvatars) {
          TWAvatarModel *avatarModel = avatarData[ids.intValue];
          NSLog(@"%d %@", index, avatarModel.name);
          [_shuffledAvatarsDictionary setObject: avatarModel forKey: [NSNumber numberWithInt: index]];
          index++;
        }
      }
    }
  }
}

- (void)downloadAvatarsToDirectory: (NSString*) path {
  dispatch_group_t group = dispatch_group_create();

  dispatch_group_enter(group);
  TWFileManager *fileManager = [TWFileManager sharedManager];
  [fileManager deleteContentOfDirectory: path completion:^{
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  if ([_shuffledAvatarsDictionary count] > 0) {
    for (TWAvatarModel *avatarModel in _shuffledAvatarsDictionary.allValues) {
      NSString *url = [Utilities fullPath: avatarModel.url];
      [self downloadAvatars: url imageName:avatarModel.name atPath: path];
    }
    dispatch_group_leave(group);
  }
  
  dispatch_group_notify(group,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
    NSLog(@"*****************Completed Deletion and Download********************");
  });
}

-(void) downloadAvatars:(NSString *) imageurl imageName: (NSString*)imgName atPath: (NSString*) pathName {
  
  ImageDownloaderService *service = [ImageDownloaderService sharedService];
  TWFileManager *fileManager = [TWFileManager sharedManager];
  
  [service imageWithURL:[NSURL URLWithString: imageurl] success:^(NSImage * _Nonnull image) {
    NSLog(@"Downloaded %@", imageurl);
    [fileManager saveImage: image name: imgName path: pathName];
  } failure:^(NSError * _Nonnull error) {
    NSLog(@"Failed %@", imageurl);
  }];
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

@end

