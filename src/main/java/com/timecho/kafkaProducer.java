package com.timecho;

import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.clients.producer.KafkaProducer;

import java.io.*;
import java.util.*;


public class kafkaProducer{
    private String topicName = "";
    public KafkaProducer kafkaProducer;
    Properties properties =null;
    List<ProducerRecord<Long, String>> recordList=new ArrayList<>();
    public static void main(String[] args) throws IOException {
        Properties properties = new Properties();
        properties.load(new InputStreamReader(new FileInputStream("conf.properties")));
        Map<String, Object> kafkaConfigs=new HashMap<>();
        com.timecho.kafkaProducer kafkaProducer = new kafkaProducer(properties);
        kafkaProducer.loadData();
        kafkaProducer.produce();
    }

    public kafkaProducer(Properties properties) throws IOException {
        this.properties=properties;
        Map<String, Object> kafkaConfigs=new HashMap<>();
        kafkaConfigs.put("bootstrap.servers", properties.getProperty("bootstrap.servers"));
        kafkaConfigs.put("key.serializer", "org.apache.kafka.common.serialization.LongSerializer");
        kafkaConfigs.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");
        kafkaConfigs.put("acks", "0");
        kafkaProducer = new KafkaProducer(kafkaConfigs);
        topicName = this.properties.getProperty("topicName");
        System.out.println(topicName);
    }

    protected void loadData() throws IOException {
        String filePath = properties.getProperty("filePath");
        String line;
        List<List<String>> columnList = new ArrayList();
        int maxPartition = Integer.parseInt(properties.getProperty("cousumerCount"));
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            while ((line = br.readLine()) != null) {
                List<String> column = Arrays.asList(line.split(","));
                System.out.println(column);
                columnList.add(column);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        Random random = new Random();
        for (List<String> strings : columnList) {
            ProducerRecord<Long, String> record =
                    new ProducerRecord<>(topicName,random.nextInt(maxPartition),System.currentTimeMillis(), strings.toString().replace("[","").replace("]","").replace(" ",""));
            recordList.add(record);
        }
    }

    public void produce() throws IOException {
                    while (true) {
                        for (ProducerRecord<Long, String> longStringProducerRecord : recordList) {
                            kafkaProducer.send(longStringProducerRecord);
                        }
                        try {
                            Thread.sleep(1000);
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }
    }
}

