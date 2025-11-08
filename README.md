
# CS50 - Problem Set 7: SQL Solutions

This repository contains my solutions for the SQL (Structured Query Language) problem set from Harvard's CS50x 2024 course.

## ⚠️ Important Database Dependency

The SQL files in this repository are **query solutions only**. They are designed to be executed against specific SQLite databases (`.db` files) provided by the CS50 course materials.

**The databases themselves are not included in this repository.**

To run, test, or validate these queries, you must first download the original distribution files for Problem Set 7 from the official CS50 course, which include:
* `songs.db`
* `movies.db`
* `fiftyville.db`


## Projects Included

### 1. Songs

This project involved writing 8 separate SQL queries to retrieve data from a database of Spotify songs (`songs.db`).

* **Files:** `1.sql` through `8.sql`
* **Description:** The queries range from simple `SELECT` statements (e.g., listing all song names) to more complex subqueries and `JOIN`s (e.g., finding the average energy of all songs by Post Malone, or finding songs that include a "feat.").

### 2. Movies

This project expanded on the concepts from "Songs" using a much larger IMDb database (`movies.db`). It required writing 13 SQL queries that involved complex `JOIN` operations across multiple tables (`movies`, `people`, `stars`, `directors`, `ratings`).

* **Files:** `1.sql` through `13.sql`
* **Description:** Queries included tasks such as finding the average rating of films from a specific year, listing all movies starring two specific actors (Johnny Depp and Helena Bonham Carter), and solving the "Six Degrees of Kevin Bacon" problem by finding all actors who co-starred in a movie with Kevin Bacon (born in 1958).

### 3. Fiftyville (The SQL Mystery)

This was a capstone SQL challenge to solve a fictional mystery: the theft of the CS50 duck. By querying the `fiftyville.db`, the goal was to identify the thief, the city they escaped to, and the accomplice who helped them.

* **`log.sql`:** This file is the core of the project. It contains the complete, commented sequence of SQL queries used to solve the mystery. It documents the entire thought process, from analyzing the initial crime scene report and witness interviews to cross-referencing ATM transactions, phone calls, bakery security logs, and flight manifests to narrow down the suspects.
* **`answers.txt`:** The final solution to the mystery, listing the thief, their escape city, and their accomplice.
