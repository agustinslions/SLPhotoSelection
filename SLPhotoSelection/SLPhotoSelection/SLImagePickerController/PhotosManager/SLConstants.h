//
//  SLConstants.h
//  SLPhotoSelection
//
//  Created by Agustin De Leon on 19/5/18.
//  Copyright © 2018 Agustin De Leon. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SLwself __weak typeof (self) wself = self

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

#define BLOCK_EXEC_MAIN_THREAD(block, ...) dispatch_async(dispatch_get_main_queue(), ^{ BLOCK_EXEC(block, __VA_ARGS__); } );

extern NSString * const kSLCreationDateKey;
extern NSString * const kNSPhotoLibraryUsageDescriptionKey;
