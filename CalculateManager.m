/*
   Project: Calculate

   Copyright (C) 2018 Free Software Foundation

   Author: anthony cohn-richardby

   Created: 2018-08-27 10:56:15 +0100 by anthony cohn-richardby

   This application is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This application is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
*/

#include <AppKit/AppKit.h>
#include "CalculateManager.h"
#include "Calculator.h"
#include "math.h"

@implementation CalculateManager

- (id) init
{
  self = [super init];
  if (self == nil)
  {
    return self;
  }
  calc = [[Calculator alloc] init];
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  [style autorelease];
  [style setAlignment: NSRightTextAlignment];
  stringAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: 
    [NSFont systemFontOfSize: 40], NSFontAttributeName, 
    style, NSParagraphStyleAttributeName, nil];
  numberFormatter = [[NSNumberFormatter alloc] init];
  [numberFormatter setMaximumFractionDigits: 2];
  [numberFormatter setMinimumIntegerDigits: 1];
  return self;
}

- (void) deinit
{

  [calc release];
  [stringAttributes release];
  [numberFormatter release];
}

- (void) awakeFromNib
{
  [displayField setDelegate: self];
  NSLog(@"window: %@", window);
}

- (void) didPressButton: (id)sender
{
  if ([sender isKindOfClass: NSButton.class] == NO)
  {
    return;
  }
  CalculatorButton button = [sender tag];
  [calc activateButton: button];
  [self updateDisplayField];
}

-(void)windowWillClose: (NSNotification*)aNotification
{
  [NSApp terminate: self];
}


- (BOOL) control: (NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
{
  NSLog(@"TextShouldBeginEditing...");
  NSLog(@"%@", [control stringValue]);
  return true;
}

- (BOOL) control: (NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
  NSLog(@"Should end editing");
  [calc activateButton: CalculatorButtonEqual];
  [self updateDisplayField];
  return false;
}

- (BOOL) control: (NSControl *)control isValidObject: (id)object
{
  NSLog(@"isValid? %@", object);
  return false;
}


- (void) controlTextDidChange: (NSNotification *)notification
{
  NSString *val = [displayField stringValue];
  char c = [val characterAtIndex: [val length] - 1];
  char numVal = c - NUM_START_POINT;
  NSLog(@"Control txt changed!! char: %c", numVal);
  if (numVal >= 0 && numVal <= 9) 
  {
    NSLog(@"Activating as number.");
    [calc activateButton: (CalculatorButton)numVal];
  }
  else
  {
    switch (c) {
      case '+':
        [calc activateButton: CalculatorButtonPlus];
        break;
      case '-':
        [calc activateButton: CalculatorButtonMinus];
        break;
      case '/':
        [calc activateButton: CalculatorButtonDivide];
        break;
      case '*':
        [calc activateButton: CalculatorButtonTimes];
        break;
      case '.':
        [calc activateButton: CalculatorButtonPoint];
    }
  }
  [displayField setStringValue: [val substringToIndex: [val length] - 1]];
  [self updateDisplayField];
}

- (NSDictionary*) stringAttributesForFont: (NSFont*)font ofSize: (int)fontSize
{
  NSDictionary *ret;
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  [style autorelease];
  [style setAlignment: NSRightTextAlignment];
  ret = [[NSDictionary alloc] initWithObjectsAndKeys: style, NSParagraphStyleAttributeName,
    [NSFont fontWithName: [font fontName] size: fontSize], NSFontAttributeName, nil];
  [ret autorelease];
  return ret;
}

- (int) largestFontSizeWithinBounds: (NSSize)bounds forString: (NSString *)string font: (NSFont*) font
{
  int maxFontSize, minFontSize, lastFontSize, currentFontSize, targetDelta;
  NSSize size;
  maxFontSize = MAX_FONT_SIZE;
  minFontSize = MIN_FONT_SIZE;
  targetDelta = 1;
  lastFontSize = minFontSize;
  currentFontSize = minFontSize + (maxFontSize - minFontSize) / 2;
  while (abs(currentFontSize - lastFontSize) > targetDelta)
  {
    lastFontSize = currentFontSize;
    size = [string sizeWithAttributes: [self stringAttributesForFont: font ofSize: currentFontSize]];
    if (size.width < (bounds.width - DISPLAY_WIDTH_OFFSET) && size.height < bounds.height)
    {
      minFontSize = currentFontSize;
      currentFontSize = currentFontSize + (maxFontSize - currentFontSize) / 2; 
    }
    else
    {
      maxFontSize = currentFontSize;
      currentFontSize = minFontSize + (currentFontSize - minFontSize) / 2;
    }
  }
  return currentFontSize;
}

- (void) updateDisplayField
{
  NSFont *font = [NSFont systemFontOfSize: 50];
  NSString *string = [numberFormatter stringFromNumber: [calc getDisplay]];
  int fontSize = [self largestFontSizeWithinBounds: [displayField bounds].size forString: string font: font];
  font = [NSFont fontWithName: @"Courier" size: fontSize];
  NSLog(@"Calculated font size: %d. Using font: %@", fontSize, font);
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  [style autorelease];
  [style setAlignment: NSRightTextAlignment];
  stringAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: 
    style, NSParagraphStyleAttributeName, nil];
  NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: string
    attributes: stringAttributes];
  [displayField setAttributedStringValue: attributedString];
  [displayField setFont: font];
  [displayField becomeFirstResponder];
  [displayField selectText: nil];
}

@end
