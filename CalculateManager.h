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
#include "Calculator.h"

#define NUM_START_POINT 48

@interface CalculateManager : NSObject <NSTextFieldDelegate>
{
  id displayField;
  Calculator* calc;
  NSDictionary *stringAttributes;
  NSNumberFormatter *numberFormatter;
}
- (id) init;
- (void) deinit;
- (void) awakeFromNib;
- (void) didPressButton: (id)sender;
- (void) updateDisplayField;
@end
