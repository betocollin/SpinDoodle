
/*
The MIT License (MIT)

Copyright (c) 2013 Mick Grierson, Matthew Yee-King, Marco Gillies

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to 
deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the 
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included 
in  all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import android.hardware.*;

public class Accelerometer implements SensorEventListener {
  private SensorManager sensorManager;
  private Sensor accelerometer;
  private float[] values;

  public Accelerometer() {
    sensorManager = (SensorManager)getSystemService(SENSOR_SERVICE);
    accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
    sensorManager.registerListener(this, accelerometer, SensorManager.SENSOR_DELAY_NORMAL);
    values = new float[3];
  }


  public float[] getValues() {
    return values;
  }

  public float getX() {
    return values[0];
  }

  public float getY() {
    return values[1];
  }

  public float getZ() {
    return values[2];
  }

  /**
   * SensorEventListener interace
   */
  public void onSensorChanged(SensorEvent event) {
    values = event.values;
    //float[] vals = event.values;
    //for (int i=0; i<vals.length;i++){
    //  println(" sensor! "+vals[i]);
    //}
  }

  /**
   * SensorEventListener interace
   */
  public void onAccuracyChanged(Sensor sensor, int accuracy) {
  }
}


