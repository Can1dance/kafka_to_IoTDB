package com.timecho;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

public class Test {
    public static void main(String[] args) throws IOException {
        BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter("data/111.csv"));
       for (int i=0;i<=3000;i++){
           int i9= (int) ((Math.random() * 9 + 1) * 100000000);
           int i2 = (int) ((Math.random() * 9 + 1) * 10);
           int i3 = (int) ((Math.random() * 9 + 1) * 100);
           bufferedWriter.write(i9+","+i2+","+i2+","+""+i2+","+i2+","+i2+","+i2+","+i3+","+System.currentTimeMillis()+"\n");
       }
        bufferedWriter.close();
    }


}
