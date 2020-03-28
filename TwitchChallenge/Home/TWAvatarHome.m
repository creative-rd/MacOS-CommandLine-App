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
#import "TWConsoleIO.h"

// Priavte property to hold the game object
@interface TWAvatarHome()
@property (nonatomic, strong) NSArray *gameModelObjects;
@property (nonatomic, strong) NSMutableArray *previousElements;
@property (nonatomic, strong) NSMutableDictionary *shuffledAvatarsDictionary;
@property (nonatomic, strong) NSMutableDictionary *previousAvatarsDictionary;
@property (nonatomic, strong) NSString* currentGame;
@property (nonatomic, strong) NSString* currentInputPath;
@property (nonatomic, strong) TWFileManager* fileManager;
@end

@implementation TWAvatarHome

@synthesize gameModelObjects = _gameModelObjects;
@synthesize gameMapperDictionary = _gameMapperDictionary;
@synthesize shuffledAvatarsDictionary = _shuffledAvatarsDictionary;
@synthesize previousAvatarsDictionary = _previousAvatarsDictionary;
@synthesize currentGame = _currentGame;
@synthesize currentInputPath = _currentInputPath;
@synthesize previousElements = _previousElements;
@synthesize fileManager = _fileManager;

int AVATAR_LIMIT = 5;

-(instancetype)initWithPath:(NSString *) pathName {
  self = [super init];
  if (self) {
    _currentInputPath = pathName;
    _fileManager = [TWFileManager sharedManager];
  }
  return self;
}

// Getter to return the Game Model Object
- (void) listGamesAndAvatars {
  if (_gameModelObjects.count > 0) {
    _gameMapperDictionary = [[NSMutableDictionary alloc] initWithCapacity: _gameModelObjects.count];
    int index = 1;
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
  if (_currentGame == nil) {
    _currentGame = [NSString stringWithString: game];
  }
  NSNumber* gameId = [_gameMapperDictionary objectForKey: [NSNumber numberWithInt: (int)[game integerValue]]];
  if (gameId) {
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"gameId == %d", gameId.intValue];
    NSArray *filteredArray = [_gameModelObjects filteredArrayUsingPredicate: bPredicate];
    if ([filteredArray count] > 0 ) {
      _shuffledAvatarsDictionary = [[NSMutableDictionary alloc] initWithCapacity: AVATAR_LIMIT];
      TWGameModel *model = [filteredArray objectAtIndex: 0];
      NSArray *avatarData = [model parseAvatarData];
      NSArray *randomAvatars = [Utilities generate: AVATAR_LIMIT randomUniqueNumbersBetween:0 upperLimit: (int)[avatarData count] previousArrayObjects: _previousElements];
      if([_previousElements isEqualToArray:randomAvatars]) {
        NSLog(@"Could not find unique avatars == EXIT the game");
        [self exitGame];
        return;
      } else {
        _previousElements = [[NSMutableArray alloc] initWithArray: randomAvatars];
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
}

-(void) loadAvatars {
  [self downloadAvatarsToDirectory:_shuffledAvatarsDictionary];
}

- (void)downloadAvatarsToDirectory: (NSDictionary*) gameObject  {
  NSString *path = _currentInputPath;
  dispatch_group_t group = dispatch_group_create();

  dispatch_group_enter(group);
  NSLog(@"*****************Deletion Started********************");
  [_fileManager deleteContentOfDirectory: path completion:^{
    NSLog(@"*****************Deletion Completed********************");
    dispatch_group_leave(group);
  }];
  
  dispatch_group_enter(group);
  if ([gameObject count] > 0) {
    for (int index = 1; index <= gameObject.count; index++) {
      TWAvatarModel *avatarModel = [gameObject objectForKey: [NSNumber numberWithInt: index]];
      NSString *url = [Utilities fullPath: avatarModel.url];
      [self downloadAvatars: url imageName:avatarModel.name];
    }
    dispatch_group_leave(group);
  }
}

- (void)processSelectedAvatar: (NSString*) selectedAvatar {
  if ([_shuffledAvatarsDictionary count] > 0) {
    if ([selectedAvatar isEqualToString:@">"]) {
      NSLog(@"Selected avatar > %@", _currentGame);
      _previousAvatarsDictionary = [[NSMutableDictionary alloc] initWithDictionary: _shuffledAvatarsDictionary];
      [self loadRandomAvatars: _currentGame];
      [self downloadAvatarsToDirectory: _shuffledAvatarsDictionary];
    } else if ([selectedAvatar isEqualToString:@"<"]) {
      if ([_previousAvatarsDictionary count] > 0) {
        [self loadRandomAvatars: _currentGame];
        [self downloadAvatarsToDirectory: _previousAvatarsDictionary];
      } else {
        NSLog(@"ah !! There are no previous avatars");
      }
    } else {
      [self deleteAllAvatarsExceptSelectedAvatar: selectedAvatar];
    }
  }
}

-(void) downloadAvatars:(NSString *) imageurl imageName: (NSString*)imgName {
  NSString *pathName = _currentInputPath;
  ImageDownloaderService *service = [[ImageDownloaderService alloc] init];
  [service imageWithURL:[NSURL URLWithString: imageurl] success:^(NSImage * _Nonnull image) {
    if (image){
      NSLog(@"Downloaded %@", imgName);
      [self->_fileManager saveImage: image name: imgName path: pathName];
    }
  } failure:^(NSError * _Nonnull error) {
    NSLog(@"Failed** %@", imgName);
  }];
}

- (void)loadGameAndAvatars {
  NSArray *jsonFileData = [_fileManager JSONFromFile];
  if ([jsonFileData count] > 0) {
    TWAvatarParser *parser = [[TWAvatarParser alloc] initWithJSONData: jsonFileData];
    _gameModelObjects = [parser gameModelData];
  }
}

-(void) deleteAllAvatarsExceptSelectedAvatar:(NSString*) selectedAvatar {
  if ([[_shuffledAvatarsDictionary allKeys] containsObject:[NSNumber numberWithInt: (int)[selectedAvatar integerValue]]]) {
    if ([_shuffledAvatarsDictionary count] > 0) {
      TWAvatarModel *avatarModel = [_shuffledAvatarsDictionary objectForKey: [NSNumber numberWithInt: (int)[selectedAvatar integerValue]]];
      TWFileManager *fileManager = [TWFileManager sharedManager];
      [fileManager deleteFiles: _currentInputPath except:avatarModel.name completion:^{
        NSLog(@"All avatars deleted except %@ = EXITING NOW ", avatarModel.name);
        [self exitGame];
      }];
    }
  } else {
    [self exitGame];
  }
}

-(void) exitGame {
  exit(1);
}

@end

