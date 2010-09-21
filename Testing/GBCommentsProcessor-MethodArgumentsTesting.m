//
//  GBCommentsProcessor-LinkItemsTesting.m
//  appledoc
//
//  Created by Tomaz Kragelj on 19.9.10.
//  Copyright (C) 2010 Gentle Bytes. All rights reserved.
//

#import "GBComment.h"
#import "GBCommentsProcessor.h"

@interface GBCommentsProcessorMethodItemsTesting : GBObjectsAssertor
@end

#pragma mark -

@implementation GBCommentsProcessorMethodItemsTesting

#pragma mark Parameters processing

- (void)testProcesCommentWithStore_parameters_requiresEmptyLineBeforePreceedingParagraph {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"Prefix\n\n@param name Description"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(1));
	[self assertParagraph:[comment.paragraphs objectAtIndex:0] containsTexts:@"Prefix", nil];
	assertThatInteger([comment.parameters count], equalToInteger(1));
	[self assertArgument:[comment.parameters objectAtIndex:0] hasName:@"name" descriptions:@"Description", nil];
}

- (void)testProcesCommentWithStore_parameters_shouldRegisterCommentParagraphIfEmptyLineNotInserted {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"Prefix\n@param name Description"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(1));
	[self assertParagraph:[comment.paragraphs objectAtIndex:0] containsTexts:@"Prefix @param name Description", nil];
	assertThatInteger([comment.parameters count], equalToInteger(0));
}

- (void)testProcesCommentWithStore_parameters_shouldRegisterParameterIfNothingElseIsFoundInComment {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"@param name Description"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(0));
	assertThatInteger([comment.parameters count], equalToInteger(1));
	[self assertArgument:[comment.parameters objectAtIndex:0] hasName:@"name" descriptions:@"Description", nil];
}

- (void)testProcesCommentWithStore_parameters_shouldUseAllRemainingTextAsParameterDescription {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"@param name Description\nFollowing"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(0));
	assertThatInteger([comment.parameters count], equalToInteger(1));
	[self assertArgument:[comment.parameters objectAtIndex:0] hasName:@"name" descriptions:@"Description Following", nil];
}

- (void)testProcesCommentWithStore_parameters_shouldDetectNormalParagraphIfDelimitedWithEmptyLine {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"@param name Description\n\nFollowing"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(1));
	[self assertParagraph:[comment.paragraphs objectAtIndex:0] containsTexts:@"Following", nil];
	assertThatInteger([comment.parameters count], equalToInteger(1));
	[self assertArgument:[comment.parameters objectAtIndex:0] hasName:@"name" descriptions:@"Description", nil];
}

- (void)testProcesCommentWithStore_parameters_shouldDetectDescriptionParagraphItems {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"@param name Description\n\n- Item\n\n\tExample"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(0));
	assertThatInteger([comment.parameters count], equalToInteger(1));
	[self assertArgument:[comment.parameters objectAtIndex:0] hasName:@"name" descriptions:@"Description", @"- Item", @"Example", nil];
}

- (void)testProcesCommentWithStore_parameters_shouldDetectAllParameters {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"@param name1 Description1\n@param name2 Description2"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(0));
	assertThatInteger([comment.parameters count], equalToInteger(2));
	[self assertArgument:[comment.parameters objectAtIndex:0] hasName:@"name1" descriptions:@"Description1", nil];
	[self assertArgument:[comment.parameters objectAtIndex:1] hasName:@"name2" descriptions:@"Description2", nil];
}

- (void)testProcesCommentWithStore_parameters_shouldDetectParametersEvenIfDelimitedWithEmptyLines {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"@param name1 Description1\n\n@param name2 Description2"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(0));
	assertThatInteger([comment.parameters count], equalToInteger(2));
	[self assertArgument:[comment.parameters objectAtIndex:0] hasName:@"name1" descriptions:@"Description1", nil];
	[self assertArgument:[comment.parameters objectAtIndex:1] hasName:@"name2" descriptions:@"Description2", nil];
}

#pragma mark Exception processing

- (void)testProcesCommentWithStore_exceptions_requiresEmptyLineBeforePreceedingParagraph {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"Prefix\n\n@exception name Description"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(1));
	[self assertParagraph:[comment.paragraphs objectAtIndex:0] containsTexts:@"Prefix", nil];
	assertThatInteger([comment.exceptions count], equalToInteger(1));
	[self assertArgument:[comment.exceptions objectAtIndex:0] hasName:@"name" descriptions:@"Description", nil];
}

- (void)testProcesCommentWithStore_exceptions_shouldRegisterCommentParagraphIfEmptyLineNotInserted {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"Prefix\n@exception name Description"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(1));
	[self assertParagraph:[comment.paragraphs objectAtIndex:0] containsTexts:@"Prefix @exception name Description", nil];
	assertThatInteger([comment.exceptions count], equalToInteger(0));
}

- (void)testProcesCommentWithStore_exceptions_shouldRegisterExceptionIfNothingElseIsFoundInComment {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"@exception name Description"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(0));
	assertThatInteger([comment.exceptions count], equalToInteger(1));
	[self assertArgument:[comment.exceptions objectAtIndex:0] hasName:@"name" descriptions:@"Description", nil];
}

- (void)testProcesCommentWithStore_exceptions_shouldUseAllRemainingTextAsExceptionDescription {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"@exception name Description\nFollowing"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(0));
	assertThatInteger([comment.exceptions count], equalToInteger(1));
	[self assertArgument:[comment.exceptions objectAtIndex:0] hasName:@"name" descriptions:@"Description Following", nil];
}

- (void)testProcesCommentWithStore_exceptions_shouldDetectNormalParagraphIfDelimitedWithEmptyLine {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"@exception name Description\n\nFollowing"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(1));
	[self assertParagraph:[comment.paragraphs objectAtIndex:0] containsTexts:@"Following", nil];
	assertThatInteger([comment.exceptions count], equalToInteger(1));
	[self assertArgument:[comment.exceptions objectAtIndex:0] hasName:@"name" descriptions:@"Description", nil];
}

- (void)testProcesCommentWithStore_exceptions_shouldDetectDescriptionParagraphItems {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"@exception name Description\n\n- Item\n\n\tExample"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(0));
	assertThatInteger([comment.exceptions count], equalToInteger(1));
	[self assertArgument:[comment.exceptions objectAtIndex:0] hasName:@"name" descriptions:@"Description", @"- Item", @"Example", nil];
}

- (void)testProcesCommentWithStore_exceptions_shouldDetectAllExceptions {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"@exception name1 Description1\n@exception name2 Description2"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(0));
	assertThatInteger([comment.exceptions count], equalToInteger(2));
	[self assertArgument:[comment.exceptions objectAtIndex:0] hasName:@"name1" descriptions:@"Description1", nil];
	[self assertArgument:[comment.exceptions objectAtIndex:1] hasName:@"name2" descriptions:@"Description2", nil];
}

- (void)testProcesCommentWithStore_exceptions_shouldDetectExceptionsEvenIfDelimitedWithEmptyLines {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"@exception name1 Description1\n\n@exception name2 Description2"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(0));
	assertThatInteger([comment.exceptions count], equalToInteger(2));
	[self assertArgument:[comment.exceptions objectAtIndex:0] hasName:@"name1" descriptions:@"Description1", nil];
	[self assertArgument:[comment.exceptions objectAtIndex:1] hasName:@"name2" descriptions:@"Description2", nil];
}

#pragma mark Return values testing

- (void)testProcesCommentWithStore_return_requiresEmptyLineBeforePreceedingParagraph {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"Prefix\n\n@return Description"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(1));
	[self assertParagraph:[comment.paragraphs objectAtIndex:0] containsTexts:@"Prefix", nil];
	[self assertParagraph:comment.result containsTexts:@"Description", nil];
}

- (void)testProcesCommentWithStore_return_shouldRegisterNormalParameterIfEmptyLineNotInserted {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"Prefix\n@return Description"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(1));
	[self assertParagraph:[comment.paragraphs objectAtIndex:0] containsTexts:@"Prefix @return Description", nil];
	assertThat(comment.result, is(nil));
}

- (void)testProcesCommentWithStore_return_shouldRegisterResultIfNothingElseIsFoundInComment {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"@return Description"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(0));
	assertThatInteger([comment.result count], equalToInteger(1));
	[self assertArgument:[comment.result objectAtIndex:0] hasName:@"name" descriptions:@"Description", nil];
}

- (void)testProcesCommentWithStore_return_shouldUseAllRemainingTextAsResultDescription {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"@return Description\nFollowing"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(0));
	assertThatInteger([comment.result count], equalToInteger(1));
	[self assertArgument:[comment.result objectAtIndex:0] hasName:@"name" descriptions:@"Description Following", nil];
}

- (void)testProcesCommentWithStore_return_shouldDetectNormalParagraphIfDelimitedWithEmptyLine {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"@return Description\n\nFollowing"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(1));
	[self assertParagraph:[comment.paragraphs objectAtIndex:0] containsTexts:@"Following", nil];
	assertThatInteger([comment.result count], equalToInteger(1));
	[self assertArgument:[comment.result objectAtIndex:0] hasName:@"name" descriptions:@"Description", nil];
}

- (void)testProcesCommentWithStore_return_shouldDetectDescriptionParagraphItems {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"@return Description\n\n- Item\n\n\tExample"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(0));
	assertThatInteger([comment.result count], equalToInteger(1));
	[self assertArgument:[comment.result objectAtIndex:0] hasName:@"name" descriptions:@"Description", @"- Item", @"Example", nil];
}

- (void)testProcesCommentWithStore_return_shouldUseLastResultIfMultipleDetected {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"@return Description1\n@return Description2"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method and have multiple return!
	assertThatInteger([comment.paragraphs count], equalToInteger(0));
	assertThatInteger([comment.result count], equalToInteger(2));
	[self assertArgument:[comment.result objectAtIndex:0] hasName:@"name1" descriptions:@"Description1", nil];
	[self assertArgument:[comment.result objectAtIndex:1] hasName:@"name2" descriptions:@"Description2", nil];
}

- (void)testProcesCommentWithStore_return_shouldDetectParametersEvenIfDelimitedWithEmptyLines {
	// setup
	GBCommentsProcessor *processor = [GBCommentsProcessor processorWithSettingsProvider:[GBTestObjectsRegistry mockSettingsProvider]];
	GBComment *comment = [GBComment commentWithStringValue:@"@return1 Description1\n\n@return2 Description2"];
	// execute
	[processor processComment:comment withStore:[GBTestObjectsRegistry store]];
	// verify - note that we would get a warning normally as current context doesn't point to a method!
	assertThatInteger([comment.paragraphs count], equalToInteger(0));
	assertThatInteger([comment.result count], equalToInteger(2));
	[self assertArgument:[comment.result objectAtIndex:0] hasName:@"name1" descriptions:@"Description1", nil];
	[self assertArgument:[comment.result objectAtIndex:1] hasName:@"name2" descriptions:@"Description2", nil];
}

@end
