# Reading the data into a data frame
df = read.csv("layoffs.csv")
head(df)
str(df) #489 obs. of  9 variables

# Now lets explore the data set, and clean and manipulate it as per requirements

# First lets change the name of the first column which is showing as "i..company"
colnames(df)[1] = "Company"
head(df)

# Lets convert the reported date from character to date
library(lubridate)
df$date = parse_date_time(df$reported_date, orders = c("mdy", "ymd", "dmy"))
df$date = as.Date(df$date)
str(df) 
class(df$date) # Now we have our date column
# Lets remove the existing reported_date and rename the new one
df = df[,-4]
colnames(df)[colnames(df) == "date"] <- "reported_date"
str(df)
# lets re position the column also
library(dplyr)
df <- df %>% 
  select(reported_date, everything()) %>% # Move the reported_date column to the beginning
  relocate(reported_date, .before = industry) # Move the reported_date column before the industry column
str(df) #Good to go


# Lets first change the variables from character to factors
df$industry = factor(df$industry)
df$status = factor(df$status)
str(df)
# But industry has 289 levels so some can be grouped together
table(df$industry)
# First I create vectors of industries based on common grounds
Tech = c("3D Printing","AI","AI, analytics","AI, big data","AI, coding","AI, enterprise software",
         "AI, image recognition","Analytics","analytics, SaaS","Artificial Intelligence",
         "Artificial intelligence, machine learning","Artificial Intelligence, Machine Learning",
         "artificial intelligence, robotics","automation, IT","Big data, cloud computing",
         "Big tech, internet services","CivicTech","CleanTech, energy","Cloud computing, IT",
         "Cloud computing, web hosting","Cloud Infrastructure","Cloud services, cybersecurity",
         "collaboration, enterprise software","Collaboration, productivity","Communications Infrastructure",
         "Conversational AI","CRM, enterprise software","CRM, IT","customer service, automation",
         "Cybersecurity","cybersecurity, cloud infrastructure","cybersecurity, cloud services",
         "Cybersecurity, enterprise software","cybsersecurity, predictive analytics",
         "Data Analytics","Data analytics, cloud services","data analytics, national defense",
         "data center, enterprise software","Data science, enterprise","Data storage",
         "developer APIs, enterprise software","Developer APIs, enterprise software",
         "DevOps","e-signature","Edtech","EdTech","edtech, artificial intelligence",
         "EdTech, IT","edtech, product management","Email Software","engineering, software",
         "Enterprise Communication","Enterprise Software","Enterprise software, customer service",
         "Enterprise software, e-commerce","Enterprise software, Management information systems",
         "enterprise software, productivity","enterprise software, SaaS","enterprise tech, analytics",
         "Identity verification","information technology","IoT","IT Infrastructure",
         "IT, future of work","IT, software","Legal Tech","mobile apps","Mobile Apps, Developer Tools",
         "Mobile Apps, Gaming","Natural Language Processing","Networking",
         "Networking, business development","Privacy Tech, Marketing Tech","Product Design",
         "Product design, apparel","Productivity software","Productivity Tools",
         "productivity, enterprise software","productivity, marketing","Productivity, task management",
         "Proptech","PropTech","proptech, advertising","Proptech, hospitality","PropTech, InsurTech",
         "Proptech, Real Estate","PropTech, Real Estate","Real Estate, PropTech","Robotics","robotics, AI",
         "Saas, analytics","Saas, APIs","SaaS, data","Saas, enterprise software",
         "SaaS, enterprise software","SaaS, meeting software","SecOps, security","Security",
         "security, enterprise software","Security, SaaS","Smart Home, Security","Software",
         "Software, Biotech","Software, Emails, API","Solar, Software",
         "Speech recognition, artificial intelligence","Surveillance","Telecommunication, wireless",
         "telecommunications, enterprise software","Video Conferencing Software","Visual collaboration, Apps",
         "WiFi, hardware")


Sales_Marketing = c("Adtech, digital marketing","Advertising platforms","AI, Sales","Business development",
                    "Content marketing","content marketing, advertising","Digital marketing",
                    "Digital Marketing","Marijuana, marketing","Marketing","Marketing Automation",
                    "Marketing tech","Marketing Tech","Marketing Tech, SMS Marketing",
                    "marketing, media","Marketing, software, SaaS","Sales tech","Sales Tech",
                    "SMS Marketing")

Media_Ent = c("Digital media, journalism","eSports, Media","Esports/Video Games","Gaming",
              "Media, Content Creators","Media, E-commerce","Media, news","Media, Sports",
              "media, streaming","Media, video editing","Media/entertainment","Media/Entertainment",
              "Music","News","News, media","Social media","Social Media","Social Media, Audio",
              "Social media, creator economy","video games","Video Games","Video Games, AR",
              "Video games, blockchain","Video production, marketing","Virtual Event",
              "Virtual Events")

E_Comm = c("Cloud computing, e-commerce","delivery, e-commerce","E-commerce","E-commerce, consumer lending",
           "E-commerce, Delivery","E-commerce, DTC","E-commerce, fashion","E-commerce, Logistics",
           "E-commerce, marketplace","e-commerce, retail","E-commerce, retail","E-commerce, SaaS",
           "E-commerce, ticketing","Ecommerce, Fashion","ecommerce, retail","Fashion, e-commerce",
           "Grocery, e-commerce, delivery service","retail, e-commerce","Retail, e-commerce")

Auto = c("Auto, E-commerce","automotive","Automotive, Ecommerce","Automotive, electric vehicles",
         "Autonomous vehicles","electric vehicle, transportation","Insurtech, transportation",
         "Transporation","Transporation, Logistics","Transportation")

Recruiting_HR = c("Artificial intelligence, recruiting","Career planning, social network",
                  "cryptocurrency","Cryptocurrency","cryptocurrency, blockchain",
                  "Cryptocurrency, blockchain","Cryptocurrency, FinTech","Employee Benefits, HR Tech",
                  "Enterprise applications, HR","hiring, HR","HR Tech","Human resources, recruiting",
                  "human resources, SaaS","Recruiting","social impact, company benefits",
                  "Talent marketplace")

Fintech = c("Blockchain, cryptocurrency","consumer lending, fintech","Crypto","Crypto, NFT marketplace",
            "Fintech","FinTech","Fintech, AI","Fintech, analytics","Fintech, banking","Fintech, Crypto",
            "fintech, data analytics","FinTech, loan repayments","Fintech, loans","fintech, money transfer",
            "Fintech, payments","fintech, personal finance","Fintech, proptech","FinTech, PropTech",
            "Fintech, SaaS","Fintech, software","Insurance, fintech","Insurtech","InsurTech",
            "Insurtech, cloud computing","Insurtech, fintech","Insurtech, machine learning",
            "social impact, finance")

Food_Agri = c("AgTech, food and beverage","food and beverage","food and beverage, e-commerce",
              "food and beverage, restaurants","Food delivery, ecommerce",
              "Food Tech, Software, Grocery Tech","Foodtech","indoor farming, agtech",
              "Restaurant Tech, Food Tech","Vertical farming")

Health = c("AI, health care","AR, health care","Cloud Infrastructure, health care","health care",
           "Health care","Health Care","health care, analytics","Health care, analytics",
           "Health Care, Biotech","health care, clinical trials","health care, cloud infrastructure",
           "health care, data collection","Health Care, Diagnostics","health care, health insurance",
           "Health care, nutrition","Health care, pharmaceuticals","Health care, predictive analytics",
           "health care, telehealth","health care, wellness","health diagnostics","Pediatrics, telehealth",
           "personal health, wellness","Pet tech, health care","pharmaceutical, health care",
           "Pharmacy, health care","telehealth","telehealth, wellness")



group_industry = function(industries){
  industries = as.character(industries)
  if(industries %in% Tech){
    return("Tech")
  }else if(industries %in% Sales_Marketing){
    return("Sales & Marketing")
  }else if(industries %in% Media_Ent){
    return("Media & Ent")
  }else if(industries %in% E_Comm){
    return("E-commerce")
  }else if(industries %in% Auto){
    return("Auto")
  }else if(industries %in% Recruiting_HR){
    return("Recruiting & HR")
  }else if(industries %in% Fintech){
    return("Fintech")
  }else if(industries %in% Food_Agri){
    return("Food & Agri")
  }else if(industries %in% Health){
    return("Health")
  }else{return("Other")}
}


df$industry = sapply(df$industry,group_industry)
table(df$industry)
str(df)

# Finally let's convert into factors
df$industry = factor(df$industry)
str(df)

# We can also drop the additional_notes column without any important data loss
df = df[,-9]
str(df)

# Now lets check for NA/missing values
library(Amelia)
missmap(df, col = c('yellow','black'), legend = F)
# But problem is though there are no 'NA' value, there are lot of entries in 
# total_layoffs and impacted_workforce_percentage columns marked as 'Unclear'
# Let's first identify them as NA
df$total_layoffs[df$total_layoffs == 'Unclear'] <- NA
df$impacted_workforce_percentage[df$impacted_workforce_percentage == 'Unclear'] <- NA


# Now lets get more insights using visualizations

library(ggplot2)

#1
# Let's check the trends of layoffs based on months
df$month_year = format(df$reported_date, "%B-%y")
str(df)
plot_1 = ggplot(df, aes(x = month_year, y= as.numeric(total_layoffs), fill = industry)) + geom_bar(stat="identity")+
  labs(x = "Month_Year", y= "Total Layoffs") + ggtitle("Total layoffs by month")
plot_1


#2
# Let's check layoffs by status, that is whether private or public sector employee
plot_2 = ggplot(df, aes(x = status, y= as.numeric(total_layoffs))) + 
  geom_bar(stat="identity", aes(fill = industry))+ labs(x = 'Status', y = 'Total_layoffs') + ggtitle("Total layoffs by Status")
plot_2

#3
# Now let's check layoffs by industry
plot_3 = ggplot(df, aes(x = "",y = as.numeric(total_layoffs), fill = industry)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  ggtitle("Pie chart of total layoffs by industry")+
  labs(x= '',y= 'Total layoffs')
plot_3

# It is clearly evident that the Tech industry was affected the most by layoffs
# So let's dig dipper in the Tech industry

#4
# Let's see which are the top 15 companies in Tech in terms of layoffs
top_15_tech <- df %>% 
  filter(industry == "Tech") %>% 
  arrange(desc(as.numeric(impacted_workforce_percentage))) %>% 
  head(15)
top_15_tech

top_15_tech$Company = factor(top_15_tech$Company)

plot_4 = ggplot(top_15_tech, aes(x = Company, y = as.numeric(impacted_workforce_percentage)))+
  geom_col(aes(fill = as.numeric(impacted_workforce_percentage))) + coord_flip()+
  ggtitle("Top 10 companies in Tech by percentage laid off")+
  labs(x = 'Company', y = 'Percenatge of employees laid off')
plot_4

##END##