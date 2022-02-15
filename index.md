
CS 424 - Project Page
Gautam Kushwah





Text can be **bold**, _italic_, or ~~strikethrough~~.

# Important Links

[Link to Shiny App for Project 1](https://gautam-kushwah.shinyapps.io/424project1/)

### Resources

[Link to another page](./another-page.html)


[link to Video Walkthrough](https://www.youtube.com/)

There should be whitespace between paragraphs.

There should be whitespace between paragraphs. We recommend including a README, or a file with information about your project.

# Introduction

This is an app made using R studio and Shiny, the links to which have been provided above.

### What is R?

R is a programming language for statistical computing and graphics supported by the R Core Team and the R Foundation for Statistical Computing


### What is Shiny?

Shiny is an R package that makes it easy to build interactive web apps straight from R. You can host standalone apps on a webpage or embed them in R Markdown documents or build dashboards


### Purpose of this App

The purpose of this app is to use the data provided on riders on the Chicago L over the past 20 years and use shiny to give people an interactive interface to create those visualizations. The app provides various data visualizations in the form of bar graphs breaking down data across all years, individual years, months, and even days in a week over a month.

It shows interesting trends and helps understand the user the behavior of the riders on the Chicago which in turn could be explained by various events occurring at the same time.

The app could also help find interesting dates in the last 20 years which might have affected the behavior of the riders and thus help us understand the power of data and data visualization.

### How to use the App?

You can head over to the app here. Upon opening the app, you would be greeted with a Shiny dashboard which would give you various bar charts. 

The screen in divided into 3 parts:
1. The Side Bar: This has navigation controls and data input controls for the charts on right hand side of the screen
2. Left Region: This shows various bar charts for station one, which by default is UIC-Halsted.
3. Right Region: This shows various bar charts for station two, which by default is O’Hare Airport.

[!Link to image if not rendered](https://drive.google.com/file/d/15a20v0eG29fKueH79qzyFh6lcrEeDG6G/view?usp=sharing)
![image](./image.png)

The user can compare the same station on both sides across different times using the dropdown menus in the side bar






## Header 2

> This is a blockquote following a header.
>
> When something is important enough, you do it even if the odds are not in your favor.

# About the Data


The data was obtained from Chicago Data portal, the link to the data could be found [!here](https://data.cityofchicago.org/Transportation/CTA-Ridership-L-Station-Entries-Daily-Totals/5neh-572f)

This list shows daily totals of ridership, by station entry, for each 'L' station dating back to 2001. Dataset shows entries at all turnstiles, combined, for each station.

The data consists of 5 columns and about 1.09 million rows.

The columns are as follows
**station_id** - Unique ID for a station
**stationname** - The name of the station
**date** - The date of the entries
**daytype** - W=Weekday, A=Saturday, U=Sunday/Holiday
**rides** - total number of ridership on that date


The date was provided in a chr format, therefore it had to be converted into a usable format which was achieved through a R library called **lubridate**

The data was downloaded in tsv format, since the free version of Shiny allows us to only work with files which are <5 mb, I used shell script to break it down into smaller files using shell and the following command

```
split -b <size in kb> <filename> <name of parts>
```

The <name of parts> signifies what the broken down files would be named.


I then used a code editor to verify if the files were broken down correctly, and upon verifying that I loaded the filenames in a list in R and then stitched them together into a single table, hence being able to work with all the rows.


The next step included breaking down the entire dataset into three individual data sets, each based on the stations I was interested in. For this project, I used three stations namely : **UIC-Halsted**, **O’Hare Airport** and one closest to which I live i.e **Polk**.

Each dataset had to grouped by three criterias:
1. Years
2. Months in that year
3. Days in that Month

Each of which was done dynamically using the choices provided by the user using reactive elements in R.
I used the library **dplyr** for chaining/piping commands and R commands such as “subset” and “group_by” to get the subset of data based on the station and then group that data based on days, months or years, respectively.





# Github


# Observation and Inferences 
### Header 3

```js
// Javascript code with syntax highlighting.
var fun = function lang(l) {
  dateformat.i18n = require('./lang/' + l)
  return true;
}
```

```ruby
# Ruby code with syntax highlighting
GitHubPages::Dependencies.gems.each do |gem, version|
  s.add_dependency(gem, "= #{version}")
end
```

#### Header 4

*   This is an unordered list following a header.
*   This is an unordered list following a header.
*   This is an unordered list following a header.

##### Header 5

1.  This is an ordered list following a header.
2.  This is an ordered list following a header.
3.  This is an ordered list following a header.

###### Header 6

| head1        | head two          | three |
|:-------------|:------------------|:------|
| ok           | good swedish fish | nice  |
| out of stock | good and plenty   | nice  |
| ok           | good `oreos`      | hmm   |
| ok           | good `zoute` drop | yumm  |

### There's a horizontal rule below this.

* * *

### Here is an unordered list:

*   Item foo
*   Item bar
*   Item baz
*   Item zip

### And an ordered list:

1.  Item one
1.  Item two
1.  Item three
1.  Item four

### And a nested list:

- level 1 item
  - level 2 item
  - level 2 item
    - level 3 item
    - level 3 item
- level 1 item
  - level 2 item
  - level 2 item
  - level 2 item
- level 1 item
  - level 2 item
  - level 2 item
- level 1 item

### Small image

![Octocat](https://github.githubassets.com/images/icons/emoji/octocat.png)

### Large image

![Branching](https://guides.github.com/activities/hello-world/branching.png)


### Definition lists can be used with HTML syntax.

<dl>
<dt>Name</dt>
<dd>Godzilla</dd>
<dt>Born</dt>
<dd>1952</dd>
<dt>Birthplace</dt>
<dd>Japan</dd>
<dt>Color</dt>
<dd>Green</dd>
</dl>

```
Long, single-line code blocks should not wrap. They should horizontally scroll if they are too long. This line should be long enough to demonstrate this.
```

```
The final element.
```
