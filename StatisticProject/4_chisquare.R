#### 실습1 ####

str(mtcars)
head(mtcars)

### 주제 : 자동차의 실린더 수와 변속기의 관계가 있는지 알고 싶다.

# 실린더 수와 변속기 종류들을 파악
table(mtcars$cyl, mtcars$am)

# 테이블의 가독성을 높이기 위해 전처리
mtcars$tm <- ifelse(mtcars$am ==0, "auto", "manual")
result <- table(mtcars$cyl, mtcars$tm)
result

barplot(result)
barplot(result, ylim=c(0, 20))
barplot(result, ylim=c(0, 20), legend=rownames(result))

mylegend <- paste(rownames(result), "cyl")
mylegend
barplot(result, ylim=c(0, 20), legend=mylegend)

barplot(result, ylim=c(0, 20), legend=mylegend, beside=T)

barplot(result, ylim=c(0, 20), legend=mylegend, beside=T, horiz=T)

barplot(result, ylim=c(0, 20), legend=mylegend, beside=T, horiz=T,
        col=c("tan1", "coral2", "firebrick2"))

result
addmargins(result)

# 카이제곱 검정
chisq.test(result)

fisher.test(result)



#### 실습2 ####

mydata <- read.csv("../data/anova_two_way.csv")
str(mydata)
head(mydata)

### 주제 : ad_layer(시, 군, 구)와 multichild(다가구 자녀지원 조례)가 관계가 있는가?

mydata1 <- table(mydata$ad_layer, mydata$multichild)

chisq.test(mydata1)

fisher.test(mydata1)




#### 실습3 ####

install.packages("foreign")

library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)

raw_welfare <- read.spss("../data/Koweps_hpc10_2015_beta1.sav", to.data.frame = T)
welfare <- rename(raw_welfare, sex=h10_g3, birth=h10_g4, marriage=h10_g10, 
                  religion=h10_g11, income=p1002_8aq1, code_job=h10_eco9, 
                  code_region=h10_reg7)

welfare <- welfare[, c("sex", "birth", "marriage", "religion", "income",
                       "code_job", "code_region")]

str(welfare)
head(welfare)

### 주제 : 성별과 종교는 서로 연관성이 있는가?

result <- table(welfare$sex, welfare$religion)
chisq.test(result)




#### 실습4 : Cocran-Armitage Trend Test ####

library(moonBook)
str(acs)

### 주제 : 흡연여부와 고혈압의 유무가 서로 관련이 있는가?

table(acs$HBP, acs$smoking)

acs$smoking <- factor(acs$smoking, levels=c("Never", "Ex-smoker", "Smoker"))
result <- table(acs$HBP, acs$smoking)
result

chisq.test(result)

?prop.trend.test
# x : 사건이 발생한 횟수
# n : 시도한 횟수

# 고혈압이 발생한 사람의 수(x)
result[2, ]

# smoking 시도 횟수(n)
colSums(result)

prop.trend.test(result[2,], colSums(result))

mosaicplot(result)
mosaicplot(result, col=c("tan1", "firebrick2", "coral2"))

colors()
demo("colors")

mosaicplot(t(result), col=c("tan1", "firebrick2", "coral2"))

mosaicplot(t(result), col=c("tan1", "firebrick2", "coral2"),
           xlab="Smoking", ylab="Hypertension")


mytable(smoking ~ age, data=acs)




