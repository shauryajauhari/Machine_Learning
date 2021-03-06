## Install the package and load the library

install.packages("neuralnet", 
                 repos = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/",
                 dependencies = TRUE)
library(neuralnet)


## Let us consider our example dataset
d1 <- iris
str(d1)

## Introduce a novel class definition.
## 0 signifies a leaf and 1, a flower.

d1$class <- as.integer(sample(c(0,1)))
str(d1$class)

## Remove the original classification of the flower type.
d1 <- d1[,-5]


# Min-Max normalization
d1$Sepal.Length <- (d1$Sepal.Length-min(d1$Sepal.Length, na.rm = T))/(max(d1$Sepal.Length, na.rm = T)-min(d1$Sepal.Length, na.rm = T))
d1$Sepal.Width <- (d1$Sepal.Width-min(d1$Sepal.Width, na.rm = T))/(max(d1$Sepal.Width, na.rm = T)-min(d1$Sepal.Width, na.rm = T))
d1$Petal.Length <- (d1$Petal.Length-min(d1$Petal.Length, na.rm = T))/(max(d1$Petal.Length, na.rm = T)-min(d1$Petal.Length, na.rm = T))
d1$Petal.Width <- (d1$Petal.Width-min(d1$Petal.Width, na.rm = T))/(max(d1$Petal.Width, na.rm = T)-min(d1$Petal.Width, na.rm = T))


# Let us shuffle the dataset for fair distribution of classes.
d2 <- d1[sample(nrow(d1)),]

# Data Partition
set.seed(108)
ind <- sample(2, nrow(d2), replace = TRUE, prob = c(0.7, 0.3))
training <- d2[ind==1,]
testing <- d2[ind==2,]

# Neural Networks
set.seed(007)
nn <- neuralnet(class~Sepal.Length+Sepal.Width+Petal.Length+Petal.Width,
               data = training,
               hidden = 5,
               err.fct = "sse",
               act.fct = "logistic",
               linear.output = FALSE)
plot(nn)

# Prediction
output <- compute(nn, training[,-5])
head(output$net.result)
head(training[1,])

# Node Output Calculations with Sigmoid Activation Function
in5 <- -0.27206 + (0.7777778*-6.9519)+(0.4166667*1.11426)+(0.8305085*1.25498)+(0.8333333*1.02952)
print(in5)
out5 <- (1/1+exp(-in5))
print(out5)

# Confusion Matrix & Misclassification Error - training data
output <- compute(nn, training[,-5])
p1 <- output$net.result
pred1 <- ifelse(p1>0.5, 1, 0)
tab1 <- table(pred1, training$class)
tab1
1-sum(diag(tab1))/sum(tab1)

# Confusion Matrix & Misclassification Error - testing data
output <- compute(n, testing[,-1])
p2 <- output$net.result
pred2 <- ifelse(p2>0.5, 1, 0)
tab2 <- table(pred2, testing$class)
tab2
1-sum(diag(tab2))/sum(tab2)


nn1 <- neuralnet(class~Sepal.Length+Sepal.Width+Petal.Length+Petal.Width,
                 data = training,
                 hidden = c(2,3),
                 err.fct = "ce",
                 act.fct = "logistic",
                 linear.output = FALSE)

nn2 <- neuralnet(class~Sepal.Length+Sepal.Width+Petal.Length+Petal.Width,
                 data = training,
                 hidden = 5,
                 err.fct = "ce",
                 act.fct = "logistic",
                 linear.output = FALSE,
                 lifesign='full',
                 rep=5)