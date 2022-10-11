package com.timecho;

import org.apache.iotdb.rpc.IoTDBConnectionException;
import org.apache.iotdb.rpc.StatementExecutionException;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

public class Consumer {
    static int partition=0;
    public static void main(String[] args) throws IOException {
        Properties properties = new Properties();
        properties.load(new InputStreamReader(new FileInputStream("conf.properties")));
        Map<String, Object> kafkaConfigs=new HashMap<>();
        com.timecho.kafkaProducer kafkaProducer1 = new kafkaProducer(properties);
        int cousumerCount= Integer.parseInt(properties.getProperty("cousumerCount"));
        kafkaConsumer kafkaConsumer = new kafkaConsumer();
        for (int i=0;i<cousumerCount;i++){
            new Thread(
                    () -> {
                        try {
                            partition++;
                            kafkaConsumer.comsumer(properties, partition-1);
                        } catch (IoTDBConnectionException | StatementExecutionException e) {
                            e.printStackTrace();
                        }
                    })
                    .start();
        }

    }
}
