//
//  TWFileManager.m
//  TwitchChallenge
//
//  Created by DUBEY, RAHUL on 3/24/20.
//

#import "TWFileManager.h"
#import <AppKit/AppKit.h>

@implementation TWFileManager

+ (id)sharedManager {
  static TWFileManager *fileManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    fileManager = [[self alloc] init];
  });
  return fileManager;
}

- (BOOL)isValid: (NSString*) pathName {
  if (pathName != nil) {
    // Instantiate FileManager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //Check if the file exists at the given path
    if ([fileManager fileExistsAtPath: pathName] == YES) {
      // Check if the given path from the user is 1. Readable 2. Writable and 3. Executable
      if ([fileManager isWritableFileAtPath: pathName] && [fileManager isReadableFileAtPath: pathName] && [fileManager isExecutableFileAtPath: pathName]) {
        return true;
      }
    }
  }
  return false;
}

- (void)saveImage:(NSImage*)image name:(NSString *)imageName path:(NSString*)pathName {
  @autoreleasepool {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: pathName]) {
      if(![fileManager createDirectoryAtPath: pathName withIntermediateDirectories:YES attributes:nil error:NULL]) {
        //Error Handling
      }
    } else {
      NSData *imageData = [image TIFFRepresentation];
      NSString *fullPathName = [pathName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]];
      [fileManager createFileAtPath: fullPathName contents: imageData attributes: nil];
    }
  }
}

- (void)deleteContentOfDirectory:(NSString*) path completion:(void (^)(void))completionBlock  {
  @autoreleasepool {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:path];
    NSString *file;
    if ([enumerator nextObject] == nil) {
      NSLog(@"******** %@ is empty ********", path);
    } else {
      NSLog(@"******** Deleting previous avatars at %@ ********", path);
    }
    while (file = [enumerator nextObject]) {
      NSError *error = nil;
      BOOL result = [fileManager removeItemAtPath:[path stringByAppendingPathComponent:file] error:&error];
      if (!result && error) {
        NSLog(@"Error: %@", error);
      } else {
        NSLog(@"Deleted File %@", file);
      }
    }
    NSLog(@"************************************************");
    completionBlock();
  }
}

@end

