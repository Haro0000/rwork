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




