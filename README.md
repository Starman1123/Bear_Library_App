# Bear Library

## Authors
* Sheng Wang
* Shantanu Phadke
* Franklin Rice

## Purpose
* Bear Library allows users to search and add books and add them to their custom <br />
  book lists.
* Users can also click on the appropriate links and buy their favorite books from <br />
  from Amazon.
* Once a user has finished reading a book in their library, they can delete it.


## Features
* Use of Core Data, to make persistent
* Top book lists based on category (fiction/non-fiction)
* Ability to click on a book, and see a more detailed view
* Ability to search for specific book(s) and add into library
* Ability to delete books from library via left swipe
* Doesn't let user add book already in library

## Control Flow
The typical user can browse the top lists of books. <br />
He will tap on a certain book and a detailed book view will be pushed to the top <br />
of the view stack, showing a bigger picture of the book cover, summary, and <br />
a link to the book on Amazon. The user can also delete books from their library.<br />

## Implementation

### Model
* BLBook.swift
* Utility.swift

### View
* PopularView
* BookDetailView
* LibraryView
* SearchView

### Controller
* PopularViewController
* BookDetailViewController
* LibraryViewController
