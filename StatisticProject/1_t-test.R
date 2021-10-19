#### Power Analysis ####
# cohen's d (effective size) : 두 집단의 평균 차이를 두 집단의 표준편차의 합으로 나눠준다.

ky <- read.csv("../data/KY.csv", header=T)
View(ky)

table(ky$group)

mean.1 <- mean(ky$score[which(ky$group==1)])
mean.2 <- mean(ky$score[ky$group==2])
cat(mean.1, ", ", mean.2)

sd.1 <- sd(ky$score[ky$group==1])
sd.2 <- sd(ky$score[ky$group==2])
cat(sd.1, ", ", sd.2)

effective_size <- abs(mean.1 - mean.2) / sqrt((sd.1^2 + sd.2^2) / 2)
print(effective_size)

install.packages("pwr")
library(pwr)
?pwr.t.test

pwr.t.test(d=effective_size , alternative="two.sided" , type="two.sample", 
           power=.8, sig.level=.05)





#### 사례1 : 두 집단의 평균 비교 ####

install.packages("moonBook")
library(moonBook)

# 경기도에 소재한 대학병원에서 2년동안 내원한 급성 관상동맥증후군 환자 데이터
?acs
head(acs)
str(acs)
summary(acs)

### 가설 설정
# 주제 : 두 집단(남성, 여성)의 나이 차이를 알고 싶다.
# 귀무 가설 : 남성과 여성의 평균 나이에 대해 차이가 없다.
# 대립 가설 : 남성과 여성의 평균 나이에 대해 차이가 있다.

mean.man <- mean(acs$age[acs$sex == "Male"])
mean.woman <- mean(acs$age[acs$sex == "Female"])
cat(mean.man, mean.woman)

# 정규 분포 여부
moonBook::densityplot(age ~ sex, data=acs)

# 가설 설정 주제 : 두 집단의 정규분포 여부를 알고 싶다
# 귀무가설 : 두 집단이 정규분포이다.
# 대립가설 : 두 집단이 정규분포가 아니다.
shapiro.test(acs$age[acs$sex == "Male"])
shapiro.test(acs$age[acs$sex == "Female"])

# 등분산 여부 가설 설정
# 주제 : 두 집단의 등분산 여부를 알고 싶다
# 귀무가설 : 두 집단이 등분산이다.
# 대립가설 : 두 집단이 등분산이 아니다.
var.test(age ~ sex, data=acs)


### 가설 검정

# MWW Test
wilcox.test(age ~ sex, data=acs)

# t-test
?t.test
t.test(age ~ sex, data=acs, alt="two.sided", var.equal=T)

# welch's t-test
t.test(age ~ sex, data=acs, alt="two.sided", var.equal=F)




#### 사례2 : 집단이 한개인 경우 ####

### 가설 설정
# 주제 : A회사의 건전지 수명이 1000시간일 때, 무작위로 뽑아 10개의 건전지 수명에 대해
#       샘플이 모집단과 다르다고 할 수 있는가?
# 귀무가설 : 표본의 평균은 모집단의 평균과 같다.
# 대립가설 : 표본의 평균은 모집단의 평균과 다르다.

sample <- c(980, 1008, 968, 1032, 1012, 1002, 996, 1017, 990, 955)
mean.sample <- mean(sample)
mean.sample

# 정규분포
shapiro.test(sample)

### 가설 검정
t.test(sample, mu=1000, alt="two.sided")
t.test(sample, mu=1000, alt="less")
t.test(sample, mu=1000, alt="greater")

### 가설 설정
# 주제 : 어떤 학급의 수학 평균 성적이 55점이었다.
#       0교시 수업을 하고 다시 성적을 살펴보았다.
# 귀무가설 : 표본의 평균은 모집단의 평균과 같다.
# 대립가설 : 표본의 평균은 모집단의 평균과 다르다.

sample2 <- c(58, 49, 39, 99, 32, 88, 62, 30, 55, 65, 44, 55, 57, 53, 88, 42, 39)
mean(sample2)

shapiro.test(sample2)

t.test(sample2, mu=55, alt="two.sided")
t.test(sample2, mu=55, alt="less")
t.test(sample2, mu=55, alt="greater")






#### 사례3 : Paired Sample T - test ####

str(sleep)
print(sleep)

### 가설 설정
# 주제 : 같은 집단에 대해 수면시간의 증가량 차이가 나는지 알고싶다.

sleep2 <- sleep[, -3]
sleep2

# 두 집단의 수면 증가량 평균은?
tapply(sleep2$extra, sleep2$group, mean)

# 정규분포 여부
with(sleep2, shapiro.test(extra[sleep2$group == 1]))
with(sleep2, shapiro.test(extra[sleep2$group == 2]))

# 등분산
var.test(extra ~ group, data=sleep2)

### 가설 검정
t.test(extra ~ group, data=sleep2, paired=T, var.equal=T)

### 그래프로 확인
before <- subset(sleep2, group==1, extra)
before

after <- subset(sleep2, group==2, extra)
after

s_graph1 <- cbind(before, after)
s_graph1

install.packages("PairedData")
library(PairedData)

s_graph2 <- paired(before, after)
s_graph2

plot(s_graph2, type="profile") + theme_bw()




#### 실습1 ####
# dummy : 0은 군을 나타내고 1은 시를 나타낸다.
# 주제 : 시와 군에 따라서 합계 출산율의 차이가 있는지 알아보려고 한다.
# 귀무가설 : 차이가 없다
# 대립가설 : 차이가 있다.

mydata <- read.csv("../data/independent.csv")
mydata
str(mydata)

gun.mean <- with(mydata, mean(birth_rate[dummy == 0]))
si.mean <- with(mydata, mean(birth_rate[dummy == 1]))
cat(gun.mean, si.mean)

with(mydata, shapiro.test(birth_rate[dummy==0]))
with(mydata, shapiro.test(birth_rate[dummy==1]))

wilcox.test(birth_rate ~ dummy, data=mydata)

t.test(birth_rate ~ dummy, data=mydata)



#### 실습2 ####
# 주제 : 오토(am=0)나 수동(am=1)에 따라 연비(mpg)가 같을까? 다를까?

str(mtcars)
head(mtcars)

auto.mean <- with(mtcars, mean(mpg[am == 0]))
man.mean <- with(mtcars, mean(mpg[am == 1]))
cat(auto.mean, man.mean)

with(mtcars, shapiro.test(mpg[am == 0]))
with(mtcars, shapiro.test(mpg[am == 1]))

var.test(mtcars[mtcars$am == 1, 1], mtcars[mtcars$am == 0, 1])

t.test(mpg ~ am, data=mtcars, var.equal=T, alt="two.sided")
t.test(mpg ~ am, data=mtcars, var.equal=T, alt="less")
#t.test(mpg ~ am, data=mtcars, var.equal=T, alt="greater")



#### 실습3 ####
# 주제 : 쥐의 몸무게가 전과 후의 차이가 있는지 없는지 알고싶다.

data <- read.csv("../data/pairedData.csv")
data

?shapiro.test

shapiro.test(data$before)
shapiro.test(data$After)

t.test(data$before, data$After, paired = T)

# long형으로
library(reshape2)

data1 <- melt(data, id="ID", variable.name="GROUP", value.name="RESULT")
data1

# 또 다른 long형 변경 방법
install.packages("tidyr")
library(tidyr)
data2 <- gather(data, key="GROUP", value="RESULT", -ID)
data2


shapiro.test(data1$RESULT[data1$GROUP == "before"])              
shapiro.test(data1$RESULT[data1$GROUP == "After"])              

t.test(RESULT ~ GROUP, data=data1, paired=T)

# 그래프
library(PairedData)
before <- data$before
after <- data$After
s_graph <- paired(before, after)
plot(s_graph, type="profile") + theme_bw()

library(moonBook)
moonBook::densityplot(RESULT ~ GROUP, data=data1)




#### 실습4 ####
# 주제 : 시별로 2010년도와 2015년도의 출산율 차이가 있는가?

data <- read.csv("../data/paired.csv")
data

data1 <- gather(data, key="GROUP", value="RESULT", -c(ID, cities))
data1

with(data1, shapiro.test(RESULT[GROUP=="birth_rate_2010"]))
with(data1, shapiro.test(RESULT[GROUP=="birth_rate_2015"]))

wilcox.test(RESULT ~ GROUP, data=data1, paired=T)

t.test(RESULT ~ GROUP, data=data1, paired=T)



#### 실습5 ####
# https://www.kaggle.com/kappernielsen/independent-t-test-example
# 주제1 : 남녀별로 각 시험에 대해 평균차이가 있는지 알고싶다.
# 주제2 : 같은 사람에 대해서 성적차이가 있는지 알고 싶다.(첫번째 시험(G1), 세번째 시험(G3))

mat <- read.csv("../data/student-mat.csv", header=T)
head(mat)
str(mat)
summary(mat$G1)
summary(mat$G2)
summary(mat$G3)
table(mat$sex)

library(dplyr)
mat %>% select(sex, G1, G2, G3) %>% group_by(sex) %>%
  summarise(mean_g1=mean(G1), mean_g2=mean(G2), mean_g3=mean(G3),
            cnt_g1=n(), cnt_g2=n(), cnt_g3=n(),
            sd_g1=sd(G1), sd_g2=sd(G2), sd_g3=sd(G3))

shapiro.test(mat$G1[mat$sex == "M"])
shapiro.test(mat$G1[mat$sex == "F"])

shapiro.test(mat$G2[mat$sex == "M"])
shapiro.test(mat$G2[mat$sex == "F"])

shapiro.test(mat$G3[mat$sex == "M"])
shapiro.test(mat$G3[mat$sex == "F"])

var.test(G1 ~ sex, data=mat)
var.test(G2 ~ sex, data=mat)
var.test(G3 ~ sex, data=mat)

wilcox.test(G1 ~ sex, data=mat)
wilcox.test(G2 ~ sex, data=mat)
wilcox.test(G3 ~ sex, data=mat)

t.test(G1 ~ sex, data=mat, var.equal=T, alt="two.sided")
t.test(G2 ~ sex, data=mat, var.equal=T, alt="two.sided")
t.test(G3 ~ sex, data=mat, var.equal=T, alt="two.sided")

t.test(G1 ~ sex, data=mat, var.equal=T, alt="less")
t.test(G2 ~ sex, data=mat, var.equal=T, alt="less")
t.test(G3 ~ sex, data=mat, var.equal=T, alt="less")

# 두번째 주제
library(tidyr)
mydata <- gather(mat, key="GROUP", value="RESULT", "G1", "G3")
View(mydata)

t.test(mydata$RESULT ~ mydata$GROUP, data=mydata, paired=T)

mat %>% select(G1, G3) %>% summarise(mean_g1=mean(G1), mean_g3=mean(G3))

wilcox.test(mydata$RESULT ~ mydata$GROUP, data=mydata, paired=T)

t.test(mydata$RESULT ~ mydata$GROUP, data=mydata, paired=T, alt="greater")

t.test(mat$G1, mat$G3, paired=T)






