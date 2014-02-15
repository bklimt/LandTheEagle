//
//  Constants.h
//  LandTheEagle
//
//  Created by Bryan Klimt on 2/12/14.
//  Copyright (c) 2014 Bryan Klimt. All rights reserved.
//

#ifndef LandTheEagle_Constants_h
#define LandTheEagle_Constants_h

// Node categories.
static const uint32_t kCategoryShip = 0x1 << 0;
static const uint32_t kCategoryLandSloped = 0x1 << 1;
static const uint32_t kCategoryLandFlat = 0x1 << 2;

// Land metrics.
static const int kLandTileWidth = 48;
static const int kLandYMin = 10;
static const int kLandMaxHeight = 5;
static const int kLandTotalTiles = 11;

// Number of levels.
static const int kLevels = 3;

#endif
