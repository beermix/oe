/*
 * MACDRV keyboard driver
 *
 * Copyright 1993 Bob Amstadt
 * Copyright 1996 Albrecht Kleine
 * Copyright 1997 David Faure
 * Copyright 1998 Morten Welinder
 * Copyright 1998 Ulrich Weigand
 * Copyright 1999 Ove Kåven
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

#include "config.h"

#include "macdrv.h"
#include "winuser.h"
#include "wine/unicode.h"

WINE_DEFAULT_DEBUG_CHANNEL(keyboard);
WINE_DECLARE_DEBUG_CHANNEL(key);


/* Carbon-style modifier mask definitions from <Carbon/HIToolbox/Events.h>. */
enum {
    cmdKeyBit       = 8,
    shiftKeyBit     = 9,
    alphaLockBit    = 10,
    optionKeyBit    = 11,
    controlKeyBit   = 12,
};

enum {
    cmdKey      = 1 << cmdKeyBit,
    shiftKey    = 1 << shiftKeyBit,
    alphaLock   = 1 << alphaLockBit,
    optionKey   = 1 << optionKeyBit,
    controlKey  = 1 << controlKeyBit,
};


/* Mac virtual key code definitions from <Carbon/HIToolbox/Events.h>. */
enum {
    kVK_ANSI_A              = 0x00,
    kVK_ANSI_S              = 0x01,
    kVK_ANSI_D              = 0x02,
    kVK_ANSI_F              = 0x03,
    kVK_ANSI_H              = 0x04,
    kVK_ANSI_G              = 0x05,
    kVK_ANSI_Z              = 0x06,
    kVK_ANSI_X              = 0x07,
    kVK_ANSI_C              = 0x08,
    kVK_ANSI_V              = 0x09,
    kVK_ISO_Section         = 0x0A,
    kVK_ANSI_B              = 0x0B,
    kVK_ANSI_Q              = 0x0C,
    kVK_ANSI_W              = 0x0D,
    kVK_ANSI_E              = 0x0E,
    kVK_ANSI_R              = 0x0F,
    kVK_ANSI_Y              = 0x10,
    kVK_ANSI_T              = 0x11,
    kVK_ANSI_1              = 0x12,
    kVK_ANSI_2              = 0x13,
    kVK_ANSI_3              = 0x14,
    kVK_ANSI_4              = 0x15,
    kVK_ANSI_6              = 0x16,
    kVK_ANSI_5              = 0x17,
    kVK_ANSI_Equal          = 0x18,
    kVK_ANSI_9              = 0x19,
    kVK_ANSI_7              = 0x1A,
    kVK_ANSI_Minus          = 0x1B,
    kVK_ANSI_8              = 0x1C,
    kVK_ANSI_0              = 0x1D,
    kVK_ANSI_RightBracket   = 0x1E,
    kVK_ANSI_O              = 0x1F,
    kVK_ANSI_U              = 0x20,
    kVK_ANSI_LeftBracket    = 0x21,
    kVK_ANSI_I              = 0x22,
    kVK_ANSI_P              = 0x23,
    kVK_Return              = 0x24,
    kVK_ANSI_L              = 0x25,
    kVK_ANSI_J              = 0x26,
    kVK_ANSI_Quote          = 0x27,
    kVK_ANSI_K              = 0x28,
    kVK_ANSI_Semicolon      = 0x29,
    kVK_ANSI_Backslash      = 0x2A,
    kVK_ANSI_Comma          = 0x2B,
    kVK_ANSI_Slash          = 0x2C,
    kVK_ANSI_N              = 0x2D,
    kVK_ANSI_M              = 0x2E,
    kVK_ANSI_Period         = 0x2F,
    kVK_Tab                 = 0x30,
    kVK_Space               = 0x31,
    kVK_ANSI_Grave          = 0x32,
    kVK_Delete              = 0x33,
    kVK_Escape              = 0x35,
    kVK_RightCommand        = 0x36, /* invented for Wine; co-opt unused key code */
    kVK_Command             = 0x37,
    kVK_Shift               = 0x38,
    kVK_CapsLock            = 0x39,
    kVK_Option              = 0x3A,
    kVK_Control             = 0x3B,
    kVK_RightShift          = 0x3C,
    kVK_RightOption         = 0x3D,
    kVK_RightControl        = 0x3E,
    kVK_Function            = 0x3F,
    kVK_F17                 = 0x40,
    kVK_ANSI_KeypadDecimal  = 0x41,
    kVK_ANSI_KeypadMultiply = 0x43,
    kVK_ANSI_KeypadPlus     = 0x45,
    kVK_ANSI_KeypadClear    = 0x47,
    kVK_VolumeUp            = 0x48,
    kVK_VolumeDown          = 0x49,
    kVK_Mute                = 0x4A,
    kVK_ANSI_KeypadDivide   = 0x4B,
    kVK_ANSI_KeypadEnter    = 0x4C,
    kVK_ANSI_KeypadMinus    = 0x4E,
    kVK_F18                 = 0x4F,
    kVK_F19                 = 0x50,
    kVK_ANSI_KeypadEquals   = 0x51,
    kVK_ANSI_Keypad0        = 0x52,
    kVK_ANSI_Keypad1        = 0x53,
    kVK_ANSI_Keypad2        = 0x54,
    kVK_ANSI_Keypad3        = 0x55,
    kVK_ANSI_Keypad4        = 0x56,
    kVK_ANSI_Keypad5        = 0x57,
    kVK_ANSI_Keypad6        = 0x58,
    kVK_ANSI_Keypad7        = 0x59,
    kVK_F20                 = 0x5A,
    kVK_ANSI_Keypad8        = 0x5B,
    kVK_ANSI_Keypad9        = 0x5C,
    kVK_JIS_Yen             = 0x5D,
    kVK_JIS_Underscore      = 0x5E,
    kVK_JIS_KeypadComma     = 0x5F,
    kVK_F5                  = 0x60,
    kVK_F6                  = 0x61,
    kVK_F7                  = 0x62,
    kVK_F3                  = 0x63,
    kVK_F8                  = 0x64,
    kVK_F9                  = 0x65,
    kVK_JIS_Eisu            = 0x66,
    kVK_F11                 = 0x67,
    kVK_JIS_Kana            = 0x68,
    kVK_F13                 = 0x69,
    kVK_F16                 = 0x6A,
    kVK_F14                 = 0x6B,
    kVK_F10                 = 0x6D,
    kVK_F12                 = 0x6F,
    kVK_F15                 = 0x71,
    kVK_Help                = 0x72,
    kVK_Home                = 0x73,
    kVK_PageUp              = 0x74,
    kVK_ForwardDelete       = 0x75,
    kVK_F4                  = 0x76,
    kVK_End                 = 0x77,
    kVK_F2                  = 0x78,
    kVK_PageDown            = 0x79,
    kVK_F1                  = 0x7A,
    kVK_LeftArrow           = 0x7B,
    kVK_RightArrow          = 0x7C,
    kVK_DownArrow           = 0x7D,
    kVK_UpArrow             = 0x7E,
};


/* Indexed by Mac virtual keycode values defined above. */
static const struct {
    WORD vkey;
    WORD scan;
    BOOL fixed;
} default_map[128] = {
    { 'A',                      0x1E,           FALSE },    /* kVK_ANSI_A */
    { 'S',                      0x1F,           FALSE },    /* kVK_ANSI_S */
    { 'D',                      0x20,           FALSE },    /* kVK_ANSI_D */
    { 'F',                      0x21,           FALSE },    /* kVK_ANSI_F */
    { 'H',                      0x23,           FALSE },    /* kVK_ANSI_H */
    { 'G',                      0x22,           FALSE },    /* kVK_ANSI_G */
    { 'Z',                      0x2C,           FALSE },    /* kVK_ANSI_Z */
    { 'X',                      0x2D,           FALSE },    /* kVK_ANSI_X */
    { 'C',                      0x2E,           FALSE },    /* kVK_ANSI_C */
    { 'V',                      0x2F,           FALSE },    /* kVK_ANSI_V */
    { VK_OEM_102,               0x56,           TRUE },     /* kVK_ISO_Section */
    { 'B',                      0x30,           FALSE },    /* kVK_ANSI_B */
    { 'Q',                      0x10,           FALSE },    /* kVK_ANSI_Q */
    { 'W',                      0x11,           FALSE },    /* kVK_ANSI_W */
    { 'E',                      0x12,           FALSE },    /* kVK_ANSI_E */
    { 'R',                      0x13,           FALSE },    /* kVK_ANSI_R */
    { 'Y',                      0x15,           FALSE },    /* kVK_ANSI_Y */
    { 'T',                      0x14,           FALSE },    /* kVK_ANSI_T */
    { '1',                      0x02,           FALSE },    /* kVK_ANSI_1 */
    { '2',                      0x03,           FALSE },    /* kVK_ANSI_2 */
    { '3',                      0x04,           FALSE },    /* kVK_ANSI_3 */
    { '4',                      0x05,           FALSE },    /* kVK_ANSI_4 */
    { '6',                      0x07,           FALSE },    /* kVK_ANSI_6 */
    { '5',                      0x06,           FALSE },    /* kVK_ANSI_5 */
    { VK_OEM_PLUS,              0x0D,           FALSE },    /* kVK_ANSI_Equal */
    { '9',                      0x0A,           FALSE },    /* kVK_ANSI_9 */
    { '7',                      0x08,           FALSE },    /* kVK_ANSI_7 */
    { VK_OEM_MINUS,             0x0C,           FALSE },    /* kVK_ANSI_Minus */
    { '8',                      0x09,           FALSE },    /* kVK_ANSI_8 */
    { '0',                      0x0B,           FALSE },    /* kVK_ANSI_0 */
    { VK_OEM_6,                 0x1B,           FALSE },    /* kVK_ANSI_RightBracket */
    { 'O',                      0x18,           FALSE },    /* kVK_ANSI_O */
    { 'U',                      0x16,           FALSE },    /* kVK_ANSI_U */
    { VK_OEM_4,                 0x1A,           FALSE },    /* kVK_ANSI_LeftBracket */
    { 'I',                      0x17,           FALSE },    /* kVK_ANSI_I */
    { 'P',                      0x19,           FALSE },    /* kVK_ANSI_P */
    { VK_RETURN,                0x1C,           TRUE },     /* kVK_Return */
    { 'L',                      0x26,           FALSE },    /* kVK_ANSI_L */
    { 'J',                      0x24,           FALSE },    /* kVK_ANSI_J */
    { VK_OEM_7,                 0x28,           FALSE },    /* kVK_ANSI_Quote */
    { 'K',                      0x25,           FALSE },    /* kVK_ANSI_K */
    { VK_OEM_1,                 0x27,           FALSE },    /* kVK_ANSI_Semicolon */
    { VK_OEM_5,                 0x2B,           FALSE },    /* kVK_ANSI_Backslash */
    { VK_OEM_COMMA,             0x33,           FALSE },    /* kVK_ANSI_Comma */
    { VK_OEM_2,                 0x35,           FALSE },    /* kVK_ANSI_Slash */
    { 'N',                      0x31,           FALSE },    /* kVK_ANSI_N */
    { 'M',                      0x32,           FALSE },    /* kVK_ANSI_M */
    { VK_OEM_PERIOD,            0x34,           FALSE },    /* kVK_ANSI_Period */
    { VK_TAB,                   0x0F,           TRUE },     /* kVK_Tab */
    { VK_SPACE,                 0x39,           TRUE },     /* kVK_Space */
    { VK_OEM_3,                 0x29,           FALSE },    /* kVK_ANSI_Grave */
    { VK_BACK,                  0x0E,           TRUE },     /* kVK_Delete */
    { 0,                        0,              FALSE },    /* 0x34 unused */
    { VK_ESCAPE,                0x01,           TRUE },     /* kVK_Escape */
    { VK_RMENU,                 0x38 | 0x100,   TRUE },     /* kVK_RightCommand */
    { VK_LMENU,                 0x38,           TRUE },     /* kVK_Command */
    { VK_LSHIFT,                0x2A,           TRUE },     /* kVK_Shift */
    { VK_CAPITAL,               0x3A,           TRUE },     /* kVK_CapsLock */
    { 0,                        0,              FALSE },    /* kVK_Option */
    { VK_LCONTROL,              0x1D,           TRUE },     /* kVK_Control */
    { VK_RSHIFT,                0x36,           TRUE },     /* kVK_RightShift */
    { 0,                        0,              FALSE },    /* kVK_RightOption */
    { VK_RCONTROL,              0x1D | 0x100,   TRUE },     /* kVK_RightControl */
    { 0,                        0,              FALSE },    /* kVK_Function */
    { VK_F17,                   0x68,           TRUE },     /* kVK_F17 */
    { VK_DECIMAL,               0x53,           TRUE },     /* kVK_ANSI_KeypadDecimal */
    { 0,                        0,              FALSE },    /* 0x42 unused */
    { VK_MULTIPLY,              0x37,           TRUE },     /* kVK_ANSI_KeypadMultiply */
    { 0,                        0,              FALSE },    /* 0x44 unused */
    { VK_ADD,                   0x4E,           TRUE },     /* kVK_ANSI_KeypadPlus */
    { 0,                        0,              FALSE },    /* 0x46 unused */
    { VK_OEM_CLEAR,             0x59,           TRUE },     /* kVK_ANSI_KeypadClear */
    { VK_VOLUME_UP,             0 | 0x100,      TRUE },     /* kVK_VolumeUp */
    { VK_VOLUME_DOWN,           0 | 0x100,      TRUE },     /* kVK_VolumeDown */
    { VK_VOLUME_MUTE,           0 | 0x100,      TRUE },     /* kVK_Mute */
    { VK_DIVIDE,                0x35 | 0x100,   TRUE },     /* kVK_ANSI_KeypadDivide */
    { VK_RETURN,                0x1C | 0x100,   TRUE },     /* kVK_ANSI_KeypadEnter */
    { 0,                        0,              FALSE },    /* 0x4D unused */
    { VK_SUBTRACT,              0x4A,           TRUE },     /* kVK_ANSI_KeypadMinus */
    { VK_F18,                   0x69,           TRUE },     /* kVK_F18 */
    { VK_F19,                   0x6A,           TRUE },     /* kVK_F19 */
    { VK_OEM_NEC_EQUAL,         0x0D | 0x100,   TRUE },     /* kVK_ANSI_KeypadEquals */
    { VK_NUMPAD0,               0x52,           TRUE },     /* kVK_ANSI_Keypad0 */
    { VK_NUMPAD1,               0x4F,           TRUE },     /* kVK_ANSI_Keypad1 */
    { VK_NUMPAD2,               0x50,           TRUE },     /* kVK_ANSI_Keypad2 */
    { VK_NUMPAD3,               0x51,           TRUE },     /* kVK_ANSI_Keypad3 */
    { VK_NUMPAD4,               0x4B,           TRUE },     /* kVK_ANSI_Keypad4 */
    { VK_NUMPAD5,               0x4C,           TRUE },     /* kVK_ANSI_Keypad5 */
    { VK_NUMPAD6,               0x4D,           TRUE },     /* kVK_ANSI_Keypad6 */
    { VK_NUMPAD7,               0x47,           TRUE },     /* kVK_ANSI_Keypad7 */
    { VK_F20,                   0x6B,           TRUE },     /* kVK_F20 */
    { VK_NUMPAD8,               0x48,           TRUE },     /* kVK_ANSI_Keypad8 */
    { VK_NUMPAD9,               0x49,           TRUE },     /* kVK_ANSI_Keypad9 */
    { 0xFF,                     0x7D,           TRUE },     /* kVK_JIS_Yen */
    { 0xC1,                     0x73,           TRUE },     /* kVK_JIS_Underscore */
    { VK_SEPARATOR,             0x7E,           TRUE },     /* kVK_JIS_KeypadComma */
    { VK_F5,                    0x3F,           TRUE },     /* kVK_F5 */
    { VK_F6,                    0x40,           TRUE },     /* kVK_F6 */
    { VK_F7,                    0x41,           TRUE },     /* kVK_F7 */
    { VK_F3,                    0x3D,           TRUE },     /* kVK_F3 */
    { VK_F8,                    0x42,           TRUE },     /* kVK_F8 */
    { VK_F9,                    0x43,           TRUE },     /* kVK_F9 */
    { 0xFF,                     0x72,           TRUE },     /* kVK_JIS_Eisu */
    { VK_F11,                   0x57,           TRUE },     /* kVK_F11 */
    { VK_OEM_RESET,             0x71,           TRUE },     /* kVK_JIS_Kana */
    { VK_F13,                   0x64,           TRUE },     /* kVK_F13 */
    { VK_F16,                   0x67,           TRUE },     /* kVK_F16 */
    { VK_F14,                   0x65,           TRUE },     /* kVK_F14 */
    { 0,                        0,              FALSE },    /* 0x6C unused */
    { VK_F10,                   0x44,           TRUE },     /* kVK_F10 */
    { 0,                        0,              FALSE },    /* 0x6E unused */
    { VK_F12,                   0x58,           TRUE },     /* kVK_F12 */
    { 0,                        0,              FALSE },    /* 0x70 unused */
    { VK_F15,                   0x66,           TRUE },     /* kVK_F15 */
    { VK_INSERT,                0x52 | 0x100,   TRUE },     /* kVK_Help */ /* map to Insert */
    { VK_HOME,                  0x47 | 0x100,   TRUE },     /* kVK_Home */
    { VK_PRIOR,                 0x49 | 0x100,   TRUE },     /* kVK_PageUp */
    { VK_DELETE,                0x53 | 0x100,   TRUE },     /* kVK_ForwardDelete */
    { VK_F4,                    0x3E,           TRUE },     /* kVK_F4 */
    { VK_END,                   0x4F | 0x100,   TRUE },     /* kVK_End */
    { VK_F2,                    0x3C,           TRUE },     /* kVK_F2 */
    { VK_NEXT,                  0x51 | 0x100,   TRUE },     /* kVK_PageDown */
    { VK_F1,                    0x3B,           TRUE },     /* kVK_F1 */
    { VK_LEFT,                  0x4B | 0x100,   TRUE },     /* kVK_LeftArrow */
    { VK_RIGHT,                 0x4D | 0x100,   TRUE },     /* kVK_RightArrow */
    { VK_DOWN,                  0x50 | 0x100,   TRUE },     /* kVK_DownArrow */
    { VK_UP,                    0x48 | 0x100,   TRUE },     /* kVK_UpArrow */
};


static const struct {
    DWORD       vkey;
    const char *name;
} vkey_names[] = {
    { VK_ADD,                   "Num +" },
    { VK_BACK,                  "Backspace" },
    { VK_CAPITAL,               "Caps Lock" },
    { VK_CONTROL,               "Ctrl" },
    { VK_DECIMAL,               "Num Del" },
    { VK_DELETE | 0x100,        "Delete" },
    { VK_DIVIDE | 0x100,        "Num /" },
    { VK_DOWN | 0x100,          "Down" },
    { VK_END | 0x100,           "End" },
    { VK_ESCAPE,                "Esc" },
    { VK_F1,                    "F1" },
    { VK_F2,                    "F2" },
    { VK_F3,                    "F3" },
    { VK_F4,                    "F4" },
    { VK_F5,                    "F5" },
    { VK_F6,                    "F6" },
    { VK_F7,                    "F7" },
    { VK_F8,                    "F8" },
    { VK_F9,                    "F9" },
    { VK_F10,                   "F10" },
    { VK_F11,                   "F11" },
    { VK_F12,                   "F12" },
    { VK_F13,                   "F13" },
    { VK_F14,                   "F14" },
    { VK_F15,                   "F15" },
    { VK_F16,                   "F16" },
    { VK_F17,                   "F17" },
    { VK_F18,                   "F18" },
    { VK_F19,                   "F19" },
    { VK_F20,                   "F20" },
    { VK_F21,                   "F21" },
    { VK_F22,                   "F22" },
    { VK_F23,                   "F23" },
    { VK_F24,                   "F24" },
    { VK_HELP | 0x100,          "Help" },
    { VK_HOME | 0x100,          "Home" },
    { VK_INSERT | 0x100,        "Insert" },
    { VK_LCONTROL,              "Ctrl" },
    { VK_LEFT | 0x100,          "Left" },
    { VK_LMENU,                 "Alt" },
    { VK_LSHIFT,                "Shift" },
    { VK_LWIN | 0x100,          "Win" },
    { VK_MENU,                  "Alt" },
    { VK_MULTIPLY,              "Num *" },
    { VK_NEXT | 0x100,          "Page Down" },
    { VK_NUMLOCK | 0x100,       "Num Lock" },
    { VK_NUMPAD0,               "Num 0" },
    { VK_NUMPAD1,               "Num 1" },
    { VK_NUMPAD2,               "Num 2" },
    { VK_NUMPAD3,               "Num 3" },
    { VK_NUMPAD4,               "Num 4" },
    { VK_NUMPAD5,               "Num 5" },
    { VK_NUMPAD6,               "Num 6" },
    { VK_NUMPAD7,               "Num 7" },
    { VK_NUMPAD8,               "Num 8" },
    { VK_NUMPAD9,               "Num 9" },
    { VK_OEM_CLEAR,             "Num Clear" },
    { VK_OEM_NEC_EQUAL | 0x100, "Num =" },
    { VK_PRIOR | 0x100,         "Page Up" },
    { VK_RCONTROL | 0x100,      "Right Ctrl" },
    { VK_RETURN,                "Return" },
    { VK_RETURN | 0x100,        "Num Enter" },
    { VK_RIGHT | 0x100,         "Right" },
    { VK_RMENU | 0x100,         "Right Alt" },
    { VK_RSHIFT,                "Right Shift" },
    { VK_RWIN | 0x100,          "Right Win" },
    { VK_SEPARATOR,             "Num ," },
    { VK_SHIFT,                 "Shift" },
    { VK_SPACE,                 "Space" },
    { VK_SUBTRACT,              "Num -" },
    { VK_TAB,                   "Tab" },
    { VK_UP | 0x100,            "Up" },
    { VK_VOLUME_DOWN | 0x100,   "Volume Down" },
    { VK_VOLUME_MUTE | 0x100,   "Mute" },
    { VK_VOLUME_UP | 0x100,     "Volume Up" },
};


static BOOL char_matches_string(WCHAR wchar, UniChar *string, BOOL ignore_diacritics)
{
    BOOL ret;
    CFStringRef s1 = CFStringCreateWithCharactersNoCopy(NULL, (UniChar*)&wchar, 1, kCFAllocatorNull);
    CFStringRef s2 = CFStringCreateWithCharactersNoCopy(NULL, string, strlenW(string), kCFAllocatorNull);
    CFStringCompareFlags flags = kCFCompareCaseInsensitive | kCFCompareNonliteral | kCFCompareWidthInsensitive;
    if (ignore_diacritics)
        flags |= kCFCompareDiacriticInsensitive;
    ret = (CFStringCompare(s1, s2, flags) == kCFCompareEqualTo);
    CFRelease(s1);
    CFRelease(s2);
    return ret;
}


/* Filter Apple-specific private-use characters (see NSEvent.h) out of a
 * string.  Returns the length of the string after stripping. */
static int strip_apple_private_chars(LPWSTR bufW, int len)
{
    int i;
    for (i = 0; i < len; )
    {
        if (0xF700 <= bufW[i] && bufW[i] <= 0xF8FF)
        {
            memmove(&bufW[i], &bufW[i+1], (len - i - 1) * sizeof(bufW[0]));
            len--;
        }
        else
            i++;
    }
    return len;
}


/***********************************************************************
 *              macdrv_compute_keyboard_layout
 */
void macdrv_compute_keyboard_layout(struct macdrv_thread_data *thread_data)
{
    int keyc;
    WCHAR vkey;
    const UCKeyboardLayout *uchr;
    const UInt32 modifier_combos[] = {
        0,
        shiftKey >> 8,
        cmdKey >> 8,
        (shiftKey | cmdKey) >> 8,
        optionKey >> 8,
        (shiftKey | optionKey) >> 8,
    };
    UniChar map[128][sizeof(modifier_combos) / sizeof(modifier_combos[0])][4 + 1];
    int combo;
    BYTE vkey_used[256];
    int ignore_diacritics;
    static const struct {
        WCHAR wchar;
        DWORD vkey;
    } symbol_vkeys[] = {
        { '-', VK_OEM_MINUS },
        { '+', VK_OEM_PLUS },
        { '_', VK_OEM_MINUS },
        { ',', VK_OEM_COMMA },
        { '.', VK_OEM_PERIOD },
        { '=', VK_OEM_PLUS },
        { '>', VK_OEM_PERIOD },
        { '<', VK_OEM_COMMA },
        { '|', VK_OEM_5 },
        { '\\', VK_OEM_5 },
        { '`', VK_OEM_3 },
        { '[', VK_OEM_4 },
        { '~', VK_OEM_3 },
        { '?', VK_OEM_2 },
        { ']', VK_OEM_6 },
        { '/', VK_OEM_2 },
        { ':', VK_OEM_1 },
        { '}', VK_OEM_6 },
        { '{', VK_OEM_4 },
        { ';', VK_OEM_1 },
        { '\'', VK_OEM_7 },
        { ':', VK_OEM_PERIOD },
        { ';', VK_OEM_COMMA },
        { '"', VK_OEM_7 },
        { 0x00B4, VK_OEM_4 }, /* 0x00B4 is ACUTE ACCENT */
        { '\'', VK_OEM_2 },
        { 0x00A7, VK_OEM_5 }, /* 0x00A7 is SECTION SIGN */
        { '*', VK_OEM_PLUS },
        { 0x00B4, VK_OEM_7 },
        { '`', VK_OEM_4 },
        { '[', VK_OEM_6 },
        { '/', VK_OEM_5 },
        { '^', VK_OEM_6 },
        { '*', VK_OEM_2 },
        { '{', VK_OEM_6 },
        { '~', VK_OEM_1 },
        { '?', VK_OEM_PLUS },
        { '?', VK_OEM_4 },
        { 0x00B4, VK_OEM_3 },
        { '?', VK_OEM_COMMA },
        { '~', VK_OEM_PLUS },
        { ']', VK_OEM_4 },
        { '\'', VK_OEM_3 },
        { 0x00A7, VK_OEM_7 },
    };
    int i;

    /* Vkeys that are suitable for assigning to arbitrary keys, organized in
       contiguous ranges. */
    static const struct {
        WORD first, last;
    } vkey_ranges[] = {
        { 'A', 'Z' },
        { '0', '9' },
        { VK_OEM_1, VK_OEM_3 },
        { VK_OEM_4, VK_ICO_CLEAR },
        { 0xe9, 0xf5 },
        { VK_OEM_NEC_EQUAL, VK_OEM_NEC_EQUAL },
        { VK_F1, VK_F24 },
        { 0, 0 }
    };
    int vkey_range;

    if (!thread_data->keyboard_layout_uchr)
    {
        ERR("no keyboard layout UCHR data\n");
        return;
    }

    memset(thread_data->keyc2vkey, 0, sizeof(thread_data->keyc2vkey));
    memset(vkey_used, 0, sizeof(vkey_used));

    for (keyc = 0; keyc < sizeof(default_map) / sizeof(default_map[0]); keyc++)
    {
        thread_data->keyc2scan[keyc] = default_map[keyc].scan;
        if (default_map[keyc].fixed)
        {
            vkey = default_map[keyc].vkey;
            thread_data->keyc2vkey[keyc] = vkey;
            vkey_used[vkey] = 1;
            TRACE("keyc 0x%04x -> vkey 0x%04x (fixed)\n", keyc, vkey);
        }
    }

    if (thread_data->iso_keyboard)
    {
        /* In almost all cases, the Mac key codes indicate a physical key position
           and this corresponds nicely to Win32 scan codes.  However, the Mac key
           codes differ in one case between ANSI and ISO keyboards.  For ANSI
           keyboards, the key to the left of the digits and above the Tab key
           produces key code kVK_ANSI_Grave.  For ISO keyboards, the key in that
           some position produces kVK_ISO_Section.  The additional key on ISO
           keyboards, the one to the right of the left Shift key, produces
           kVK_ANSI_Grave, which is just weird.

           Since we want the key in that upper left corner to always produce the
           same scan code (0x29), we need to swap the scan codes of those two
           Mac key codes for ISO keyboards. */
        DWORD temp = thread_data->keyc2scan[kVK_ANSI_Grave];
        thread_data->keyc2scan[kVK_ANSI_Grave] = thread_data->keyc2scan[kVK_ISO_Section];
        thread_data->keyc2scan[kVK_ISO_Section] = temp;
    }

    uchr = (const UCKeyboardLayout*)CFDataGetBytePtr(thread_data->keyboard_layout_uchr);

    /* Using the keyboard layout, build a map of key code + modifiers -> characters. */
    memset(map, 0, sizeof(map));
    for (keyc = 0; keyc < sizeof(map) / sizeof(map[0]); keyc++)
    {
        if (!thread_data->keyc2scan[keyc]) continue; /* not a known Mac key code */
        if (thread_data->keyc2vkey[keyc]) continue; /* assigned a fixed vkey */

        TRACE("keyc 0x%04x: ", keyc);

        for (combo = 0; combo < sizeof(modifier_combos) / sizeof(modifier_combos[0]); combo++)
        {
            UInt32 deadKeyState;
            UniCharCount len;
            OSStatus status;

            deadKeyState = 0;
            status = UCKeyTranslate(uchr, keyc, kUCKeyActionDown, modifier_combos[combo],
                thread_data->keyboard_type, kUCKeyTranslateNoDeadKeysMask,
                &deadKeyState, sizeof(map[keyc][combo])/sizeof(map[keyc][combo][0]) - 1,
                &len, map[keyc][combo]);
            if (status != noErr)
                map[keyc][combo][0] = 0;

            TRACE("%s%s", (combo ? ", " : ""), debugstr_w(map[keyc][combo]));
        }

        TRACE("\n");
    }

    /* First try to match key codes to the vkeys for the letters A through Z.
       Try unmodified first, then with various modifier combinations in succession.
       On the first pass, try to get a match lacking diacritical marks.  On the
       second pass, accept matches with diacritical marks. */
    for (ignore_diacritics = 0; ignore_diacritics <= 1; ignore_diacritics++)
    {
        for (combo = 0; combo < sizeof(modifier_combos) / sizeof(modifier_combos[0]); combo++)
        {
            for (vkey = 'A'; vkey <= 'Z'; vkey++)
            {
                if (vkey_used[vkey])
                    continue;

                for (keyc = 0; keyc < sizeof(map) / sizeof(map[0]); keyc++)
                {
                    if (thread_data->keyc2vkey[keyc] || !map[keyc][combo][0])
                        continue;

                    if (char_matches_string(vkey, map[keyc][combo], ignore_diacritics))
                    {
                        thread_data->keyc2vkey[keyc] = vkey;
                        vkey_used[vkey] = 1;
                        TRACE("keyc 0x%04x -> vkey 0x%04x (%s match %s)\n", keyc, vkey,
                              debugstr_wn(&vkey, 1), debugstr_w(map[keyc][combo]));
                        break;
                    }
                }
            }
        }
    }

    /* Next try to match key codes to the vkeys for the digits 0 through 9. */
    for (combo = 0; combo < sizeof(modifier_combos) / sizeof(modifier_combos[0]); combo++)
    {
        for (vkey = '0'; vkey <= '9'; vkey++)
        {
            if (vkey_used[vkey])
                continue;

            for (keyc = 0; keyc < sizeof(map) / sizeof(map[0]); keyc++)
            {
                if (thread_data->keyc2vkey[keyc] || !map[keyc][combo][0])
                    continue;

                if (char_matches_string(vkey, map[keyc][combo], FALSE))
                {
                    thread_data->keyc2vkey[keyc] = vkey;
                    vkey_used[vkey] = 1;
                    TRACE("keyc 0x%04x -> vkey 0x%04x (%s match %s)\n", keyc, vkey,
                          debugstr_wn(&vkey, 1), debugstr_w(map[keyc][combo]));
                    break;
                }
            }
        }
    }

    /* Now try to match key codes for certain common punctuation characters to
       the most common OEM vkeys (e.g. '.' to VK_OEM_PERIOD). */
    for (i = 0; i < sizeof(symbol_vkeys) / sizeof(symbol_vkeys[0]); i++)
    {
        vkey = symbol_vkeys[i].vkey;

        if (vkey_used[vkey])
            continue;

        for (combo = 0; combo < sizeof(modifier_combos) / sizeof(modifier_combos[0]); combo++)
        {
            for (keyc = 0; keyc < sizeof(map) / sizeof(map[0]); keyc++)
            {
                if (!thread_data->keyc2scan[keyc]) continue; /* not a known Mac key code */
                if (thread_data->keyc2vkey[keyc] || !map[keyc][combo][0])
                    continue;

                if (char_matches_string(symbol_vkeys[i].wchar, map[keyc][combo], FALSE))
                {
                    thread_data->keyc2vkey[keyc] = vkey;
                    vkey_used[vkey] = 1;
                    TRACE("keyc 0x%04x -> vkey 0x%04x (%s match %s)\n", keyc, vkey,
                          debugstr_wn(&symbol_vkeys[i].wchar, 1), debugstr_w(map[keyc][combo]));
                    break;
                }
            }

            if (vkey_used[vkey])
                break;
        }
    }

    /* For those key codes still without a vkey, try to use the default vkey
       from the default map, if it's still available. */
    for (keyc = 0; keyc < sizeof(default_map) / sizeof(default_map[0]); keyc++)
    {
        DWORD vkey = default_map[keyc].vkey;

        if (!thread_data->keyc2scan[keyc]) continue; /* not a known Mac key code */
        if (thread_data->keyc2vkey[keyc]) continue; /* already assigned */

        if (!vkey_used[vkey])
        {
            thread_data->keyc2vkey[keyc] = vkey;
            vkey_used[vkey] = 1;
            TRACE("keyc 0x%04x -> vkey 0x%04x (default map)\n", keyc, vkey);
        }
    }

    /* For any unassigned key codes which would map to a letter in the default
       map, but whose normal letter vkey wasn't available, try to find a
       different letter. */
    vkey = 'A';
    for (keyc = 0; keyc < sizeof(default_map) / sizeof(default_map[0]); keyc++)
    {
        if (default_map[keyc].vkey < 'A' || 'Z' < default_map[keyc].vkey)
            continue; /* not a letter in ANSI layout */
        if (!thread_data->keyc2scan[keyc]) continue; /* not a known Mac key code */
        if (thread_data->keyc2vkey[keyc]) continue; /* already assigned */

        while (vkey <= 'Z' && vkey_used[vkey]) vkey++;
        if (vkey <= 'Z')
        {
            thread_data->keyc2vkey[keyc] = vkey;
            vkey_used[vkey] = 1;
            TRACE("keyc 0x%04x -> vkey 0x%04x (spare letter)\n", keyc, vkey);
        }
        else
            break; /* no more unused letter vkeys, so stop trying */
    }

    /* Same thing but with the digits. */
    vkey = '0';
    for (keyc = 0; keyc < sizeof(default_map) / sizeof(default_map[0]); keyc++)
    {
        if (default_map[keyc].vkey < '0' || '9' < default_map[keyc].vkey)
            continue; /* not a digit in ANSI layout */
        if (!thread_data->keyc2scan[keyc]) continue; /* not a known Mac key code */
        if (thread_data->keyc2vkey[keyc]) continue; /* already assigned */

        while (vkey <= '9' && vkey_used[vkey]) vkey++;
        if (vkey <= '9')
        {
            thread_data->keyc2vkey[keyc] = vkey;
            vkey_used[vkey] = 1;
            TRACE("keyc 0x%04x -> vkey 0x%04x (spare digit)\n", keyc, vkey);
        }
        else
            break; /* no more unused digit vkeys, so stop trying */
    }

    /* Last chance.  Assign any available vkey. */
    vkey_range = 0;
    vkey = vkey_ranges[vkey_range].first;
    for (keyc = 0; keyc < sizeof(default_map) / sizeof(default_map[0]); keyc++)
    {
        if (!thread_data->keyc2scan[keyc]) continue; /* not a known Mac key code */
        if (thread_data->keyc2vkey[keyc]) continue; /* already assigned */

        while (vkey && vkey_used[vkey])
        {
            if (vkey == vkey_ranges[vkey_range].last)
            {
                vkey_range++;
                vkey = vkey_ranges[vkey_range].first;
            }
            else
                vkey++;
        }

        if (!vkey)
        {
            WARN("No more vkeys available!\n");
            break;
        }

        thread_data->keyc2vkey[keyc] = vkey;
        vkey_used[vkey] = 1;
        TRACE("keyc 0x%04x -> vkey 0x%04x (spare vkey)\n", keyc, vkey);
    }
}


/***********************************************************************
 *              macdrv_send_keyboard_input
 */
static void macdrv_send_keyboard_input(HWND hwnd, WORD vkey, WORD scan, DWORD flags, DWORD time)
{
    INPUT input;

    TRACE_(key)("hwnd %p vkey=%04x scan=%04x flags=%04x\n", hwnd, vkey, scan, flags);

    input.type              = INPUT_KEYBOARD;
    input.ki.wVk            = vkey;
    input.ki.wScan          = scan;
    input.ki.dwFlags        = flags;
    input.ki.time           = time;
    input.ki.dwExtraInfo    = 0;

    __wine_send_input(hwnd, &input);
}


/***********************************************************************
 *              macdrv_key_event
 *
 * Handler for KEY_PRESS and KEY_RELEASE events.
 */
void macdrv_key_event(HWND hwnd, const macdrv_event *event)
{
    struct macdrv_thread_data *thread_data = macdrv_thread_data();
    WORD vkey, scan;
    DWORD flags;

    TRACE_(key)("win %p/%p key %s keycode %hu modifiers 0x%08llx\n",
                hwnd, event->window, (event->type == KEY_PRESS ? "press" : "release"),
                event->key.keycode, event->key.modifiers);

    thread_data->last_modifiers = event->key.modifiers;

    if (event->key.keycode < sizeof(thread_data->keyc2vkey)/sizeof(thread_data->keyc2vkey[0]))
    {
        vkey = thread_data->keyc2vkey[event->key.keycode];
        scan = thread_data->keyc2scan[event->key.keycode];
    }
    else
        vkey = scan = 0;

    TRACE_(key)("keycode %hu converted to vkey 0x%X scan 0x%02x\n",
                event->key.keycode, vkey, scan);

    if (!vkey) return;

    flags = 0;
    if (event->type == KEY_RELEASE) flags |= KEYEVENTF_KEYUP;
    if (scan & 0x100)               flags |= KEYEVENTF_EXTENDEDKEY;

    macdrv_send_keyboard_input(hwnd, vkey, scan & 0xff, flags, event->key.time_ms);
}


/***********************************************************************
 *              macdrv_keyboard_changed
 *
 * Handler for KEYBOARD_CHANGED events.
 */
void macdrv_keyboard_changed(const macdrv_event *event)
{
    struct macdrv_thread_data *thread_data = macdrv_thread_data();

    TRACE("new keyboard layout uchr data %p, type %u, iso %d\n", event->keyboard_changed.uchr,
          event->keyboard_changed.keyboard_type, event->keyboard_changed.iso_keyboard);

    if (thread_data->keyboard_layout_uchr)
        CFRelease(thread_data->keyboard_layout_uchr);
    thread_data->keyboard_layout_uchr = CFDataCreateCopy(NULL, event->keyboard_changed.uchr);
    thread_data->keyboard_type = event->keyboard_changed.keyboard_type;
    thread_data->iso_keyboard = event->keyboard_changed.iso_keyboard;
    thread_data->dead_key_state = 0;

    macdrv_compute_keyboard_layout(thread_data);

    SendMessageW(GetActiveWindow(), WM_CANCELMODE, 0, 0);
}


/***********************************************************************
 *              get_locale_keyboard_layout
 */
static HKL get_locale_keyboard_layout(void)
{
    ULONG_PTR layout;
    LANGID langid;

    layout = GetUserDefaultLCID();

    /*
     * Microsoft Office expects this value to be something specific
     * for Japanese and Korean Windows with an IME the value is 0xe001
     * We should probably check to see if an IME exists and if so then
     * set this word properly.
     */
    langid = PRIMARYLANGID(LANGIDFROMLCID(layout));
    if (langid == LANG_CHINESE || langid == LANG_JAPANESE || langid == LANG_KOREAN)
        layout |= 0xe001 << 16; /* IME */
    else
        layout |= layout << 16;

    return (HKL)layout;
}


/***********************************************************************
 *              match_keyboard_layout
 */
static BOOL match_keyboard_layout(HKL hkl)
{
    const DWORD isIME = 0xE0000000;
    HKL current_hkl = get_locale_keyboard_layout();

    /* if the layout is an IME, only match the low word (LCID) */
    if (((ULONG_PTR)hkl & isIME) == isIME)
        return (LOWORD(hkl) == LOWORD(current_hkl));
    else
        return (hkl == current_hkl);
}


/***********************************************************************
 *              macdrv_process_text_input
 */
BOOL macdrv_process_text_input(UINT vkey, UINT scan, UINT repeat, const BYTE *key_state, void *himc)
{
    struct macdrv_thread_data *thread_data = macdrv_thread_data();
    unsigned int flags;
    int keyc;
    BOOL ret = FALSE;

    TRACE("vkey 0x%04x scan 0x%04x repeat %u himc %p\n", vkey, scan, repeat, himc);

    flags = thread_data->last_modifiers;
    if (key_state[VK_SHIFT] & 0x80)
        flags |= NX_SHIFTMASK;
    else
        flags &= ~(NX_SHIFTMASK | NX_DEVICELSHIFTKEYMASK | NX_DEVICERSHIFTKEYMASK);
    if (key_state[VK_CAPITAL] & 0x01)
        flags |= NX_ALPHASHIFTMASK;
    else
        flags &= ~NX_ALPHASHIFTMASK;
    if (key_state[VK_CONTROL] & 0x80)
        flags |= NX_CONTROLMASK;
    else
        flags &= ~(NX_CONTROLMASK | NX_DEVICELCTLKEYMASK | NX_DEVICERCTLKEYMASK);
    if (key_state[VK_MENU] & 0x80)
        flags |= NX_COMMANDMASK;
    else
        flags &= ~(NX_COMMANDMASK | NX_DEVICELCMDKEYMASK | NX_DEVICERCMDKEYMASK);

    /* Find the Mac keycode corresponding to the scan code */
    for (keyc = 0; keyc < sizeof(thread_data->keyc2vkey)/sizeof(thread_data->keyc2vkey[0]); keyc++)
        if (thread_data->keyc2vkey[keyc] == vkey) break;

    if (keyc >= sizeof(thread_data->keyc2vkey)/sizeof(thread_data->keyc2vkey[0]))
        goto done;

    TRACE("flags 0x%08x keyc 0x%04x\n", flags, keyc);

    ret = macdrv_send_text_input_event(((scan & 0x8000) == 0), flags, repeat, keyc, himc);

done:
    TRACE(" -> %s\n", ret ? "TRUE" : "FALSE");
    return ret;
}


/***********************************************************************
 *              ActivateKeyboardLayout (MACDRV.@)
 */
HKL CDECL macdrv_ActivateKeyboardLayout(HKL hkl, UINT flags)
{
    HKL oldHkl = 0;
    struct macdrv_thread_data *thread_data = macdrv_init_thread_data();

    /* FIXME: Use Text Input Services or NSTextInputContext to actually
              change the Mac keyboard input source. */

    FIXME("hkl %p flags %04x: semi-stub!\n", hkl, flags);
    if (flags & KLF_SETFORPROCESS)
    {
        SetLastError(ERROR_CALL_NOT_IMPLEMENTED);
        FIXME("KLF_SETFORPROCESS not supported\n");
        return 0;
    }

    if (flags)
        FIXME("flags %x not supported\n",flags);

    if (hkl == (HKL)HKL_NEXT || hkl == (HKL)HKL_PREV)
    {
        SetLastError(ERROR_CALL_NOT_IMPLEMENTED);
        FIXME("HKL_NEXT and HKL_PREV not supported\n");
        return 0;
    }

    if (!match_keyboard_layout(hkl))
    {
        SetLastError(ERROR_CALL_NOT_IMPLEMENTED);
        FIXME("setting keyboard of different locales not supported\n");
        return 0;
    }

    oldHkl = thread_data->active_keyboard_layout;
    if (!oldHkl) oldHkl = get_locale_keyboard_layout();

    thread_data->active_keyboard_layout = hkl;

    return oldHkl;
}


/***********************************************************************
 *              Beep (MACDRV.@)
 */
void CDECL macdrv_Beep(void)
{
    macdrv_beep();
}


/***********************************************************************
 *              GetKeyNameText (MACDRV.@)
 */
INT CDECL macdrv_GetKeyNameText(LONG lparam, LPWSTR buffer, INT size)
{
    struct macdrv_thread_data *thread_data = macdrv_init_thread_data();
    int scan, keyc;

    scan = (lparam >> 16) & 0x1FF;
    for (keyc = 0; keyc < sizeof(thread_data->keyc2scan)/sizeof(thread_data->keyc2scan[0]); keyc++)
    {
        if (thread_data->keyc2scan[keyc] == scan)
        {
            static const WCHAR dead[] = {' ','d','e','a','d',0};
            const UCKeyboardLayout *uchr;
            UInt32 deadKeyState = 0;
            UniCharCount len;
            OSStatus status;

            uchr = (const UCKeyboardLayout*)CFDataGetBytePtr(thread_data->keyboard_layout_uchr);
            status = UCKeyTranslate(uchr, keyc, kUCKeyActionDisplay, 0, thread_data->keyboard_type,
                                    0, &deadKeyState, size - 1, &len, (UniChar*)buffer);
            if (status != noErr)
                len = 0;
            if (len && isgraphW(buffer[0]))
                buffer[len] = 0;
            else
            {
                DWORD vkey = thread_data->keyc2vkey[keyc];
                int i;

                if (scan & 0x100) vkey |= 0x100;

                if (lparam & (1 << 25))
                {
                    /* Caller doesn't care about distinctions between left and
                       right keys. */
                    switch (vkey)
                    {
                        case VK_LSHIFT:
                        case VK_RSHIFT:
                            vkey = VK_SHIFT; break;
                        case VK_LCONTROL:
                        case VK_RCONTROL:
                            vkey = VK_CONTROL; break;
                        case VK_LMENU:
                        case VK_RMENU:
                            vkey = VK_MENU; break;
                    }
                }

                len = 0;
                for (i = 0; i < sizeof(vkey_names) / sizeof(vkey_names[0]); i++)
                {
                    if (vkey_names[i].vkey == vkey)
                    {
                        len = MultiByteToWideChar(CP_UTF8, 0, vkey_names[i].name, -1, buffer, size);
                        if (len) len--;
                        break;
                    }
                }

                if (!len)
                {
                    static const WCHAR format[] = {'K','e','y',' ','0','x','%','0','2','x',0};
                    snprintfW(buffer, size, format, vkey);
                    len = strlenW(buffer);
                }
            }

            if (!len)
                break;

            if (status == noErr && deadKeyState)
            {
                lstrcpynW(buffer + len, dead, size - len);
                len = strlenW(buffer);
            }

            TRACE("lparam 0x%08x -> %s\n", lparam, debugstr_w(buffer));
            return len;
        }
    }

    WARN("found no name for lparam 0x%08x\n", lparam);
    return 0;
}


/***********************************************************************
 *              GetKeyboardLayout (MACDRV.@)
 */
HKL CDECL macdrv_GetKeyboardLayout(DWORD thread_id)
{
    if (!thread_id || thread_id == GetCurrentThreadId())
    {
        struct macdrv_thread_data *thread_data = macdrv_thread_data();
        if (thread_data && thread_data->active_keyboard_layout)
            return thread_data->active_keyboard_layout;
    }
    else
        FIXME("couldn't return keyboard layout for thread %04x\n", thread_id);

    /* FIXME: Use TISGetInputSourceProperty() and kTISPropertyInputSourceLanguages
     *        to get input source language ID string.  Use
     *        CFLocaleGetWindowsLocaleCodeFromLocaleIdentifier() to convert that
     *        to a Windows locale ID and from there to a layout handle.
     */

    return get_locale_keyboard_layout();
}


/***********************************************************************
 *              GetKeyboardLayoutName (MACDRV.@)
 */
BOOL CDECL macdrv_GetKeyboardLayoutName(LPWSTR name)
{
    static const WCHAR formatW[] = {'%','0','8','x',0};
    DWORD layout;

    layout = HandleToUlong(get_locale_keyboard_layout());
    if (HIWORD(layout) == LOWORD(layout)) layout = LOWORD(layout);
    sprintfW(name, formatW, layout);
    TRACE("returning %s\n", debugstr_w(name));
    return TRUE;
}


/***********************************************************************
 *              MapVirtualKeyEx (MACDRV.@)
 */
UINT CDECL macdrv_MapVirtualKeyEx(UINT wCode, UINT wMapType, HKL hkl)
{
    struct macdrv_thread_data *thread_data = macdrv_init_thread_data();
    UINT ret = 0;
    int keyc;

    TRACE("wCode=0x%x, wMapType=%d, hkl %p\n", wCode, wMapType, hkl);

    switch (wMapType)
    {
        case MAPVK_VK_TO_VSC: /* vkey-code to scan-code */
        case MAPVK_VK_TO_VSC_EX:
            switch (wCode)
            {
                case VK_SHIFT: wCode = VK_LSHIFT; break;
                case VK_CONTROL: wCode = VK_LCONTROL; break;
                case VK_MENU: wCode = VK_LMENU; break;
            }

            /* vkey -> keycode -> scan */
            for (keyc = 0; keyc < sizeof(thread_data->keyc2vkey)/sizeof(thread_data->keyc2vkey[0]); keyc++)
            {
                if (thread_data->keyc2vkey[keyc] == wCode)
                {
                    ret = thread_data->keyc2scan[keyc] & 0xFF;
                    break;
                }
            }
            break;

        case MAPVK_VSC_TO_VK: /* scan-code to vkey-code */
        case MAPVK_VSC_TO_VK_EX:
            /* scan -> keycode -> vkey */
            for (keyc = 0; keyc < sizeof(thread_data->keyc2vkey)/sizeof(thread_data->keyc2vkey[0]); keyc++)
                if ((thread_data->keyc2scan[keyc] & 0xFF) == (wCode & 0xFF))
                {
                    ret = thread_data->keyc2vkey[keyc];
                    /* Only stop if it's not a numpad vkey; otherwise keep
                       looking for a potential better vkey. */
                    if (ret && (ret < VK_NUMPAD0 || VK_DIVIDE < ret))
                        break;
                }

            if (wMapType == MAPVK_VSC_TO_VK)
                switch (ret)
                {
                    case VK_LSHIFT:
                    case VK_RSHIFT:
                        ret = VK_SHIFT; break;
                    case VK_LCONTROL:
                    case VK_RCONTROL:
                        ret = VK_CONTROL; break;
                    case VK_LMENU:
                    case VK_RMENU:
                        ret = VK_MENU; break;
                }

            break;

        case MAPVK_VK_TO_CHAR: /* vkey-code to character */
        {
            /* vkey -> keycode -> (UCKeyTranslate) wide char */
            struct macdrv_thread_data *thread_data = macdrv_thread_data();
            const UCKeyboardLayout *uchr;
            UniChar s[10];
            OSStatus status;
            UInt32 deadKeyState;
            UniCharCount len;
            BOOL deadKey = FALSE;

            if ((VK_PRIOR <= wCode && wCode <= VK_HELP) ||
                (VK_F1 <= wCode && wCode <= VK_F24))
                break;

            if (!thread_data || !thread_data->keyboard_layout_uchr)
            {
                WARN("No keyboard layout uchr data\n");
                break;
            }

            uchr = (const UCKeyboardLayout*)CFDataGetBytePtr(thread_data->keyboard_layout_uchr);

            /* Find the Mac keycode corresponding to the vkey */
            for (keyc = 0; keyc < sizeof(thread_data->keyc2vkey)/sizeof(thread_data->keyc2vkey[0]); keyc++)
                if (thread_data->keyc2vkey[keyc] == wCode) break;

            if (keyc >= sizeof(thread_data->keyc2vkey)/sizeof(thread_data->keyc2vkey[0]))
            {
                WARN("Unknown virtual key %X\n", wCode);
                break;
            }

            TRACE("Found keycode %u\n", keyc);

            deadKeyState = 0;
            status = UCKeyTranslate(uchr, keyc, kUCKeyActionDown, 0,
                thread_data->keyboard_type, 0, &deadKeyState,
                sizeof(s)/sizeof(s[0]), &len, s);
            if (status == noErr && !len && deadKeyState)
            {
                deadKey = TRUE;
                deadKeyState = 0;
                status = UCKeyTranslate(uchr, keyc, kUCKeyActionDown, 0,
                    thread_data->keyboard_type, kUCKeyTranslateNoDeadKeysMask,
                    &deadKeyState, sizeof(s)/sizeof(s[0]), &len, s);
            }

            if (status == noErr && len)
                ret = toupperW(s[0]) | (deadKey ? 0x80000000 : 0);

            break;
        }
        default: /* reserved */
            FIXME("Unknown wMapType %d\n", wMapType);
            break;
    }

    TRACE("returning 0x%04x\n", ret);
    return ret;
}


/***********************************************************************
 *              ToUnicodeEx (MACDRV.@)
 *
 * The ToUnicode function translates the specified virtual-key code and keyboard
 * state to the corresponding Windows character or characters.
 *
 * If the specified key is a dead key, the return value is negative. Otherwise,
 * it is one of the following values:
 * Value        Meaning
 * -1           The specified virtual key is a dead-key.  If possible, the
 *              non-combining form of the dead character is written to bufW.
 * 0            The specified virtual key has no translation for the current
 *              state of the keyboard.
 * 1            One Windows character was copied to the buffer.
 * 2 or more    Multiple characters were copied to the buffer. This usually
 *              happens when a dead-key character (accent or diacritic) stored
 *              in the keyboard layout cannot be composed with the specified
 *              virtual key to form a single character.
 *
 */
INT CDECL macdrv_ToUnicodeEx(UINT virtKey, UINT scanCode, const BYTE *lpKeyState,
                             LPWSTR bufW, int bufW_size, UINT flags, HKL hkl)
{
    struct macdrv_thread_data *thread_data = macdrv_init_thread_data();
    INT ret = 0;
    int keyc;
    BOOL is_menu = (flags & 0x1);
    OSStatus status;
    const UCKeyboardLayout *uchr;
    UInt16 keyAction;
    UInt32 modifierKeyState;
    OptionBits options;
    UInt32 deadKeyState, savedDeadKeyState;
    UniCharCount len;
    BOOL dead = FALSE;

    TRACE_(key)("virtKey 0x%04x scanCode 0x%04x lpKeyState %p bufW %p bufW_size %d flags 0x%08x hkl %p\n",
                virtKey, scanCode, lpKeyState, bufW, bufW_size, flags, hkl);

    if (!virtKey)
        goto done;

    /* UCKeyTranslate, below, terminates a dead-key sequence if passed a
       modifier key press.  We want it to effectively ignore modifier key
       presses.  I think that one isn't supposed to call it at all for modifier
       events (e.g. NSFlagsChanged or kEventRawKeyModifiersChanged), since they
       are different event types than key up/down events. */
    switch (virtKey)
    {
        case VK_SHIFT:
        case VK_CONTROL:
        case VK_MENU:
        case VK_CAPITAL:
        case VK_LSHIFT:
        case VK_RSHIFT:
        case VK_LCONTROL:
        case VK_RCONTROL:
        case VK_LMENU:
        case VK_RMENU:
            goto done;
    }

    /* There are a number of key combinations for which Windows does not
       produce characters, but Mac keyboard layouts may.  Eat them.  Do this
       here to avoid the expense of UCKeyTranslate() but also because these
       keys shouldn't terminate dead key sequences. */
    if ((VK_PRIOR <= virtKey && virtKey <= VK_HELP) || (VK_F1 <= virtKey && virtKey <= VK_F24))
        goto done;

    /* Shift + <non-digit keypad keys>. */
    if ((lpKeyState[VK_SHIFT] & 0x80) && VK_MULTIPLY <= virtKey && virtKey <= VK_DIVIDE)
        goto done;

    if (lpKeyState[VK_CONTROL] & 0x80)
    {
        /* Control-Tab, with or without other modifiers. */
        if (virtKey == VK_TAB)
            goto done;

        /* Control-Shift-<key>, Control-Alt-<key>, and Control-Alt-Shift-<key>
           for these keys. */
        if ((lpKeyState[VK_SHIFT] & 0x80) || (lpKeyState[VK_MENU] & 0x80))
        {
            switch (virtKey)
            {
                case VK_CANCEL:
                case VK_BACK:
                case VK_ESCAPE:
                case VK_SPACE:
                case VK_RETURN:
                    goto done;
            }
        }
    }

    if (thread_data->keyboard_layout_uchr)
        uchr = (const UCKeyboardLayout*)CFDataGetBytePtr(thread_data->keyboard_layout_uchr);
    else
        uchr = NULL;

    keyAction = (scanCode & 0x8000) ? kUCKeyActionUp : kUCKeyActionDown;

    modifierKeyState = 0;
    if (lpKeyState[VK_SHIFT] & 0x80)
        modifierKeyState |= (shiftKey >> 8);
    if (lpKeyState[VK_CAPITAL] & 0x01)
        modifierKeyState |= (alphaLock >> 8);
    if (lpKeyState[VK_CONTROL] & 0x80)
        modifierKeyState |= (controlKey >> 8);
    if (lpKeyState[VK_MENU] & 0x80)
        modifierKeyState |= (cmdKey >> 8);
    if (thread_data->last_modifiers & (NX_ALTERNATEMASK | NX_DEVICELALTKEYMASK | NX_DEVICERALTKEYMASK))
        modifierKeyState |= (optionKey >> 8);

    /* Find the Mac keycode corresponding to the vkey */
    for (keyc = 0; keyc < sizeof(thread_data->keyc2vkey)/sizeof(thread_data->keyc2vkey[0]); keyc++)
        if (thread_data->keyc2vkey[keyc] == virtKey) break;

    if (keyc >= sizeof(thread_data->keyc2vkey)/sizeof(thread_data->keyc2vkey[0]))
    {
        WARN_(key)("Unknown virtual key 0x%04x\n", virtKey);
        goto done;
    }

    TRACE_(key)("Key code 0x%04x %s, faked modifiers = 0x%04x\n", keyc,
                (keyAction == kUCKeyActionDown) ? "pressed" : "released", (unsigned)modifierKeyState);

    if (is_menu)
    {
        if (keyAction == kUCKeyActionUp)
            goto done;

        options = kUCKeyTranslateNoDeadKeysMask;
        deadKeyState = 0;
    }
    else
    {
        options = 0;
        deadKeyState = thread_data->dead_key_state;
    }
    savedDeadKeyState = deadKeyState;
    status = UCKeyTranslate(uchr, keyc, keyAction, modifierKeyState,
        thread_data->keyboard_type, options, &deadKeyState, bufW_size,
        &len, bufW);
    if (status != noErr)
    {
        ERR_(key)("Couldn't translate keycode 0x%04x, status %ld\n", keyc, status);
        goto done;
    }
    if (!is_menu)
    {
        if (keyAction != kUCKeyActionUp && len > 0 && deadKeyState == thread_data->dead_key_state)
            thread_data->dead_key_state = 0;
        else
            thread_data->dead_key_state = deadKeyState;

        if (keyAction == kUCKeyActionUp)
            goto done;
    }

    if (len == 0 && deadKeyState)
    {
        /* Repeat the translation, but disabling dead-key generation to
           learn which dead key it was. */
        status = UCKeyTranslate(uchr, keyc, keyAction, modifierKeyState,
            thread_data->keyboard_type, kUCKeyTranslateNoDeadKeysMask,
            &savedDeadKeyState, bufW_size, &len, bufW);
        if (status != noErr)
        {
            ERR_(key)("Couldn't translate keycode 0x%04x, status %ld\n", keyc, status);
            goto done;
        }

        dead = TRUE;
    }

    if (len > 0)
        len = strip_apple_private_chars(bufW, len);

    if (dead && len > 0) ret = -1;
    else ret = len;

    /* Control-Return produces line feed instead of carriage return. */
    if (ret > 0 && (lpKeyState[VK_CONTROL] & 0x80) && virtKey == VK_RETURN)
    {
        int i;
        for (i = 0; i < len; i++)
            if (bufW[i] == '\r')
                bufW[i] = '\n';
    }

done:
    /* Null-terminate the buffer, if there's room.  MSDN clearly states that the
       caller must not assume this is done, but some programs (e.g. Audiosurf) do. */
    if (1 <= ret && ret < bufW_size)
        bufW[ret] = 0;

    TRACE_(key)("returning %d / %s\n", ret, debugstr_wn(bufW, abs(ret)));
    return ret;
}


/***********************************************************************
 *              VkKeyScanEx (MACDRV.@)
 *
 * Note: Windows ignores HKL parameter and uses current active layout instead
 */
SHORT CDECL macdrv_VkKeyScanEx(WCHAR wChar, HKL hkl)
{
    struct macdrv_thread_data *thread_data = macdrv_init_thread_data();
    SHORT ret = -1;
    int state;
    const UCKeyboardLayout *uchr;

    TRACE("%04x, %p\n", wChar, hkl);

    uchr = (const UCKeyboardLayout*)CFDataGetBytePtr(thread_data->keyboard_layout_uchr);
    if (!uchr)
    {
        TRACE("no keyboard layout UCHR data; returning -1\n");
        return -1;
    }

    for (state = 0; state < 8; state++)
    {
        UInt32 modifierKeyState = 0;
        int keyc;

        if (state & 1)
            modifierKeyState |= (shiftKey >> 8);
        if ((state & 6) == 6)
            modifierKeyState |= (optionKey >> 8);
        else
        {
            if (state & 2)
                modifierKeyState |= (controlKey >> 8);
            if (state & 4)
                modifierKeyState |= (cmdKey >> 8);
        }

        for (keyc = 0; keyc < sizeof(thread_data->keyc2vkey) / sizeof(thread_data->keyc2vkey[0]); keyc++)
        {
            UInt32 deadKeyState = 0;
            UniChar uchar;
            UniCharCount len;
            OSStatus status;

            if (!thread_data->keyc2vkey[keyc]) continue;

            status = UCKeyTranslate(uchr, keyc, kUCKeyActionDown, modifierKeyState,
                                    thread_data->keyboard_type, 0, &deadKeyState,
                                    1, &len, &uchar);
            if (status == noErr && len == 1 && uchar == wChar)
            {
                WORD vkey = thread_data->keyc2vkey[keyc];

                ret = vkey | (state << 8);
                if ((VK_NUMPAD0 <= vkey && vkey <= VK_DIVIDE) ||
                    keyc == kVK_ANSI_KeypadClear || keyc == kVK_ANSI_KeypadEnter ||
                    keyc == kVK_ANSI_KeypadEquals)
                {
                    /* Keep searching for a non-numpad match, which is preferred. */
                }
                else
                    goto done;
            }
        }
    }

done:
    TRACE(" -> 0x%04x\n", ret);
    return ret;
}
