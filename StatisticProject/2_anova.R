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


#### 실습2 ####

mydata <- read.csv("../data/anova_one_way.csv")
mydata
str(mydata)
table(mydata$ad_layer)

# 주제 : 시, 군, 구에 따라서 합계 출산율의 차이가 있는가?
# 있다면 어느것과 차이가 있는가?









