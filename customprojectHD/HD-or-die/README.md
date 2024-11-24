# Gym Tracker Program Documentation

## Overview

The Gym Tracker Program is a desktop application built using **Ruby**, **Gosu**, and **SQLite**. It helps users track their health-related data, view saved records, visualize data through diagrams, and check user rankings. The program is designed to provide real-time updates, efficient data processing, and an interactive interface.

---

## Features

1. **Data Input**

   - Users can input various health-related data (e.g., weight, steps, calories, etc.).
   - Data is immediately saved into an SQLite database.

2. **Data Viewing**

   - Users can view their saved data in tabular form.
   - Data can be filtered by categories, allowing users to focus on specific types of health metrics.

3. **Data Visualization**

   - A diagrammatic representation of the data is drawn using **Gosu** for better insights.
   - Users can visualize trends and patterns in their health progress.

4. **User Ranking**

   - Users are ranked based on specific health metrics.
   - The program implements a **merge sort algorithm** to rank users efficiently.

5. **Real-Time Updates**
   - Data updates in real-time using Ruby in combination with SQLite, ensuring accurate and up-to-date information.

---

## Technical Details

### **Programming Languages and Tools**

- **Ruby**: For backend logic and data processing.
- **Gosu**: For drawing diagrams and creating a graphical interface.
- **SQLite**: For data storage and real-time database management.

### **Key Implementations**

1. **Real-Time Update System**

   - Data entered by users is instantly stored in an SQLite database.
   - Updates to the database are reflected in the program without delays.

2. **Merge Sort Algorithm**

   - Used for efficient sorting of user data for filtering and ranking purposes.
   - Provides optimal performance, even with large datasets.

3. **Diagram Drawing with Gosu**
   - Gosu is utilized to create dynamic diagrams that visually represent user data.
   - This enhances user experience by offering graphical insights.

---

## How to Use the Program

1. **Start the Program**

   - Launch the application by running the main Ruby file (`main.rb`) in a terminal or Ruby IDE.

2. **Input Data**

   - Navigate to the input section to add health data.
   - Fields include metrics like weight, steps, calories, etc.

3. **View Saved Data**

   - Access the data viewing section to see all saved records.
   - Use category filters to refine the displayed information.

4. **Visualize Data**

   - Switch to the diagram view to see graphical representations of your progress.
   - The data is drawn in real time using Gosu.

5. **Check Rankings**
   - Navigate to the rankings section to view the leaderboard.
   - Rankings are determined by specific health categories, and sorting is optimized using the merge sort algorithm.

---

## Future Improvements

- **Additional Data Analysis**: Implement statistical analysis features like average, variance, and trends.
- **User Profiles**: Allow multiple users to maintain separate profiles.
- **Export Functionality**: Enable exporting of data and diagrams to CSV or PNG formats.
- **Mobile Compatibility**: Extend the application to mobile platforms.

---

## Team Member Contributions

- **Developer**: Sole programmer responsible for designing and implementing:
  - Real-time SQL update system with Ruby and SQLite.
  - Merge sort algorithm for efficient data ranking.
  - Diagram drawing functionality using Gosu.

---

## Dependencies

Ensure the following are installed on your system:

- **Ruby** (Version >= 2.5)
- **Gosu** (Install using `gem install gosu`)
- **SQLite3** (Install using `gem install sqlite3`)

---

## How to Install

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd health-program
   ```
