/*
 * ===============================================================
 *
 *       Filename:  CP0L1_MBROD.cpp
 *       Assignment: C++ Lab #0 Part 1
 *       Title: Introduction
 *
 *    Description:  Introductory C++ script
 *
 *        Version:  1.0
 *        Created:  10/26/2022
 *       Revision:  none
 *       Compiler:  GCC
 *
 *         Author:  M.Brodskiy
 *
 * ===============================================================
 */

#include <iostream> // Needed to communicate with console window
#include <ctime> // For time functions

int main() {

    std::cout << "Hello, World!" << std::endl; // Print to 
    std::time_t now = std::time(0); // Get Current Timestamp
    char* dt = std::ctime(&now); // Convert it to characters
    std::cout << "The local date and time is: " << dt << std::endl;
    return 0;

}
