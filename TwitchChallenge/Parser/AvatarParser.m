//
//  AvatarParser.m
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/23/20.
//

#import "AvatarParser.h"

@interface AvatarParser()
@property (nonatomic, strong) NSMutableArray *gameMutableObjects;
@end

@implementation AvatarParser

@synthesize gameMutableObjects = _gameMutableObjects;

- (instancetype)initWithJSONData:(NSArray*) array {
  self = [super init];
  if (self) {
    [self parseJSON: array];
  }
  return self;
}

- (void)parseJSON: (NSArray*) arrayObjects {
  _gameMutableObjects = [[NSMutableArray alloc] init];
  for (int i = 0; i < [arrayObjects count]; i++)  {
    NSString *name = [[arrayObjects objectAtIndex: i] objectForKey:@"name"];
    NSString *root = [[arrayObjects objectAtIndex: i] objectForKey:@"root"];
    NSInteger gameId = [[[arrayObjects objectAtIndex: i] objectForKey: @"gameId"] integerValue];
    NSArray *avatarsArray = [[arrayObjects objectAtIndex: i] objectForKey:@"avatars"];
    GameModel *model = [[GameModel alloc] initWithGameData:name andRoot: root andGameId: gameId andAvatars: avatarsArray];
    [_gameMutableObjects addObject: model];
  }
}

-(NSArray*) gameModelData {
  return _gameMutableObjects;
}

@end