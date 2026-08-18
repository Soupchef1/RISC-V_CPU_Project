#include <stdint.h>

// -----------------------------------------------------------------------------
// Base Memory & Display Definitions
// -----------------------------------------------------------------------------
// Frame Buffer #1: 0x0FC0_0000 to 0x0FFF_FFFF (4 MB total space)
#define FRAME_BUFFER_1_BASE  ((volatile uint32_t*)0x0FC00000)

// 720p Resolutionc
#define SCREEN_WIDTH         1280
#define SCREEN_HEIGHT        720

// Standard Color Definitions (32-bit ARGB/XRGB format: 0x00RRGGBB)
#define COLOR_RED            0x00FF0000
#define COLOR_GREEN          0x0000FF00
#define COLOR_BLUE           0x000000FF
#define COLOR_BLACK          0x00000000

// -----------------------------------------------------------------------------
// Helper Functions
// -----------------------------------------------------------------------------

/**
 * Draws a single pixel to Frame Buffer 1
 */
void draw_pixel(int x, int y, uint32_t color) {
    if (x >= 0 && x < SCREEN_WIDTH && y >= 0 && y < SCREEN_HEIGHT) {
        // Calculate 1D offset in pixels: offset = (y * width) + x
        uint32_t offset = (y * SCREEN_WIDTH) + x;
        *(FRAME_BUFFER_1_BASE + offset) = color;
    }
}

/**
 * Clears the screen with a solid background color
 */
void clear_screen(uint32_t color) {
    for (int y = 0; y < SCREEN_HEIGHT; y++) {
        for (int x = 0; x < SCREEN_WIDTH; x++) {
            draw_pixel(x, y, color);
        }
    }
}

/**
 * Draws a solid filled circle
 * Equation: (x - cx)^2 + (y - cy)^2 <= r^2
 */
void draw_filled_circle(int cx, int cy, int radius, uint32_t color) {
    int r_squared = radius * radius;

    for (int y = cy - radius; y <= cy + radius; y++) {
        for (int x = cx - radius; x <= cx + radius; x++) {
            int dx = x - cx;
            int dy = y - cy;

            if ((dx * dx + dy * dy) <= r_squared) {
                draw_pixel(x, y, color);
            }
        }
    }
}

// void draw_filled_square(int x_start, int y_start, int length, int height, uint32_t color) {
//     for(int y = y_start; y < y_start + height && y < SCREEN_HEIGHT; y++) {
//         for(int x = x_start; x < x_start + length && x < SCREEN_WIDTH; x++) {
//             draw_pixel(x, y, color);
//         }
//     }
// }

// -----------------------------------------------------------------------------
// Main Entry Point
// -----------------------------------------------------------------------------
int main(void) {
    // 1. Clear background to black
    clear_screen(COLOR_BLACK);

    // 2. Circle properties (Scaled for 720p display)
    int radius = 80;
    // int height = 500;
    // int width = 80;
    int center_y = SCREEN_HEIGHT / 2; // y = 360

    int red_center_x   = (SCREEN_WIDTH / 4);     // x = 320
    int green_center_x = (SCREEN_WIDTH / 2);     // x = 640
    int blue_center_x  = (3 * SCREEN_WIDTH / 4); // x = 960

    // draw_filled_square(150, 300, width, height, COLOR_RED);
    // draw_filled_square(500, 200, width, height, COLOR_BLUE);
    // draw_filled_square(850, 100, width, height, COLOR_GREEN);

    // 3. Render Red, Green, and Blue circles across the 720p frame
    draw_filled_circle(red_center_x, center_y, radius, COLOR_RED);
    draw_filled_circle(green_center_x, center_y, radius, COLOR_GREEN);
    draw_filled_circle(blue_center_x, center_y, radius, COLOR_BLUE);

    // *((volatile uint32_t*)0x10000000) = 1;

    // clear_screen(COLOR_BLACK);
    // draw_filled_circle(green_center_x, center_y, radius, 0x1234ABCD);

    // *((volatile uint32_t*)0x10000000) = 1;

    while (1) {
        // Infinite loop to keep memory state intact for VDMA
    }

    return 0;
}