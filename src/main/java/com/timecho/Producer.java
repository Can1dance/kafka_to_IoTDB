package com.timecho;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

public class Producer {
    public static void main(String[] args) throws IOException {
        Properties properties = new Properties();
        properties.load(new InputStreamReader(new FileInputStream("conf.properties")));
        Map<String, Object> kafkaConfigs=new HashMap<>();
        com.timecho.kafkaProducer kafkaProducer1 = new kafkaProducer(properties);
        int produceCount= Integer.parseInt(properties.getProperty("produceCount"));
        kafkaProducer1.loadData();
        for (int i=0;i<produceCount;i++){
            new Thread(
                    () -> {
                        try {
                            kafkaProducer1.produce();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    })
                    .start();
        }
    }
}
