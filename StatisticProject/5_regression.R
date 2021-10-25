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








#### 2. 다중 회귀 분석 ####
# y = a1x1 + a2x2 + a3x3 + ... + b

house <- read.csv("../data/kc_house_data.csv", header=T)
str(house)

# 종속 변수 : price
# 독립 변수 : sqft_living, floors, waterfront

fit2 <- lm(price ~ sqft_living + floors + waterfront, data=house)
summary(fit2)

### 표준화 계수 : 변수들의 영향력 확인
install.packages("lm.beta")
library(lm.beta)

fit3 <- lm.beta(fit2)
summary(fit3)

### 변수들간의 상관 관계
### 다중 공선성
#     1) 원인 : 독립변수들끼리 너무 많이 겹쳐서 발생하는 문제
#     2) 확인 방법
#       - 산포도, 상관계수 : 상관 계수가 0.9를 넘게되면 다중 공선성 문제  
#       - VIF(Variance Inflation Factor) : 분산팽창지수
#           일반적으로 10보다 크면 문제가 있다고 판단(연속형 변수)
#           더미변수일 경우에는 3이상이면 문제가 있다고 판단.
#           sqrt(vif) > 2
#     3) 해결 방법
#       - 유의 여부
#       - 변수 제거
#       - 주성분 분석
#       - 다중공선성이 발생한 독립변수들을 합치기
#       - ...



# 독립변수 : sqft_living, bathrooms, sqft_lot, floors
attach(house)
x <- cbind(sqft_living, bathrooms, sqft_lot, floors)
cor(x)

cor(x, price)

reg1 <- lm(price ~ sqft_living, data=house)
summary(reg1)

reg2 <- lm(price ~ sqft_living + floors, data=house)
summary(reg2)

reg2_1 <- lm(price ~ sqft_living + floors + sqft_living * floors, data=house)
summary(reg2_1)

install.packages("car")
library(car)

vif(reg2_1)
sqrt(vif(reg2_1))

x <- cbind(floors, sqft_above, sqft_basement)
cor(x)


x <- cbind(floors, bedrooms)
cor(x)

reg3 <- lm(price ~ floors + bedrooms, data=house)
summary(reg3)

vif(reg3)


x <- cbind(floors, bedrooms, waterfront)
cor(x)
cor(x, price)

reg4 <- lm(price ~ floors + bedrooms + waterfront, data=house)
summary(reg4)

vif(reg4)


reg5 <- lm(price ~ floors + bedrooms + waterfront + bedrooms*waterfront, data=house)
summary(reg5)

vif(reg5)


reg6 <- lm(price ~ floors + bedrooms + waterfront + floors*waterfront, data=house)
summary(reg6)

vif(reg6)

detach(house)



#### 실습1 ####
head(state.x77)

states <- as.data.frame(state.x77[, c("Murder", "Population", "Income", "Illiteracy","Frost")])
str(states)

fit <- lm(Murder ~ Population + Illiteracy + Income + Frost, data=states)
summary(fit)

vif(fit)
sqrt(vif(fit))


### 이상 관측치
# 1) 이상치(outlier) : 표준편차보다 2배이상 크거나 작은 값
# 2) 큰 지레점(High leverage points) : p(절편을 포함한 인수들의 숫자)/n 의 값이 2~3배 이상되는 관측치 : 5 / 50 = 0.1
# 3) 영향 관측치(Influential Observation, Cook's D)
#     독립변수의 수 / (샘플 수 - 예측인자의 수 - 1) 보다 클 경우
#     4 / (50-4-1) = 0.1

par(mfrow=c(1,1))
influencePlot(fit, id=list(method="identify"))





#### 회귀모델의 교정 ####

fit <- lm(Murder ~ Population + Illiteracy + Income + Frost, data=states)
summary(fit)

par(mfrow=c(2, 2))
plot(fit)

shapiro.test(resid(fit))


### 정규성을 만족하지 않을 때(결과 변수에 람다승을 해준다.)
# -2, -1, -0.5, 0, 0.5, 1, 2
powerTransform(states$Murder)
summary(powerTransform(states$Murder))


### 선형성을 만족하지 않을 때
boxTidwell(Murder ~ Population + Illiteracy, data=states)


### 등분산을 만족하지 않을 때
ncvTest(fit)

spreadLevelPlot(fit)






#### 회귀모델의 선택 ####
# AIC(Akaike's Information Criterion)
# Backward Stepwise Regression
#     - 모든 독립변수를 대상으로 하나씩 빼는 방법
# Forward Stepwise Regression
#     - 변수를 하나씩 추가하면서 AIC값을 측정

fit1 <- lm(Murder ~ ., data=states)
summary(fit1)

fit2 <- lm(Murder ~ Population + Illiteracy, data=states)
summary(fit2)

AIC(fit1, fit2)

### Backward Stepwise Regression
full.model <- lm(Murder ~ ., data=states)
reduced.model<- step(full.model, direction = "backward")
reduced.model


### forward Stepwise Regression
min.model <- lm(Murder ~ 1, data=states)
fwd.model <- step(min.model, direction = "forward",
                  scope=(Murder ~ Population + Illiteracy + Income + Frost))


### All Subset Regression
install.packages("leaps")
library(leaps)

result <- regsubsets(Murder ~ ., data=states, nbest=4)
result
par(mfrow=c(1, 1))
plot(result, scale="adjr2")



#### 실습 ####

mydata <- read.csv("../data/regression.csv")
str(mydata)
# 가장 영향력이 있는 변수들은 무엇인가?
# 정규성 검증, 등분산성 검증, 다중공선성 검증
# 독립변수들이 출산율과 관계가 있는가?




























