# 选择构建用基础镜像
FROM maven:3.6.0-jdk-8-slim as build

#指定构建过程中的工作目录
WORKDIR /app

#将src目录下所有文件拷贝到工作目录中
COPY src /app/src

#将pom.xml文件，拷贝到工作目录下
COPY pom.xml /app

#执行代码编译命令
RUN mvn -f /app/pom.xml clean package

# 选择运行时基础镜像
FROM alpine:3.13

ENV MYSQL_HOST 10.0.224.15
ENV DATABASE_NAM music
ENV MYSQL_USER_NAME music
ENV MYSQL_PASSWORD Music2022
#安装依赖包
RUN apk add --update --no-cache openjdk8-jre-base \ && rm -f /var/cache/apk/*

#指定运行时的工作目录
WORKDIR /app

#将构建产物jar包拷贝到运行时目录
COPY --from=build /app/target/bymax-music-0.0.1.jar .

#暴露端口
EXPOSE 80

#执行启动命令
CMD ["java", "-jar", "/app/bymax-music-0.0.1.jar"]