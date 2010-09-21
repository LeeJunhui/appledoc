//
//  GBCommentKeywordsProvider.h
//  appledoc
//
//  Created by Tomaz Kragelj on 30.8.10.
//  Copyright (C) 2010, Gentle Bytes. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Provides comment keywords and helpers for the rest of the application.
 
 The main responsibility of the class is to determine if a string contains special section definition. In addition, they also return section parameters. This encapsulates keywords and sections handling and simplifies the rest of the application.
 */
@interface GBCommentComponentsProvider : NSObject

///---------------------------------------------------------------------------------------
/// @name Initialization & disposal
///---------------------------------------------------------------------------------------

/** Returns a new autoreleased `GBCommentComponentsProvider` instance.
 */
+ (id)provider;

///---------------------------------------------------------------------------------------
/// @name Lists definitions
///---------------------------------------------------------------------------------------

/** Returns the regex used for matching ordered lists with capture 1 containing lists indent and capture 2 string value. */
@property (readonly) NSString *orderedListRegex;

/** Returns the regex used for testing whether a string matches an ordered lists. */
@property (readonly) NSString *orderedListMatchRegex;

/** Returns the regex used for matching unordered lists with capture 1 containing list indent and capture 2 string value. */
@property (readonly) NSString *unorderedListRegex;

/** Returns the regex used for testing whether a string matches an unordered list. */
@property (readonly) NSString *unorderedListMatchRegex;

///---------------------------------------------------------------------------------------
/// @name Sections definitions
///---------------------------------------------------------------------------------------

/** Returns the regex used for matching warning section with capture 1 containing description. */
@property (readonly) NSString *warningSectionRegex;

/** Returns the regex used for matching bug section with capture 1 containing description. */
@property (readonly) NSString *bugSectionRegex;

/** Returns the regex used for matching example section with capture 1 containing example text. */
@property (readonly) NSString *exampleSectionRegex;

/** Returns the regex used for matching example lines with capture 1 containing example lines texts. */
@property (readonly) NSString *exampleLinesRegex;

///---------------------------------------------------------------------------------------
/// @name Method specific definitions
///---------------------------------------------------------------------------------------

/** Returns the regex used for matching different method parameter descriptions within the paragraph. */
@property (readonly) NSString *argumentsMatchingRegex;

/** Returns the regex used for finding next method parameter description within the paragraph. */
@property (readonly) NSString *nextArgumentRegex;

/** Returns the regex used for matching method parameter description with capture 1 containing parameter name and capture 2 description. */
@property (readonly) NSString *parameterDescriptionRegex;

/** Returns the regex used for matching method return description with capture 1 containing description. */
@property (readonly) NSString *returnDescriptionRegex;

/** Returns the regex used for matching method exception description with capture 1 containing exception name and capture 2 description. */
@property (readonly) NSString *exceptionDescriptionRegex;

/** Returns the regex used for matching cross reference directive with capture 2 containing link. */
@property (readonly) NSString *crossReferenceSectionRegex;

///---------------------------------------------------------------------------------------
/// @name Common definitions
///---------------------------------------------------------------------------------------

/** Returns the regex used for matching (possible) remote member cross references with capture 1 containing object name and capture 2 member name. */
@property (readonly) NSString *remoteMemberCrossReferenceRegex;

/** Returns the regex used for matching (possible) local member cross reference with capture 1 containing member name. */
@property (readonly) NSString *localMemberCrossReferenceRegex;

/** Returns the regex used for matching (possible) object cross reference with capture 1 containing object name. */
@property (readonly) NSString *objectCrossReferenceRegex;

/** Returns the regex used for matching URL cross reference with caption 1 contining the URL itself. */
@property (readonly) NSString *urlCrossReferenceRegex;

@end
