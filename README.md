This explains how all of the scripts work and how they are connected

1) Retrieve data from Internet with given URL
2) Unpack data retrieved at step 1
3) Create objects holding the data that will be used (from 2)
4) Merge data from training and test sets (from 3)
5) Filter data for mean and standard deviations (from 4)
6) Apply activity names to data set (on 5)
7) Change variable names to appropriate descriptive info (on 6)
8) Organize data by activity and subject applying mean function
9) Write data from 8 to a file called data_tidy.txt
