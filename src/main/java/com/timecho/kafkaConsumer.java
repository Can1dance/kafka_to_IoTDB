package com.timecho;

import org.apache.iotdb.rpc.IoTDBConnectionException;
import org.apache.iotdb.rpc.StatementExecutionException;
import org.apache.iotdb.session.Session;
import org.apache.iotdb.session.template.Template;
import org.apache.iotdb.tsfile.file.metadata.enums.TSDataType;
import org.apache.iotdb.tsfile.utils.TsPrimitiveType;
import org.apache.iotdb.tsfile.write.record.Tablet;
import org.apache.iotdb.tsfile.write.schema.MeasurementSchema;
import org.apache.iotdb.tsfile.write.writer.TsFileOutput;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.TopicPartition;
import org.apache.kafka.common.protocol.types.Field;
import org.apache.kafka.common.serialization.StringDeserializer;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.channels.ScatteringByteChannel;
import java.time.Duration;
import java.util.*;

public class kafkaConsumer {
    private  static String TOPIC_NAME = "";
    private  static String CONSUMER_GROUP_NAME = "g1";

    public static void main(String[] args) throws StatementExecutionException, IoTDBConnectionException, IOException {
        Properties properties = new Properties();
        properties.load(new InputStreamReader(new FileInputStream("conf.properties")));
        new kafkaConsumer().comsumer(properties,2);

    }


    public void comsumer(Properties properties,int partition) throws IoTDBConnectionException, StatementExecutionException {
        TOPIC_NAME=properties.getProperty("topicName");
        System.out.println(properties.getProperty("iotdb.port"));
        Session session = new Session(properties.getProperty("iotdb"), Integer.parseInt(properties.getProperty("iotdb.port")));
        session.open();
//        List<String> measurements = new ArrayList<>();
//        measurements.add("ValueSeriesId");
//        measurements.add("GenerationId");
//        measurements.add("SourceNodeId");
//        measurements.add("InternalFlags");
//        measurements.add("Flags");
//        measurements.add("Quality");
//        measurements.add("DataTypeId");
//        measurements.add("Value");
//        measurements.add("SourceTimestamp");
//        List<TSDataType> types = new ArrayList<>();
//        types.add(TSDataType.TEXT);
//        types.add(TSDataType.INT32);
//        types.add(TSDataType.INT32);
//        types.add(TSDataType.INT32);
//        types.add(TSDataType.INT64);
//        types.add(TSDataType.INT32);
//        types.add(TSDataType.INT32);

        TSDataType valueDataType =null;
            String deviceId = "root.sg2.d2";
        int valueType = Integer.parseInt(properties.getProperty("valueType"));
        System.out.println(valueType);
        switch (valueType){
            case 1:
                valueDataType = TSDataType.INT32;
                break;
            case 2:
                valueDataType = TSDataType.INT64;
                break;
            case 3:
                valueDataType = TSDataType.FLOAT;
                break;
            case 4:
                valueDataType = TSDataType.DOUBLE;
                break;
            case 5:
                valueDataType = TSDataType.TEXT;
                break;
            case 6:
                valueDataType = TSDataType.BOOLEAN;
                break;
            default:
                System.out.println("请输入1-6");
                break;
        }
    List<MeasurementSchema> schemaList = new ArrayList<>();
            schemaList.add(new MeasurementSchema("ValueSeriesId", TSDataType.TEXT));
            schemaList.add(new MeasurementSchema("GenerationId", TSDataType.INT32));
            schemaList.add(new MeasurementSchema("SourceNodeId", TSDataType.INT32));
            schemaList.add(new MeasurementSchema("InternalFlags", TSDataType.INT32));
            schemaList.add(new MeasurementSchema("Flags", TSDataType.INT64));
            schemaList.add(new MeasurementSchema("Quality", TSDataType.INT32));
            schemaList.add(new MeasurementSchema("DataTypeId", TSDataType.INT32));
            schemaList.add(new MeasurementSchema("Value", valueDataType));
            schemaList.add(new MeasurementSchema("SourceTimestamp", TSDataType.TEXT));
            Tablet tablet = new Tablet(deviceId, schemaList, 2000);

//        types.add(TSDataType.TEXT);
        Properties props = new Properties();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, properties.getProperty("bootstrap.servers"));
// 消费分组名
        props.put(ConsumerConfig.GROUP_ID_CONFIG, CONSUMER_GROUP_NAME);
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        props.put(ConsumerConfig.MAX_POLL_RECORDS_CONFIG, 2000);
        props.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "latest");
//1.创建⼀个消费者的客户端
        KafkaConsumer<String, String> consumer = new KafkaConsumer<String, String>(props);
//2.消费者订阅主题列表

//        consumer.subscribe(Arrays.asList(TOPIC_NAME));
        consumer.assign(Arrays.asList(new TopicPartition(TOPIC_NAME, partition)));
        Random random = new Random();
        while (true) {
            /*
             * 3.poll() API 是拉取消息的⻓轮询
             */
            ConsumerRecords<String, String> records = consumer.poll(2000);
            int c=partition*20000;
            int number = random.nextInt(20000);
            long times = System.currentTimeMillis() * 1000 + number + c;
//            long times = System.currentTimeMillis();
            for (ConsumerRecord<String, String> record : records) {
                //4.打印消息
//                System.out.printf(record.value());
//                System.out.println(record.timestamp());
                String[] split = record.value().split(",");
                List<String> list = Arrays.asList(split);
                int rowIndex = tablet.rowSize++;
                tablet.addTimestamp(rowIndex, times);
                for (int s = 0; s < 9; s++) {
                    if (list.size()==0||list.size()==1){
                        break;
                    }
                    String value = list.get(s).replace(" ","");
                switch (s) {
                    case 0:
                        tablet.addValue(schemaList.get(s).getMeasurementId(), rowIndex, value);
                        break;
                    case 1:
                        tablet.addValue(schemaList.get(s).getMeasurementId(), rowIndex, Integer.parseInt(value));
                        break;
                    case 2:
                        tablet.addValue(schemaList.get(s).getMeasurementId(), rowIndex, Integer.parseInt(value));
                        break;
                    case 3:
                        tablet.addValue(schemaList.get(s).getMeasurementId(), rowIndex, Integer.parseInt(value));
                        break;
                    case 4:
                        tablet.addValue(schemaList.get(s).getMeasurementId(), rowIndex, Long.parseLong(value));
                        break;
                    case 5:
                        tablet.addValue(schemaList.get(s).getMeasurementId(), rowIndex, Integer.parseInt(value));
                        break;
                    case 6:
                        tablet.addValue(schemaList.get(s).getMeasurementId(), rowIndex, Integer.parseInt(value));
                        break;
                    case 7:
                        switch (valueType){
                            case 1:
                                tablet.addValue(schemaList.get(s).getMeasurementId(), rowIndex, Integer.parseInt(value));
                                break;
                            case 2:
                                tablet.addValue(schemaList.get(s).getMeasurementId(), rowIndex, Long.parseLong(value));
                                break;
                            case 3:
                                tablet.addValue(schemaList.get(s).getMeasurementId(), rowIndex, Float.parseFloat(value));
                                break;
                            case 4:
                                tablet.addValue(schemaList.get(s).getMeasurementId(), rowIndex, Double.parseDouble(value));
                                break;
                            case 5:
                                tablet.addValue(schemaList.get(s).getMeasurementId(), rowIndex, value);
                                break;
                            case 6:
                                tablet.addValue(schemaList.get(s).getMeasurementId(), rowIndex, value);
                                break;
                            default:
                                System.out.println("请输入1-6");
                        }
                        break;
                    case 8:
                        tablet.addValue(schemaList.get(s).getMeasurementId(), rowIndex, value);
                        break;
                    default:
                        System.out.println("请输入1-5");
                        break;
                }
            }
                times++;
                if (tablet.rowSize == tablet.getMaxRowNumber()) {
                    try{
                        session.insertTablet(tablet);
                    }catch (Exception e){
                        System.out.println("tablet存在null");
                    }
                    tablet.reset();
                }

                }
//                try{
//                    session.insertRecord("root.path1",System.currentTimeMillis()*1000+number+c,measurements,list);
//                    c++;
//                }catch (Exception e){
//
//                }
            }

        }

    }