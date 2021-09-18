library(Amelia)
library(Hmisc)
library(heatmaply)
library("EnvStats")
library(Metrics)
library("e1071")





# Multiple Regression on SuperStore Dataset SampleSuperstore

setwd("F:/National College of Ireland/Data Mining and Machine learning/Final project dataset/Datasets copy/Superstore")

Superstore_data <- read.csv('F:/National College of Ireland/Data Mining and Machine learning/Final project dataset/Datasets copy/Superstore/SampleSuperstore.csv')

print(Superstore_data)
str(Superstore_data)
summary(Superstore_data)
names(Superstore_data)


##################### FINDING MISSING VALUES ##########################

sapply(Superstore_data,function(x) sum(is.na(x)))

# Graphical Representation of the missing values

#Visual representation of missing data
# mismap function draws the map of the missing value 
missmap(Superstore_data, main = "Missing values vs observed")




############ Converting the dataset values into numeric values to check the corelations#################3
str(Superstore_data)

################### Creating new Dataframe to store numeric values ###################
Superstore_numeric <- Superstore_data
names(Superstore_numeric)


#Droping columns in Dataframe

#Droping country column as it dnt have much significance 
Superstore_numeric <- Superstore_numeric[,-c(3)]
str(Superstore_numeric)


###########################################################33

Superstore_numeric$Ship.Mode <- as.numeric(Superstore_numeric$Ship.Mode)
Superstore_numeric$Segment <- as.numeric(Superstore_numeric$Segment)
Superstore_numeric$Country <- as.numeric(Superstore_numeric$Country)
Superstore_numeric$City <- as.numeric(Superstore_numeric$City)
Superstore_numeric$State <- as.numeric(Superstore_numeric$State)
Superstore_numeric$Postal.Code <- as.numeric(Superstore_numeric$Postal.Code)
Superstore_numeric$Region <- as.numeric(Superstore_numeric$Region)
Superstore_numeric$Category <- as.numeric(Superstore_numeric$Category)
Superstore_numeric$Sub.Category <- as.numeric(Superstore_numeric$Sub.Category)
Superstore_numeric$Quantity <- as.numeric(Superstore_numeric$Quantity)
str(Superstore_numeric)



#Checking correlations and printing heatmap


Superstore_numeric <- as.matrix(Superstore_numeric) #converting numeric dataframe in to matrix to print correlation


#Printing correlation matrix ###  Pearson coorelation ###########
correlation_matrix <- rcorr(Superstore_numeric, type="pearson") # type can be pearson or spearman
correlation_matrix


#### kendall correlation ##########
Heatmap_corr <- cor(Superstore_numeric, use="complete.obs", method="kendall") #Storing correlation matrix in dataframe
Heatmap_corr

heatmaply(Heatmap_corr, draw_cellnote = TRUE, cellnote_color = "auto") # heatmaps with labels






# Taking significant columns from correlation matrix
#   Ship mode , City, state, region, discount

#converting data in to factors to apply model
Superstore_data$Ship.Mode <- as.factor(Superstore_data$Ship.Mode)
Superstore_data$City <- as.factor(Superstore_data$City)
Superstore_data$State <- as.factor(Superstore_data$State)
Superstore_data$Region <- as.factor(Superstore_data$Region)
Superstore_data$Discount <- as.numeric(Superstore_data$Discount)
str(Superstore_data)


############   checking for outliers   ###################


#Package for Rosner Test 


################  Checking outliers for Discount #################



# Rosners test for outliers
outlier_Discount <- rosnerTest(Superstore_data$Discount, k=1000)
outlier_Discount
out_Discount <- boxplot.stats(Superstore_data$Discount)$out
out_Discount

#Discount rows in which outliers lie
out_rowD <- which(Superstore_data$Discount %in% c(out_Discount))
out_rowD

#Boxplot to print outliers with outliers values
boxplot(Superstore_data$Discount,
        ylab = "Discount", 
        main = "Boxplot for the Discount"
)
mtext(paste("Outliers: ", paste(out_Discount, collapse = ", ")))



#################### Checking outliers foR Quantity ###########################
boxplot(Superstore_data$Quantity,ylab="Quantity")$out
outlier_Quantity <- rosnerTest(Superstore_data$Quantity, k=1000)
outlier_Quantity
# There are only 30 outliers which wont be affecting the model




#########################  Checking outlier for Sales ###################################
boxplot(Superstore_data$Sales,ylab="Sales")$out
outlier_Sales <- rosnerTest(Superstore_data$Sales, k=1000)
outlier_Sales


# Sales rows in which outliers lie
out_rowS <- which(Superstore_data$Sales %in% c(out_Sales))
out_rowS

#Boxplot to print outliers with outliers values
boxplot(Superstore_data$Sales,
        ylab = "Sales",
        main = "Boxplot for the Sales"
)
mtext(paste("Outliers: ", paste(out_Sales, collapse = ", ")))


# Handling outliers for feature sales using log normalization
#sales
Superstore_data$Sales <- log(Superstore_data$Sales)
hist(Superstore_data$Sales)
outlier_Sales <- rosnerTest(Superstore_data$Sales, k=1000)
outlier_Sales
boxplot(Superstore_data$Sales)




############## Building model ######################

#Training model 
smp_size <- floor(0.75 * nrow(Superstore_data))
set.seed(123)
train_sup <- sample(seq_len(nrow(Superstore_data)), size = smp_size)



train <- Superstore_data[train_sup,]
test <- Superstore_data[-train_sup,]


###################  MULTIPLE LINEAR REGRESSION MODEL #############################

model_ML <- lm(Superstore_data$Sales ~ Superstore_data$Region
            + Superstore_data$Discount + Superstore_data$Quantity + Superstore_data$Category + Superstore_data$Sub.Category,data = Superstore_data)  

print(model_ML)
summary(model_ML)


#TEST
pred = predict(model_ML, newdata=test[10])
pred
summary(pred)

rmse_ML <-  rmse(pred, test$Sales)
rmse_ML
 

ML_nrmse <- nrmse(pred,test$Sales)
ML_nrmse


#Evaluation
actual <- Superstore_data$Sales
predicted <- pred
R2 <-1-(sum((predicted-actual)^2)/sum((actual-mean(actual))^2))
R2
summary(model_ML)$coefficient
cor(actual,pred)
qqnorm(model_ML$residuals)
qqline(model_ML$residuals)


qqnorm(actual)
qqline(predicted)



##################   SUPPORT VECTOR MACHINE REGRESSION ################################




model_SVM = svm(Superstore_data$Sales ~ Superstore_data$Region
             + Superstore_data$Discount + Superstore_data$Quantity + Superstore_data$Category + Superstore_data$Sub.Category,data = Superstore_data)
print(model_SVM)
summary(model_SVM)
#TEST

pred1 = predict(model_SVM, newdata=test[10])
pred1
summary(pred1)

#Evaluation
actual1 <- Superstore_data$Sales
predicted1 <- pred1
R2_SVM <- 1 - (sum((predicted1-actual1)^2)/sum((actual1-mean(actual1))^2))
R2_SVM

rmse_ML <-  rmse(pred1, test$Sales)
rmse_ML

Super_rmse <- nrmse(pred1, Superstore_data$Sales)
Super_rmse


cor(actual1, pred1)^2
qqnorm(model_SVM$residuals)
qqline(model_SVM$residuals)
qqnorm(actual1)
qqline(predicted1)
