/*
 * MACDRV Cocoa window declarations
 *
 * Copyright 2011, 2012, 2013 Ken Thomases for CodeWeavers Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
 */

#import <AppKit/AppKit.h>


@class WineEventQueue;


@interface WineWindow : NSPanel <NSWindowDelegate>
{
    BOOL disabled;
    BOOL noActivate;
    BOOL floating;
    BOOL fullscreen;
    BOOL pendingMinimize;
    WineWindow* latentParentWindow;
    NSMutableArray* latentChildWindows;

    void* hwnd;
    WineEventQueue* queue;

    void* surface;
    pthread_mutex_t* surface_mutex;

    NSBezierPath* shape;
    BOOL shapeChangedSinceLastDraw;

    BOOL colorKeyed;
    CGFloat colorKeyRed, colorKeyGreen, colorKeyBlue;

    BOOL usePerPixelAlpha;

    NSUInteger lastModifierFlags;

    NSTimer* liveResizeDisplayTimer;

    void* imeData;
    BOOL commandDone;

    NSSize savedContentMinSize;
    NSSize savedContentMaxSize;

    BOOL enteringFullScreen;
    BOOL exitingFullScreen;
    NSRect nonFullscreenFrame;
    NSTimeInterval enteredFullScreenTime;

    BOOL ignore_windowDeminiaturize;
}

@property (retain, readonly, nonatomic) WineEventQueue* queue;
@property (readonly, nonatomic) BOOL disabled;
@property (readonly, nonatomic) BOOL noActivate;
@property (readonly, nonatomic) BOOL floating;
@property (readonly, getter=isFullscreen, nonatomic) BOOL fullscreen;

    - (NSInteger) minimumLevelForActive:(BOOL)active;
    - (void) updateFullscreen;

    - (void) postKeyEvent:(NSEvent *)theEvent;
    - (void) postBroughtForwardEvent;

    - (WineWindow*) ancestorWineWindow;

@end
