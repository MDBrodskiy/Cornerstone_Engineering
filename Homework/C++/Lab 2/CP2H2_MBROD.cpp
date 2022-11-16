/*
 * ===============================================================
 *
 *       Filename:  CP2H2_MBROD.cpp
 *       Assignment: C++ Lab #2 Homework 2
 *       Title: Baby Name Counter
 *
 *    Description:  Takes in a file with popular baby names, and 
 *                  a name from the user, and compares it to the
 *                  file, printing a statement
 *
 *        Version:  1.0
 *        Created:  11/16/2022
 *       Revision:  none
 *       Compiler:  GCC
 *
 *         Author:  M.Brodskiy
 *
 * ===============================================================
 */

// -- Libraries & Directives --
#include <iostream> // Needed for normal cin & cout
#include <string>  // Needed to work with strings
#include <fstream> // Needed to read or write files on disk
using namespace std;

// PROGRAM CharacterSorter
int main() {
  // -- Declare Variables --
  ifstream infile; 
  // An input stream object for the text file data
  
  const int listLength = 105; // Variable for list length
  const int listWidth = 2; // Variable for list width
  int years[listLength]; // Variable containing years

  bool flag = false; // Variable to track if popular name
  
  string fileName(""); // Variable to track file name
  string babyName(""); // Variable to track baby name
  string nextMove(""); // Variable to control while loop
  string popNames[listLength][listWidth]; // 2D array for names

  // -- Main Program --
  //  Introduce Program to user
  cout << endl;
  cout << "  --- Baby Name Counter ---  " << endl;
  cout << " Loads a text file and then compares " << endl;
  cout << " it to an inputted baby name " << endl << endl;

  // Ask for file name
  cout << "Enter a File Name: ";
  cin >> fileName;
  cout << endl;

  // Open text file as an input stream
  infile.open(fileName); 

  // Check the file stream
  if (!infile) {
    // Provide user warning
    cout << "Warning: Unable to open file" << endl;
    // end program with error
    cout << "Exiting with Error" << endl;
    return 1;
  }

  infile.ignore(256, '\n'); // Skip first line with headers

  for (int i = 0; i < listLength; i++) {

      for (int j = listWidth; j >= 0; j--) { // Nested for loop                                                                                               to read in names from file to a 2D array

          if (j == 2) infile >> years[i]; // Add years to list
          else if (j == 1) infile >> popNames[i][0];
          // Read female name for year
          else { infile >> popNames[i][1];  }
          // Read male name for year
      
      }

  }

  do {

    // Ask for a baby name
    cout << "Enter a Baby Name: ";
    cin >> babyName;

    // Use nested for loop to read array contents
    for (int i = 0; i < listLength; i++) {

      for (int j = listWidth; j >= 0; j--) {

        if (j == 1 || j == 0) {

            if (babyName == popNames[i][j]) {

    // If inputted name matches a name in array, flag is true
                flag = true;
                break;
            
            }

        }

      }

    }

    cout << endl;

    // If the name is in array, say it was popular
    if (flag) cout << "The name " << babyName << " was popular"
        << " at least once in the last 100 years" << endl;
    // If the name is not in array, say it was not popular
    else { cout << "The name " << babyName << " was not popular"
        << " at least once in the last 100 years" << endl; }

    cout << endl;

    cout << "Run program again (yes/no)? ";
    cin >> nextMove;
    cout << endl;

    flag = false;

  } while (nextMove != "no");

} // ENDPROGRAM

