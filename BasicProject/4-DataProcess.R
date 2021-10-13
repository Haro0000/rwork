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







 














