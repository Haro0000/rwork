#### 1. 단일 회귀 분석 ####
# y = ax + b

str(women) # 미국 여성을 대상으로 키와 몸무게 조사(30~39)
women

plot(weight ~ height, data=women)

fit <- lm(weight ~ height, data=women)
fit

abline(fit, col="blue")

summary(fit)

cor.test(women$weight, women$height)
0.9954948 ^ 2

85*3.45 -87.52





#### 2. 4가지 조건을 확인하기 위한 방법 ####

plot(fit)

par(mfrow=c(2, 2))
plot(fit)

par(mfrow=c(1,1))
plot(weight ~ height, data=women)

shapiro.test(resid(fit))

summary(fit)

### 다항 회귀분석(Polynomial Regression)

plot(weight ~ height, data=women)
abline(fit, col="blue")

fit2 <- lm(weight ~ height + I(height^2), data=women)
fit2
summary(fit2)

plot(weight ~ height, data=women)
lines(women$height, fitted(fit2), col="red")

shapiro.test(resid(fit2))





#### 실습1 ####
# social_welfare : 사회복지시설
# active_firms : 사업체 수
# urban_park : 도시 공원
# doctor : 의사
# tris : 폐수 배출 업소
# kindergarten : 유치원

mydata <- read.csv("../data/regression.csv")
str(mydata)
head(mydata)

# 종속변수 : birth_rate
# 독립변수 : kindergarten

### 가설 : 유치원 수가 많은 지역에 합계 출산율도 높은가?
###     또는 합계 출산율이 유치원 수에 영향을 주는가?

fit <- lm(birth_rate ~ kindergarten, data=mydata)
summary(fit)

par(mfrow=c(2, 2))
plot(fit)

shapiro.test(resid(fit))

fit2 <- lm(log(birth_rate) ~ log(kindergarten), data=mydata)
summary(fit2)

plot(fit2)

shapiro.test(resid(fit2))

fit3 <- lm(birth_rate ~ dummy, data=mydata)
summary(fit3)

shapiro.test(resid(fit3))




#### 실습2 ####
# 출처 : www.kaggle.com : House sales price in Kings count, USA

house <- read.csv("../data/kc_house_data.csv", header=T)
str(house)

### 가설 : 거실의 크기와 집 가격이 서로 관계가 있는가?
# 종속변수 : price
# 독립변수 : sqft_living

fit <- lm(price ~ sqft_living, data=house)
summary(fit)

par(mfrow=c(2, 2))
plot(fit)

plot(house$sqft_living, house$price)






























