Codebook
================

Variables
---------

There are 11 variables in the tidy\_data dataset

1 activityid
============

A total of six activities:

1 lying
2 sitting
3 standing
4 walkdownstair
5 walking
6 walkupstair

2 subjectid
===========

Thirty subjects used to generate data numbered 1-30

3 domain
========

Showing whether features calculated in time or frequency domain represented by:

1 Time
2 Freq

4 accelerationtype
==================

For accelerometer readings two types:

1 Body
2 Gravity
And for gyrometer readings set to NA

5 instrument
============

Two instruments used for generating data

1 Accelerometer
2 Gyrometer

6 jerk
======

Showing whether it is a jerk signal. Has two values:

1 Jerk
2 NA, when it is not a jerk signal

7 euclideanmag
==============

Shows whether the magnitudes of the particular readings have been calculated using the Euclidean norm-represented by 'Mag'. Has two values:

1 Mag
2 NA

8 variable
==========

shows whether its a mean or standard deviation of the particular feature.

1 Mean
2 SD

9 direction
===========

For readings which are 3-axial, shows the direction. Otherwise set to NA

1 X
2 Y
3 Z
4 NA

10 occurance
============

number of grouped values used to calculate average(in last column)

11 average
==========

mean value of the set of grouped features. occurance shows how many times the set of grouped features shows up in the data provided and this column shows their mean vaue.
