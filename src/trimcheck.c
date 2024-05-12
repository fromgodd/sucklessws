
#include <stdio.h>
#include <windows.h>

// Function to set text color in console
void setConsoleTextColor(WORD color) {
    HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
    SetConsoleTextAttribute(hConsole, color);
}

int main() {
    // Run the "fsutil behavior query DisableDeleteNotify" command to check TRIM status
    FILE *fp;
    char output[128];
    int trimEnabled = -1;

    fp = _popen("fsutil behavior query DisableDeleteNotify", "r");
    if (fp == NULL) {
        printf("Failed to run command\n");
        return 1;
    }

    // Read the output from the command
    if (fgets(output, sizeof(output), fp) != NULL) {
        if (strstr(output, "DisableDeleteNotify = 0")) {
            trimEnabled = 1; // TRIM is enabled
        } else if (strstr(output, "DisableDeleteNotify = 1")) {
            trimEnabled = 0; // TRIM is disabled
        }
    }

    _pclose(fp);

    // Print the result with appropriate color
    if (trimEnabled == 1) {
        setConsoleTextColor(FOREGROUND_GREEN | FOREGROUND_INTENSITY); // Light green
        printf("TRIM is ENABLED.\n");
    } else if (trimEnabled == 0) {
        setConsoleTextColor(FOREGROUND_RED | FOREGROUND_INTENSITY); // Light red
        printf("TRIM is DISABLED.\n");
    } else {
        printf("Couldn't determine TRIM status.\n");
    }

    // Reset console text color to default
    setConsoleTextColor(FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);

    return 0;
}
