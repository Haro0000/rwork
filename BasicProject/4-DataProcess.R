#### 기술 통계량 ####

### table()
aws <- read.delim("../data/AWS_sample.txt", sep="#")
head(aws)
tail(aws)

str(aws)

table(aws$AWS_ID)
?table

table(aws$AWS_ID, aws$X.)
View(aws)

table(aws[, c("AWS_ID", "X.")])

aws[2500:3100, "X."] = "modified"
aws[2500:3100, "X."]

table(aws$AWS_ID, aws$X.)

prop.table(table(aws$AWS_ID))
prop.table(table(aws$AWS_ID)) * 100

### mean(), median(), var(), sd(), max(), min(), quantile(), summary(), ...








##### 데이터 처리를 위한 도구 #####

### plyr
### dplyr

install.packages("dplyr")
library(dplyr)
?dplyr

exam <- read.csv("../data/csv_exam.csv")
exam

### filter()

# 1반 학생들의 데이터 추출
subset(exam, exam$class == 1)
exam[exam$class == 1, ]

filter(exam, class==1)
exam %>% filter(class==1)

# 2반이면서 영어점수가 80점 이상인 데이터만 추출
exam[exam$class == 2 & exam$english >= 80, ]
exam %>% filter(class==2 & english>=80)

# 1, 3, 5반에 해당하는 데이터만 추출
exam %>% filter(class==1 | class==3 | class==5)
exam %>% filter(class %in% c(1, 3, 5))



### select()

# 수학점수만 추출
exam[, 3]
exam %>% select(math)

# 반, 수학, 영어점수 추출
exam[, c(2, 3, 4)]
exam %>% select(class, math, english)

# 수학점수를 제외한 나머지 컬럼을 추출
exam %>% select(-math)

# 1반 학생들의 수학점수만 추출(2명까지만 표시) : select math From exam where class=1 limit 2;
exam %>% filter(class==1) %>% select(class, math) %>% head(2)



### arrange()
exam %>% arrange(math)
exam %>% arrange(desc(math))
exam %>% arrange(class, math)


### mutate()
exam$sum <- exam$math + exam$english + exam$science
exam

exam$mean <- exam$sum / 3
exam

exam <- exam[, -c(6, 7)]
exam

exam <- exam %>% mutate(sum=math+english+science, mean=sum/3)
exam


### summarize()
exam %>% summarise(mean_math = mean(math))


### group_by()
exam %>% group_by(class) %>% summarise(mean_math=mean(math), sum_math=sum(math),
                                      median_math=median(math), count=n())




### left_join(), bind_rows()
test1 <- data.frame(id=c(1, 2, 3, 4, 5), midterm=c(60, 70, 80, 90, 85))
test2 <- data.frame(id=c(1, 2, 3, 4, 5), midterm=c(70, 83, 65, 95, 80))

left_join(test1, test2, by="id")
bind_rows(test1, test2)


#### 연습문제1 ####
install.packages("ggplot2")
library(ggplot2)

head(ggplot2::mpg)
table(ggplot2::mpg$drv)
table(ggplot2::mpg$fl)

mpg <- as.data.frame(ggplot2::mpg)

str(mpg)
tail(mpg)
table(mpg$manufacturer)
names(mpg)
dim(mpg)
View(mpg)

# 배기량(displ)이 4이하인 차량의 모델명, 배기량, 생산년도 조회


# 통합연비 파생변수(total)를 만들고 통합연비로 내림차순 정렬을 한 후에 3개의 행만 선택해서 조회
# 통합연비 : total <- (cty + hwy)/2

fngrade <- function(tot){
    if(tot >= 30){
      return("A")
    }else if(tot>=25){
      return("B")
    }else{
      return("C")
    }
}

# mpg %>% mutate(total = (cty + hwy)/2, grade=fngrade(total))
mpg %>% mutate(total = (cty + hwy)/2, 
               grade=ifelse(total>=30, "A", ifelse(total>=20, "B", "C")))


# 회사별로 "suv"차량의 도시 및 고속도로 통합연비 평균을 구해 내림차순으로 정렬하고 1위~5위까지 조회



# 어떤 회사의 hwy연비가 가장 높은지 알아보려고 한다. hwy평균이 가장 높은 회사 세곳을 조회



# 어떤 회사에서 compact(경차) 차종을 가장 많이 생산하는지 알아보려고 한다. 각 회사별 경차 차종 수를 내림차순으로 조회



# 연료별 가격을 구해서 새로운 데이터프레임(fuel)으로 만든 후 기존 데이터셋과 병합하여 출력.
# c:CNG = 2.35, d:Disel = 2.38, e:Ethanol = 2.11, p:Premium = 2.76, r:Regular = 2.22
# unique(mpg$fl)



# 통합연비의 기준치를 통해 합격(pass)/불합격(fail)을 부여하는 test라는 이름의 파생변수를 생성. 이 때 기준은 20으로 한다.



# test에 대해 합격과 불합격을 받은 자동차가 각각 몇대인가?



# 통합연비등급을 A, B, C 세 등급으로 나누는 파생변수 추가:grade
# 30이상이면 A, 20~29는 B, 20미만이면 C등급으로 분류




#### 연습문제2 ####

### 미국 동북부 437개지역의 인구 통계 정보
midwest <- as.data.frame(ggplot2::midwest)
str(midwest)

# 전체 인구대비 미성년 인구 백분율(ratio_child) 변수를 추가


# 미성년 인구 백분율이 가장 높은 상위 5개 지역(county)의 미성년 인구 백분율 출력


# 분류표의 기준에 따라 미성년 비율 등급 변수(grade)를 추가하고, 각 등급에 몇개의 지역이 있는지 조회
# 미성년 인구 백분율이 40이상이면 "large", 30이상이면 "middel", 그렇지않으면 "small"


# 전체 인구 대비 아시아인 인구 백분율(ratio_asian) 변수를 추가하고 하위 10개 지역의 state, county, 아시아인 인구 백분율을 출력

#----------------------------------------------------------------------------------------------

### 1. 데이터 탐색

## 변수명 바꾸기
df_raw <- data.frame(var1=c(1, 2, 3), var2=c(2, 3, 2))
df_raw

# 기본 내장함수
df_raw1 <- df_raw
names(df_raw1) <- c("v1", "v2")
df_raw1

library(dplyr)
df_raw2 <- df_raw
df_raw2 <- rename(df_raw2, v1=var1, v2=var2)
df_raw2



### 2. 결측치 처리

dataset1 <- read.csv("../data/dataset.csv", header=T)
dataset1

str(dataset1)
head(dataset1)

# resident : 1 ~ 5까지의 값을 갖는 명목변수로 거주지를 나타낸다.
# gender : 1 ~ 2까지의 값을 갖는 명목변수로 남/녀를 나타냄
# job : 1 ~ 3까지의 값을 갖는 명목변수. 직업을 나타냄
# age : 양적변수(비율) : 2 ~ 69
# position : 1 ~ 5까지의 값을 갖는 명목변수. 직위를 나타냄
# price : 양적변수(비율) : 2.1 ~ 7.9
# survey : 만족도 조사 : 1 ~ 5까지 명목변수

y <- dataset1$price
plot(y)

# 결측치 확인
summary(dataset1$price)
summary(dataset1$job)

# 결측치 제거
sum(dataset1$price, na.rm=T)
summary(dataset1$price)
mean(dataset1$price, na.rm=T)

price2 <- na.omit(dataset1$price)
summary(price2)

# 결측치 대체 : 0으로 대체
price3 <- ifelse(is.na(dataset1$price), 0, dataset1$price)
summary(price3)
sum(price3)
mean(price3)

# 결측치 대체 : 평균으로 대체
price4 <- ifelse(is.na(dataset1$price), 
                 round(mean(dataset1$price, na.rm = T), 2),
                 dataset1$price)
summary(price4)
head(price4)



### 3. 이상치 처리
## 양적변수와 질적변수의 구별

## 질적변수 : 도수분포표, 분할표 -> 막대 그래프, 원 그래프, ...
table(dataset1$gender)
pie(table(dataset1$gender))

## 양적변수 : 산술평균, 조화평균, 중앙값 -> 히스토그램, 상자도표, 시계열도표, 산포도, ...
summary(dataset1$price)
length(dataset1$price)
str(dataset1)

plot(dataset1$price)
boxplot(dataset1$price)

## 이상치 처리
dataset2 <- subset(dataset1, price>=2 & price<=8)
length(dataset2$price)

plot(dataset2$price)
boxplot(dataset2$price)


### 4. Feature Engineering
View(dataset2)

## 가독성을 위해 resident데이터 변경(1->서울, 2->인천, 3->대전, 4->대구, 5->시구군)
dataset2$resident2[dataset2$resident == 1] <- "1.서울특별시"
dataset2$resident2[dataset2$resident == 2] <- "2.인천광역시"
dataset2$resident2[dataset2$resident == 3] <- "3.대전광역시"
dataset2$resident2[dataset2$resident == 4] <- "4.대구광역시"
dataset2$resident2[dataset2$resident == 5] <- "5.시구군"

head(dataset2)

## Binning : 척도 변경(양적 -> 질적)
# 나이 변수를 청년층(30세 이하), 중년층(31~55이하), 장년층(56~)
dataset2$age2[dataset2$age <= 30] <- "청년층"
dataset2$age2[dataset2$age > 30 & dataset2$age <= 55] <- "중년층"
dataset2$age2[dataset2$age > 55] <- "장년층"

head(dataset2)

## Dummy : 척도 변경(질적 -> 양적)
user_data <- read.csv("../data/user_data.csv", header=T)
user_data

# 거주유형: 단독주택(1), 다가구주택(2), 아파트(3), 오피스텔(4)
user_data$house_type2 <- ifelse(user_data$house_type==1 | user_data$house_type==2, 0, 1)
table(user_data$house_type2)


## 데이터의 구조 변경(wide type, long type) : melt->long형으로 변환, cast->wide형으로 변환
# reshape, reshape2, tidyr, ....

install.packages("reshape2")
library(reshape2)

data()

str(airquality)
head(airquality)

me <- melt(airquality, id.vars = c("Month", "Day"))
me

me1 <- melt(airquality, id.vars = c("Month", "Day"), variable.name = "climate")
me1

?dcast
?melt
dc1 <- dcast(me1, Month+Day ~ climate )
dc1

data <- read.csv("../data/data.csv")
data

buy_data <- dcast(data, Customer_ID ~ Date, mean)
buy_data

buy_data2 <- melt(buy_data, id.vars = "Customer_ID", variable.name = "Date",
                  value.name="Buy")
buy_data2

data <- read.csv("../data/pay_data.csv")
data

# product_type을 wide하게 변경
type_data <- dcast(data, user_id ~ product_type)
type_data

type_data1 <- dcast(data, user_id + pay_method + price ~ product_type)
type_data1











#### 연습문제 3 ####
## 극단적 선택의 비율을 어느 연령대가 가장 높은가?(사망원인 통계)





