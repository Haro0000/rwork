#### 사례1 : one way anova ####

library(moonBook)
View(acs)
str(acs)

# LDLC : 저밀도 콜레스테롤 수치 : 결과변수
# Dx(진단 결과) : STEMI(급성심근경색), NSTEMI(만성심근경색), unstable angina(협심증) : 원인변수

moonBook::densityplot(LDLC ~ Dx, data=acs)

table(acs$Dx)

# 정규분포 
with(acs, shapiro.test(LDLC[Dx=="NSTEMI"]))
with(acs, shapiro.test(LDLC[Dx=="STEMI"]))
with(acs, shapiro.test(LDLC[Dx=="Unstable Angina"]))

# 정규분포를 확인하는 또 다른 방법
out = aov(LDLC ~ Dx, data=acs)
out
shapiro.test(resid(out))

# 등분산 여부
bartlett.test(LDLC ~ Dx, data=acs)

# anova 검정(정규분포이고 등분산일 경우)
out = aov(LDLC ~ Dx, data=acs)
summary(out)

# 연속변수가 아니거나 정규분포가 아닐 경우
kruskal.test(LDLC ~ Dx, data=acs)

# 등분산이 아닐 경우
oneway.test(LDLC ~ Dx, data=acs, var.equal = F)

### 사후 검정

# aov()를 사용했을 경우 : TukeyHSD()
TukeyHSD(out)

# kruskal.test()를 사용한 경우
install.packages("pgirmess")
library(pgirmess)

kruskalmc(acs$LDLC, acs$Dx)

# oneway.test()를 사용했을 경우
install.packages("nparcomp")
library(nparcomp)

result <- mctp(LDLC ~ Dx, data=acs)
summary(result)


#### 실습1 ####

head(iris)
table(iris$Species)
str(iris)

# 주제 : 품종별로 Sepal.Width의 평균차이가 있는가?
# 만약 있다면 어느 품종과 차이가 있는가?

# 정규분포 여부
out <- aov(Sepal.Width ~ Species, data=iris)
shapiro.test(resid(out))

# 등분산 여부
bartlett.test(Sepal.Width ~ Species, data=iris)

# anova 검정
summary(out)

# 사후 검정
TukeyHSD(out)

library(ggplot2)
ggplot(iris, aes(Sepal.Length, Sepal.Width)) + geom_point(aes(colour=Species))

#### 실습2 ####

mydata <- read.csv("../data/anova_one_way.csv")
mydata
str(mydata)
table(mydata$ad_layer)

# 주제 : 시, 군, 구에 따라서 합계 출산율의 차이가 있는가?
# 있다면 어느것과 차이가 있는가?

# 정규분포 여부
out <- aov(birth_rate ~ ad_layer, data=mydata)
shapiro.test(resid(out))

# 비모수적 방식으로 검정
kruskal.test(birth_rate ~ ad_layer, data=mydata)

# 모수적 방식으로 검정
summary(out)

moonBook::densityplot(birth_rate ~ ad_layer, data=mydata)

# kruskal일 경우 사후 검정
library(pgirmess)
kruskalmc(mydata$birth_rate, mydata$ad_layer)

# aov일 경우 사후 검정
TukeyHSD(out)



#### 실습3 ####
library(dplyr)

telco <- read.csv("../data/Telco-Customer-Churn.csv", header=T)
head(telco)
str(telco)

# 독립변수 : PaymentMethod
# 종속변수 : TotalCharges

table(telco$PaymentMethod)

# 주제 : 지불 방식별로 총 지불금액이 차이가 있는가?
# 있다면 무엇과 차이가 있는가?

# 각 지불 방식별로 인원수와 평균 금액을 조회
telco %>% select(PaymentMethod, TotalCharges) %>%
  group_by(PaymentMethod) %>%
  summarise(count=n(), mean=mean(TotalCharges, na.rm=T))

moonBook::densityplot(TotalCharges ~ PaymentMethod, data=telco)

# 정규분포 확인
out <- aov(TotalCharges ~ PaymentMethod, data=telco)
shapiro.test(resid(out))

with(telco, shapiro.test(TotalCharges[PaymentMethod == "Bank transfer (automatic)"]))
with(telco, shapiro.test(TotalCharges[PaymentMethod == "Credit card (automatic)"]))
with(telco, shapiro.test(TotalCharges[PaymentMethod == "Electronic check"]))
with(telco, shapiro.test(TotalCharges[PaymentMethod == "Mailed check"]))

# 앤더슨 달링 테스트

# 등분산 확인
bartlett.test(TotalCharges ~ PaymentMethod, data=telco)

# welch's anova
oneway.test(TotalCharges ~ PaymentMethod, data=telco, var.equal = F)

# 만약 정규분포가 아니라는 상황에서 테스트
kruskal.test(TotalCharges ~ PaymentMethod, data=telco)

# 사후 검정
library(nparcomp)
result <- mctp(TotalCharges ~ PaymentMethod, data=telco)
summary(result)

plot(result)

kruskalmc(telco$TotalCharges, telco$PaymentMethod)

ggplot(telco, aes(telco$PaymentMethod, telco$TotalCharges)) + geom_boxplot()











#### 사례2 : two way anova ####

mydata <- read.csv("../data/anova_two_way.csv")
head(mydata)

out <- aov(birth_rate ~ ad_layer + multichild + ad_layer:multichild, data=mydata)
shapiro.test(resid(out))

summary(out)

result <- TukeyHSD(out)
result

ggplot(mydata, aes(birth_rate, ad_layer, col=multichild)) + geom_boxplot()

#### 실습1 ####

telco <- read.csv("../data/Telco-Customer-Churn.csv", header=T)
head(telco)
str(telco)

# 독립변수 : PaymentMethod, Contract
# 종속변수 : TotalCharges

table(telco$Contract)









#### 사례4 : RM anova ####
# 구형성(Sphericity) : 이미 독립성이 깨졌으므로 최대한 독립성과 무작위성을 확보하기 위한 조건
# 가정 : 반복 측정된 자료들의 시차에 따른 분산이 동일
#     1) Mouchly의 단위행렬 검정 : p-value값이 0.05보다 커야 함.
#     2) 만약 0.05보다 작다면 Greenhouse를 사용한다. : 값이 1에 가까울 수록 구형성 타당

df = data.frame()
df = edit(df)
df


means <- c(mean(df$pre), mean(df$three_month), mean(df$six_month))
means
plot(means, type="o", lty=2, col=2)

install.packages("car")
library(car)

multimodel <- lm(cbind(df$pre, df$three_month, df$six_month) ~ 1)
multimodel

fact <- factor(c("pre", "three_month", "six_month"), ordered = F)

model1 <- Anova(multimodel, idata=data.frame(fact), idesign=~fact, type="III")
summary(model1, multivariate=F)

### 사후 검정

library(reshape2)
df2 <- melt(df, id.vars="id")
df2

colnames(df2) <- c("id", "time", "value")
df2

str(df2)
df2$id <- factor(df2$id)
str(df2)

# 그래프 확인
ggplot(df2, aes(time, value)) + 
  geom_line(aes(group=id, col=id)) + geom_point(aes(col=id))

library(dplyr)
df2.mean <- df2 %>% group_by(time) %>% 
  summarise(mean=mean(value), sd=sd(value))
df2.mean

ggplot(df2.mean, aes(time, mean)) + geom_point() + geom_line(group=1)


with(df2, pairwise.t.test(value, time, paired = T, p.adjust.method = "bonferroni"))



#### 실습1 ####
# 주제 : 7명의 학생이 총 4번의 시험을 보았다. 평균차이가 있는가?
# 있다면 어느것과 차이가 있는가?

rm <- read.csv("../data/onewaySample.csv", header=T)
rm <- rm[, 2:6]
rm

means <- c(mean(rm$score0), mean(rm$score1), mean(rm$score3), mean(rm$score6))
means
plot(means, type="o", lty=2, col=2)









































