# Welcome

Welcome to the book [Biomedical Data Science - an introduction with case studies](). 
Most contents are demonstrated with R programming language.

This book is designed designed as a collection of R Markdown notebooks, as 
supplementary to the lecture notes for the course 
[BIOF1001: Introduction to Biomedical Data Science](),
an undergraduate course (Year 1) at the University of Hong Kong.


## Source files and re-build:
you can find the source files on GitHub
[StatBiomed/BMDS-book](https://github.com/StatBiomed/BMDS-book).

To build this book from the source files, use the following script in R:
```
bookdown::render_book("index.Rmd", "bookdown::gitbook")
```

To release the build, you can simply copy the whole contents in the `_book` 
folder to the `docs` folder and push it to this github repository.
