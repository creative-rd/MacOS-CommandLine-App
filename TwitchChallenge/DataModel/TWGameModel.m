//
//  GameModel.m
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/23/20.
//

#import "TWGameModel.h"

//Private Property
@interface TWGameModel()
@property (nonatomic, strong) NSMutableArray *avatarsObjects;
@end

@implementation TWGameModel

@synthesize name = _name;
@synthesize root = _root;
@synthesize gameId = _gameId;
@synthesize avatars = _avatars;

- (instancetype) initWithGameData: (NSString *)name andRoot: (NSString *)root andGameId: (NSInteger) gameId andAvatars: (NSArray *)avatars {
  self = [super init];
  if (self) {
    _name = name;
    _root = root;
    _gameId = gameId;
    _avatars = avatars;
  }
  return self;
}

-(NSArray*) parseAvatarData {
  _avatarsObjects = [[NSMutableArray alloc] init];
  //Iterate through all the avatars in one game object
  for (int i = 0; i < [self.avatars count]; i++)  {
    NSString *name = [[self.avatars objectAtIndex: i] objectForKey:@"name"];
    NSString *url = [[self.avatars objectAtIndex: i] objectForKey:@"url"];
    TWAvatarModel *avatarModel = [[TWAvatarModel alloc] initWithAvatarData: name andURL: url];
    [_avatarsObjects addObject: avatarModel];
  }
  return _avatarsObjects;
}

@end
