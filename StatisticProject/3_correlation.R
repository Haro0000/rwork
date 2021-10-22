#### 실습1 ####
# 주제 : 담배값 인상 전의 월별 매출액과 인상 후의 월별 매출액의 관계가 있는가?
# 담배값과 매출액이 관계가 있는가?

x <- c(70, 72, 62, 64, 71, 76, 0, 65, 75, 72)
y <- c(70, 74, 65, 68, 72, 74, 61, 66, 76, 75)

cor(x, y, method="pearson")
cor(x, y, method="spearman")
cor(x, y, method="kendal")

cor.test(x, y, method="pearson")





#### 실습2 #####
# pop_growth : 인구 증가율
# elderly_rate : 65세 이상 노령인구 비율
# finance : 재정 자립도
# cultural_center : 인구 10만명 당 문화기반 시설 수

mydata <- read.csv("../data/cor.csv")
str(mydata)
head(mydata)  

# 주제 : 인구 증가율과 노령인구 비율간의 관계가 있는가?
plot(mydata$pop_growth, mydata$elderly_rate)

cor(mydata$pop_growth, mydata$elderly_rate)  
  
x <- cbind(mydata$pop_growth, mydata$elderly_rate, mydata$finance, mydata$cultural_center) 
cor(x)
  
  
  
 
  
#### 실습3 #####

install.packages("UsingR")
library(UsingR)

str(galton)

plot(galton$parent, galton$child, data=galton)
plot(child ~ parent, data=galton)

cor.test(galton$child, galton$parent)

plot(jitter(child, 5) ~ jitter(parent, 5), data=galton)

sunflowerplot(galton)

install.packages("SwissAir")
library(SwissAir)

View(AirQual)

Ox <- AirQual[ , c("ad.O3", "lu.O3", "sz.O3")] + 
  AirQual[ , c("ad.NOx", "lu.NOx", "sz.NOx")] -
  AirQual[ , c("ad.NO", "lu.NO", "sz.NO")]

names(Ox) <- c("ad", "lu", "sz")

plot(lu ~ sz, data=Ox)

install.packages("hexbin")
library(hexbin)

plot(hexbin(Ox$lu, Ox$sz, xbins=50))

smoothScatter(Ox$lu, Ox$sz)

install.packages("IDPmisc")
library(IDPmisc)
iplot(Ox$lu, Ox$sz)
