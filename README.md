# GetirTodo

## General Explanation
### Usage
- Add Category of Todo to your list as musch as you want
- Then click now, you can add many Todo item related with Category.
- If you have done any item in your Todo list, click to mark as check mark.
- If you have many task in your Todo list, use search bar.
- Otherwise if you don't want to see any items anymore, just swipe left to delete it.
- Also you can delete Category with left swipe gesture.
- When you want to update your Category or Item title, press long on it, update pop up will be revealed.

### Structure
- I used MVC as default design pattern
- I devided Constants, Extension, Enumeration, protocols as much as possible.
- I added an appropriate Logger
- I devided groups with related files.
- I added search bar to find desire task easy.
- I added case diacritic sensitive filter to search bar.
- I added comment as much as possible, rather I prefered well designed function and property names.
- I foced CRUD with protocol
- I used Realm as persistent database
- I try to avoid retain cycle, and cared variables reference count.
- I try to avoid massive ViewController. So, I devided function with related extensions.
- I try to make simple UI as much as possible.
- I didn’t add any UI or UT tests
- Finally, I added two demo to demonstrate my work. ->

Quick Demo                 |  Search Bar Demo
:-------------------------:|:-------------------------:
![](quick_demo.gif)  |  ![](search_bar_quick_demo.gif)

