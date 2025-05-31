#include <hpdf.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE 1024

int main(int argc, char** argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s output.pdf\n", argv[0]);
        return 1;
    }

    HPDF_Doc pdf = HPDF_New(NULL, NULL);
    if (!pdf) {
        fprintf(stderr, "Error: Cannot create PDF document\n");
        return 1;
    }

    HPDF_Page page = HPDF_AddPage(pdf);
    HPDF_Page_SetSize(page, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT);

    const char* current_font = "Helvetica";
    float current_size = 12;
    float ypos = 750;  // Start near top of page (A4 is 842pt tall)
    float line_height = current_size * 1.2;
    
    char line[MAX_LINE];
    
    while (fgets(line, sizeof(line), stdin)) {
        char cmd[32];
        if (sscanf(line, "%31s", cmd) != 1) continue;
        
        if (strcmp(cmd, "FONT") == 0) {
            char font[64];
            float size;
            if (sscanf(line, "%*s %63s %f", font, &size) == 2) {
                current_font = strdup(font);
                current_size = size;
                line_height = current_size * 1.2;
            }
        }
        else if (strcmp(cmd, "TEXT") == 0) {
            char* text = line + 5;  // Skip "TEXT "
            
            HPDF_Page_BeginText(page);
            HPDF_Page_SetFontAndSize(page, 
                HPDF_GetFont(pdf, current_font, NULL),
                current_size);
            
            HPDF_Page_MoveTextPos(page, 50, ypos);
            HPDF_Page_ShowText(page, text);
            HPDF_Page_EndText(page);
            
            ypos -= line_height;
        }
        else if (strcmp(cmd, "PARAGRAPH") == 0) {
            ypos -= line_height * 0.5;  // Extra space for paragraph
        }
    }
    
    HPDF_SaveToFile(pdf, argv[1]);
    HPDF_Free(pdf);
    
    return 0;
}