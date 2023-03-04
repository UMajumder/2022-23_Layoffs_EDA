# 2022-23_Layoffs_EDA
In this project I tried to find insights about the massive worldwide layoffs during the later half of 2022 and beginning of 2023 using R.

I have used this following dataset available on Kaggle for my work:https://www.kaggle.com/datasets/salimwid/technology-company-layoffs-20222023-data

The data cocnists of layoff detals since 2022, and consists of the following variables:

Company: Name of the company

Total Layoffs: Total number of employees laid off

impacted workforce percentage: Percentage of total employees laid off

reported date: reported date of layoff

industry: The industry/industries the company operates in

headquarter location: Place where the company's headquarter is located

sources: Source from which the layoff data is obtained from

status: whether the company is a public or a private company

additional notes

Libraries used: lubridate, dplyr, Amelia, ggplot2

First I did some data cleaning and feature engineering like converting the dates from character to dates, changing variables from character to factors, grouping them based on based on common grounds where there were too many levels, etc.

After making sure that the data is ready to work with, I tried finding answers to some questions visually

#Firstly what was the trend of layoffs based on months
![Layoffs by month](https://github.com/UMajumder/2022-23_Layoffs_EDA/blob/main/PLOT_1.png?raw=true)

#Then I checked the trend of layoffs by status, that is whether private or public sector employee
![Layoffs by status](https://github.com/UMajumder/2022-23_Layoffs_EDA/blob/main/PLOT_2.png?raw=true)

#Which industry was affected the most
![Most affected industry](https://github.com/UMajumder/2022-23_Layoffs_EDA/blob/main/PLOT_3.png?raw=true)

#Which were the top 15 companies in the Tech industry, which was clearly affected the most
![Top tech companies by layoffs](https://github.com/UMajumder/2022-23_Layoffs_EDA/blob/main/PLOT_4.png?raw=true)
