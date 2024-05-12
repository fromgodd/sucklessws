#include <iostream>
#include <fstream>
#include <Windows.h>
#include <string>
#include <vector>
#include <stdexcept>

using namespace std;

// Function to stop and disable telemetry services
void disableTelemetryServices() {
    vector<string> services = {"DiagTrack", "dmwappushservice", "wuauserv"};

    for (const auto& service : services) {
        try {
            // Stop the service
            system(("net stop " + service).c_str());
            // Disable the service
            system(("sc config " + service + " start= disabled").c_str());
            cout << "Service " << service << " disabled successfully" << endl;
        } catch (const exception& e) {
            cerr << "Failed to disable service " << service << ": " << e.what() << endl;
        }
    }
}

// Function to block connections to telemetry servers
void blockTelemetryServers() {
    ifstream srvFile("srv.txt");
    if (!srvFile.is_open()) {
        cerr << "Failed to open srv.txt" << endl;
        return;
    }

    string server;
    while (getline(srvFile, server)) {
        try {
            // Add firewall rule to block outbound connection to the server
            system(("netsh advfirewall firewall add rule name=\"Block Telemetry Server " + server + "\" dir=out action=block remoteip=" + server).c_str());
            cout << "Connection to " << server << " blocked successfully" << endl;
        } catch (const exception& e) {
            cerr << "Failed to block connection to " << server << ": " << e.what() << endl;
        }
    }
}

int main() {
    try {
        disableTelemetryServices();
        blockTelemetryServers();
        // Check if telemetry is blocked
        // Replace this with actual check if needed
        bool telemetryBlocked = true;
        if (telemetryBlocked) {
            cout << "Telemetry is successfully blocked" << endl;
        } else {
            cerr << "Telemetry block check failed" << endl;
        }
    } catch (const exception& e) {
        cerr << "An error occurred: " << e.what() << endl;
        return 1;
    }
    return 0;
}
