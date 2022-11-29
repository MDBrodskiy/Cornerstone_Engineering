/*
 * ===============================================================
 *
 *       Filename:  CP3L1_MBROD.cpp
 *       Assignment: C++ Lab #3 Lesson 1
 *       Title: File Input Sorter (w/ Functions)
 *
 *    Description:  Takes in a file as an array of characters
 *    and sorts by ASCII values, using helper functions
 *
 *        Version:  1.1
 *        Created:  11/08/2022
 *       Revision:  11/29/2022
 *       Compiler:  GCC
 *
 *         Author:  M.Brodskiy
 *
 * ===============================================================
 */

// -- Libraries & Directives --
#include <iostream> // Needed for normal cin & cout
#include <fstream> // Needed to read or write files on disk
using namespace std;

void bubSort(char arr[100], int size) {

  // Sort array data using a common sorting method
  // Use Bubblesort
  // FOR j from 0 to     
  for (int j = 0; j < size; j++) {
    // Last j elements are already in place so
    // FOR k from      
    for (int k = 0; k < size - j; k++) {
      // If element is greater than the next
      if (arr[k] > arr[k + 1]) {
        // Switch their positions
        swap(arr[k], arr[k + 1]);
        // Pass by reference
      } // ENDIF
    } // ENDFOR
  } // ENDFOR

}

// PROGRAM CharacterSorter
int main() {
  // -- Declare Variables --
  ifstream infile; 
  // An input stream object for the text file data
  
  char arr[100];// An oversized array for the text characters


  int charCount = 0; // Keep track of number of characters




  // -- Main Program --
  //  Introduce Program to user
  cout << "  --- Character Sorter ---  " << endl;
  cout << " Loads a text file and then sorts " << endl;
  cout << " sorts its characters by ASCII value.  "                             << endl << endl;

  // Open text file as an input stream
  infile.open("CP2L2_MBROD.txt"); 


  // Check the file stream
  if (!infile) {
    // Provide user warning
    cout << "Warning: Unable to open file" << endl;
    // end program with error
    cout << "Exiting with Error" << endl;
    return 1;
  }
  
  // FOR each element in the array
  for (int i = 0; i < 100; i++) {
 
    // load character from file stream into array element
    infile >> arr[i];
    // Print array element to console
    cout << arr[i];

    if (infile.eof()) break;

    charCount++;
    
  }
  cout << endl;

  cout << "Completed import of " << charCount <<                                " characters." << endl;

  bubSort(arr, charCount); // Call the bubblesort by reference

  // Print sorted array
  // For each used element in the array (from 0 to n)
  for (int i = 0; i <= charCount; i++) {
    // Print array element to console
    cout << arr[i];
  } // ENDFOR
} // ENDPROGRAM

void swap(char& init, char& fin) { // Pass by ref

        char temp = init;
        init = fin;
        fin = temp; // Swap character positions
        
}

