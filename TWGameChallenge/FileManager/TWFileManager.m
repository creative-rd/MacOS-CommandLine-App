//
//  TWFileManager.m
//

#import "TWFileManager.h"
#import <AppKit/AppKit.h>

@interface TWFileManager()
@property (nonatomic, strong) NSString* currentInputPath;
@end

@implementation TWFileManager

@synthesize currentInputPath = _currentInputPath;

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
        _currentInputPath = [NSString stringWithString:pathName];
        return true;
      }
    }
  }
  return false;
}

- (void)clearDirectory {
  if (_currentInputPath != nil) {
    [self deleteContentOfDirectory:_currentInputPath completion:^{
      // Completion Handler !!
    }];
  }
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
    while (file = [enumerator nextObject]) {
      NSError *error = nil;
      BOOL result = [fileManager removeItemAtPath:[path stringByAppendingPathComponent:file] error:&error];
      if (!result && error) {
        NSLog(@"Error: %@", error);
      } else {
        NSLog(@"Deleted %@", file);
      }
    }
    completionBlock();
  }
}

- (void)deleteFiles:(NSString*) path except:(NSString*) exceptionFile completion:(void (^)(void))completionBlock {
  @autoreleasepool {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:path];
    NSString *file;
    while (file = [enumerator nextObject]) {
      NSError *error = nil;
      if ([file containsString: exceptionFile]) {
        NSLog(@"Skipped %@", exceptionFile);
      } else {
        BOOL result = [fileManager removeItemAtPath:[path stringByAppendingPathComponent:file] error:&error];
        if (!result && error) {
          NSLog(@"Error: %@", error);
        } else {
          NSLog(@"Deleted %@", file);
        }
      }
    }
    completionBlock();
  }
}

- (NSArray *)JSONFromFile {
  NSURL *currentDirectoryURL = [NSURL fileURLWithPath:[[NSFileManager defaultManager] currentDirectoryPath]];
  NSURL *bundleURL = [NSURL fileURLWithPath: @"JSON.bundle" relativeToURL: currentDirectoryURL];
  NSBundle *bundle = [NSBundle bundleWithURL: bundleURL];
  NSURL *filePath = [bundle URLForResource:@"avatarGame"
                             withExtension:@"json"];
  // Check for filePath else it can't find the content of the URL
  NSArray* json = [[NSArray alloc] init];
  if (filePath != nil) {
    NSString *myJSON = [[NSString alloc] initWithContentsOfURL: filePath encoding: NSUTF8StringEncoding error: NULL];
    NSError *error =  nil;
    json = [NSJSONSerialization JSONObjectWithData: [myJSON dataUsingEncoding: NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error:&error];
  }
  return json;
}

@end

