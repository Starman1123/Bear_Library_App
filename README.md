# Bear Library

## Authors
* Sheng Wang
* Shantanu Phadke
* Franklin Rice

## Purpose
* Bear Library allows users to search and add books and add them to their custom 
  book lists.
* They will be able to enter their own notes and see summaries and reviews from
  other users.


## Features
* Login/Logout
* User Profile
* New York Times Developer API Integration for book reviews
* OpenLibrary API Integration for book photos
* Rating system that lets users rate books in his lists
* Top book lists based on category

## Control Flow
The typical user will sign up for an account and browse the top lists of books. 
He will tap on a certain book and a detailed book view will be pushed to the top
of the view stack, showing a bigger picture of the book cover, summary, and
reviews from other users. The user can also add notes to books.

## Implementation

### Model
* Book.swift
* BookList.swift
* User.swift

### View
* TopBookListsTableView
* UserProfileTableView
* BookDetailTableView

### Controller
* TopBookListsTableViewController
* UserProfileTableViewController
* BookDetailTableViewController
