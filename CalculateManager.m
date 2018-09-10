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
}

- (void) didPressButton: (id)sender
{
  if ([sender isKindOfClass: NSButton.class] == NO)
  {
    return;
  }
  CalculatorButton button = [sender tag];
  [calc activateButton: button];
  NSString *string = [numberFormatter stringFromNumber: [calc getDisplay]];
  NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: string
    attributes: stringAttributes];
  [displayField setAttributedStringValue: attributedString];
}


- (BOOL) control: (NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
{
  NSLog(@"TextShouldBeginEditing...");
  return false;
}

@end
