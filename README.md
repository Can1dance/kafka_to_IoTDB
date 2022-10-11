模拟30个客户端每个客户端每秒产生3000条数据并写入IoTDB

项目启动方式

1.idea启动

启动com.timecho.MakeData就可以运行

2.jar包启动

```
mvn clean package
```

打包

进入target\kafka-IoTDB-1.0-SNAPSHOT\kafka-IoTDB-1.0-SNAPSHOT文件夹

```
bin\start.sh
```

就可以启动项目

配置文件说明

###### conf.properties

```
# kafka properties
bootstrap.servers=192.168.21.100:9092
topicName=testApp3
# iotdb properties
iotdb=192.168.21.100
iotdb.port=6667
#生产者客户端数量
produceCount=1
#消费者数量尽量topic分区数一样，不能大于topic分区数量
cousumerCount=1
#所要读取文件的路径
filePath=data/111.csv
#valueType 1.INT32 2.INT64 3.FLOAT 4.DOUBLE 5.TEXT
valueType=4
```