//
//  GBComment.h
//  appledoc
//
//  Created by Tomaz Kragelj on 27.8.10.
//  Copyright (C) 2010, Gentle Bytes. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GBStoreProviding;
@class GBCommentParagraph;
@class GBCommentArgument;

/** Handles all comment related stuff.
 
 Each instance describes a single source code comment for any object - class, category, protocol, method... As the comment is universal for each object, it contains properties for all fields applying to any kind of object. However not all are used in all cases. If a property is not used, it's value remains `nil`. Derived values are:
 
 - `paragraphs`: An array of `GBCommentParagraph` objects. The first entry is considered a short description, also available through `shortDescription`.
 - `parameters`: An array of `GBCommentParameter` objects. Only applicable for methods with parameters.
 - `return`: A single `GBCommentParameter` object. Only applicable for methods with return value.
 - `exceptions`: An array of `GBCommentParameter` objects. Only applicable for methods with exceptions.
 - `seealso`: An array of `GBCommentLink` objects.
 
 All arrays must be provided in the desired order of output - i.e. output formatters don't apply any sorting, they simply emit the values in the given order.
 
 `GBComment` is not context aware by itself, it's simply a container object that holds comment information. It's the rest of the application that's responsible for setting it's values as needed. In most cases it's `GBParser`s who sets comments string value and `GBProcessor`s to parse string value and setup the derived properties based on the comment's context.
 
 @warning *Note:* Although derived values are prepared based on `stringValue`, nothing prevents clients to setup derived values directly, "on the fly" if needed. However splitting the interface allows us to simplify parsing code and allow us to handle derives values when we have complete information available.
 */
@interface GBComment : NSObject {
	@private
	NSMutableArray *_paragraphs;
	NSMutableArray *_parameters;
	NSMutableArray *_exceptions;
}

///---------------------------------------------------------------------------------------
/// @name Initialization & disposal
///---------------------------------------------------------------------------------------

/** Initializes the comment with the given string value.
 
 This is a helper initializer which allows setting string value with a single message.
 
 @param value String value to set.
 @return Returns initialized object or `nil` if initialization fails.
 */
+ (id)commentWithStringValue:(NSString *)value;

///---------------------------------------------------------------------------------------
/// @name Paragraphs handling
///---------------------------------------------------------------------------------------

/** Registers the `GBCommentParagraph` and adds it to the end of `paragraphs` array.
 
 If `paragraphs` is `nil`, a new array is created before adding the given object to it and the given paragraph is assigned as `firstParagraph` (the object is also added to `paragraphs` array!).
 
 @param paragraph Paragraph to register.
 @exception NSException Thrown if the given paragraph is `nil`.
 @see firstParagraph
 @see paragraphs
 */
- (void)registerParagraph:(GBCommentParagraph *)paragraph;

/** The first paragraph from `paragraphs` list or `nil` if no paragraph is registered.
 
 The value is automatically returned from `paragraphs` list, it doesn't have to be manually registered. However if needed, it can still be set manually if needed.
 */
@property (retain) GBCommentParagraph *firstParagraph;

/** `NSArray` containing all paragraphs of the comment.
 
 The paragraphs are in same order as in the source code. First paragraph is used for short description and is also available via `firstParagraph`. Each object is a `GBCommentParagraph` instance and should be registered through `registerParagraph:` method.

 @see firstParagraph
 @see registerParagraph:
 @see parameters
 @see exceptions
 */
@property (readonly) NSArray *paragraphs;

///---------------------------------------------------------------------------------------
/// @name Method arguments handling
///---------------------------------------------------------------------------------------

/** Registers the `GBCommentArgument` that describes a parameter and adds it to the end of `parameters` array.
 
 If `parameters` is `nil`, a new array is created before adding the given object to it.
 
 @param parameter Parameter to register.
 @exception NSException Thrown if the given parameter is `nil`.
 @see parameters
 @see registerException:
 */
- (void)registerParameter:(GBCommentArgument *)parameter;

/** Registers the `GBCommentArgument` that describes an exception the method can raise and adds it to the end of `exceptions` array.
 
 If `exceptions` is `nil`, a new array is created before adding the given object to it.
 
 @param exception Exception to register.
 @exception NSException Thrown if the given exception is `nil`.
 @see exceptions
 @see registerParameter:
 */
- (void)registerException:(GBCommentArgument *)exception;

/** `NSArray` containing all method parameters described within the comment.
 
 Parameters are in the order of declaration within code regardless of the order declared in the comment! Each object is a `GBCommentArgument` instance and should be registered through `registerParameter:` method.
 
 @see registerParameter:
 @see exceptions
 @see paragraphs
 */
@property (readonly) NSArray *parameters;

/** `NSArray` containing all exceptions commented method can raise as described within the comment.
 
 Exceptions are in the order of declaration in the comment. Each object is a `GBCommentArgument` instance and should be registered through `registerException:` method.
 
 @see registerException:
 @see parameters
 @see paragraphs
 */
@property (readonly) NSArray *exceptions;

///---------------------------------------------------------------------------------------
/// @name Input values
///---------------------------------------------------------------------------------------

/** Comment's raw string value as declared in source code. */
@property (copy) NSString *stringValue;

@end
