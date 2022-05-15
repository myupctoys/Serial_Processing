/**
 * <H1>Serial port class</H1>
 * Serial port variables and functions related to serial port.<br>
 * Requires Quarks G4P library and latest jssc.jar file not in processing distro.
 * Copyright (c) [2022] [Stefan Morley]
 * @author SBM
 * @version 0_2_1
 * MIT Licence attached
*/

import g4p_controls.GTimer;
import processing.core.PApplet;
import processing.serial.Serial;

public class serial_ports extends PApplet
{

  private final PApplet this_applet;  // this_applet Reference Parent processing applet
  private Serial myPort;              // Serial port class
  private String myPortname;          // String detailing COMx or per OS
  public int port_x_of_x;             // This is port x of x

  private int tx_counter = 0;         // Pointer to the newest packet string

  private int baud_rate;              // Baud rate
  private String parity;              // Parity Even Odd or None
  private int bits;                   // Number of bits 7 or 8
  private float stop;                 // Stop Bits 1.0 1.5 or 2.0
  private int tx_rate;                // Period between packet transmissions
  private byte buffer_char;           // Serial event fired when this character received
  private String timer_function;      // Name of the timer function that get fired based on tx_rate
  private int process;                // Which one of 4 processes is this port related to
  private String process_name;        // String human-readable process name
  private boolean auto_run;           // Decide in timer function if transmission needs to occur
  private String packet_string;       // String that gets sent out the serial port

  private boolean new_line_required = true;  // A new LF or CR required at the end of each transmitted string
  private boolean port_is_open = false;    // Set true of this port is open otherwise false.
  private String save_file = "";

  private GTimer Timer;                // Timer for G4P library
  private int timed_event = 0;         // ???????

  public String[] strarray_rx = new String[100];  // Received string array typically 4
  public int rx_pointer = 0;            // Pointer to the next string array for new data
  public int current_rx_pointer = 0;        // The current string array for newest data

  public volatile boolean rx_flag = false;          // Set when new data is available, needs to be cleared when this data is acted on
  public String[] strarray_tx = new String[100];  // Array for transmitted data, not currently used      
  /**
   * Constructor for serial port
   * @param PA parent Applet reference
   */
  public serial_ports(PApplet PA)          //? Instantiate the class
  {
    this.this_applet = PA;
    load_default_parameters();        //? Load hard coded default parameters, will get changed once comms.dat file is loaded
  }
  /**
   * Hard coded initial default parameters<br>
   * Will get changed later on when comms.dat file is read<br>
   * Also used if request to load defaults in serial_gui screen<br>
   */
  public void load_default_parameters()
  {
    myPortname = "COM1";    // Port name COMx
    port_x_of_x = 0;      // ??????????
    baud_rate = 9600;      // Baud Rate
    parity = "N";        // Parity None, Even, Odd
    bits = 8;          // Bits 7 or 8
    stop = (float)1.0;      // Stop bits 1.0, 1.5 or 2.0
    tx_rate = 1000;        // Time between repeat transmissions
    buffer_char = (byte)10;    // Fire Serial event when this char received
    timer_function = "Control";  // Name of function that gets called on timer event
    process = 0;        // Number of the process
    process_name = "";      // Human-readable use of the current process
    auto_run = false;      // Control executed if true, otherwise gets bypassed
    packet_string = "";      // Nothing in the string as an initial position
  }

  /**
   * 
   * @param start_timer 
   * True tell the routine to start the timer
   * False we don't want the timer running, just to open the serial port
   * @return if the timer started the returned flag will be true
   * 
   */
  public boolean open_port(boolean start_timer)
  {
    if(start_timer)
    {
      if(Timer == null)  
      {
        Timer = new GTimer(this_applet, this, timer_function, tx_rate);     
        Timer.start(timed_event);
      }
      else
      {
        Timer.start(timed_event);
      }
    }
    try
    {
      myPort = new Serial(this_applet, myPortname, baud_rate, parity.charAt(0), bits, stop);
      this.port_is_open = true;
    }
    catch (Exception e)
    {
      this.port_is_open = false;
      Logger.info("Port is not available from Timer :- " + this);
      return false;
    }
    myPort.clear();
    myPort.bufferUntil((char)10);
    return true;
  }
  /**
   * Opens the serial port based on the classes parameters.<br>
   * If successfully opened the serial port buffer is cleared and the<br>
   * buffer until character is set for the serial port read.<br>
   * Buffer until character typically CR 10 0x0A or LF 13 0x0D
   * @return true if the serial port was opened successfully otherwise false.
   */

  public boolean open_port()
  {
    boolean status = false;
    try
    {
      myPort = new Serial(this_applet, myPortname, baud_rate, parity.charAt(0), bits, stop);
      status = true;
      this.port_is_open = true;
    }
    catch(Exception exception)
    {
      Logger.info("Port is not available to open :- " + this);
      this.port_is_open = false;
      return status;
    }
    myPort.clear();
    myPort.bufferUntil((byte)10);
    return status;
  }

  /**
   * 
   * @return myPort which is the actual serial class not this serial_ports class
   */
  public Serial getMyPort() 
  {
    return myPort;
  }
  /**
   * Event gets fired based on the serial port having received the buffer until character<br>
   * Buffer until character typically CR 10 0x0A or LF 13 0x0D
   * @param port serial class that fired the event
   */
  public void serialEvent(Serial port) 
  {
    String input = "";
    try
    {
      input = port.readString();
    }
    catch(Exception e)
    {
      Logger.info("Serail event fired but no data :- " + this);      
    }

    if(input != null)
    {   
      strarray_rx[rx_pointer] = input.trim();
      rx_flag = true;
      rx_pointer++;
      rx_pointer %= 4;
    }
  }
  
  /**
   * This Control function is run after the timer period tx_rate<br>
   * Purpose is to allow timed polling of serial devices.<br>
   * tx-counter is simply a 16 bit value incremented one each time this routine is run.
   * 
   * @param timer GTimer timer class that fired the event
   */
@SuppressWarnings("unused")   
  public void Control(GTimer timer)
  {
    if(this.myPort != null)
    {
      try
      {
        if(new_line_required)
          myPort.write(packet_string + " " + tx_counter + (char)10);
        else
          myPort.write(packet_string + " " + tx_counter);
      }
      catch (Exception e)
      {
      Logger.info("Port is not available to Timer Event :- " + this);        
      }
    }
    tx_counter++;
  }
  
  public void send_gpib_serial_command(String new_packet_string, int del, boolean response)
  {
    int start_time = millis();
    rx_flag = false;
    delay(30);
    myPort.write(new_packet_string + (char)10);
    if(response)
    {
      while(!rx_flag)
      {
        if(start_time + 500 <= millis())
          break;
      }
      delay(30);
    }
    else
    {
      delay(del);
    }
  }
  
  public void send_serial_command(String new_packet_string, int del, boolean response)
  {
    int start_time = millis();
    rx_flag = false;
    //delay(30);
    myPort.write(new_packet_string + (char)10);
    if(response)
    {
      while(!rx_flag)
      {
        if(start_time + 500 <= millis())
          break;
      }
      //delay(30);
    }
    else
    {
      delay(del);
    }
  }
  
  public void send_fpga_dac_serial_command(String new_packet_string, int del, boolean response)
  {
    int start_time = millis();
    rx_flag = false;
    //delay(30);
    myPort.write(new_packet_string + ' '); //(char)10);
    if(response)
    {
      while(!rx_flag)
      {
        if(start_time + 500 <= millis())
          break;
      }
    }
    else
    {
      delay(del);
    }
  }  
  
  public void send_fpga_dac_serial_binary(byte[] c, int del, boolean response)
  {
    int start_time = millis();
    rx_flag = false;
    //delay(30);
    
    myPort.write(c);
    
    if(response)
    {
      while(!rx_flag)
      {
        if(start_time + 500 <= millis())
          break;
      }
    }
    else
    {
      delay(del);
    }
  }    
  
  /**
   * Set the class Serial to myPort
   * @param myPort2 Serial class
   */
  public void setMyPort(Serial myPort2) 
  {
    this.myPort = myPort2;
  }
  /**
   * returns the comm ports name related to this instance of serial_ports
   * @return myPortname String eg "Com12"
   */
  public String getMyPortname() 
  {
    return myPortname;
  }

  public void setMyPortname(String myPortname) 
  {
    this.myPortname = myPortname;
  }
  /**
   * If the myPort exists close it and the timer related to it
   */
  public void port_destructor()
  {
    if(myPort != null)
    {
      if(Timer != null)
        Timer.stop();
      if(myPort != null)
        myPort.stop();
    }
    this.port_is_open = false;
  }

  public int getBaud_rate() 
  {
    return baud_rate;
  }

  public void setBaud_rate(int baud_rate) 
  {
    this.baud_rate = baud_rate;
  }

  public String getParity() 
  {
    return parity;
  }
  public void setParity(String parity) 
  {
    this.parity = parity;
  }
  public int getBits() 
  {
    return bits;
  }

  public void setBits(int bits) 
  {
    this.bits = bits;
  }

  public float getStop() 
  {
    return stop;
  }
  public void setStop(float stop) 
  {
    this.stop = stop;
  }
  public int getTx_rate() 
  {
    return tx_rate;
  }
  public void setTx_rate(int tx_rate) 
  {
    this.tx_rate = tx_rate;
  }
  public byte getBuffer_char() 
  {
    return buffer_char;
  }
  public void setBuffer_char(byte buffer_char) 
  {
    this.buffer_char = buffer_char;
  }
  public String getTimer_function() 
  {
    return timer_function;
  }
  public void setTimer_function(String timer_function) 
  {
    this.timer_function = timer_function;
  }
  public int getPort_x_of_x() 
  {
    return port_x_of_x;
  }
  public void setPort_x_of_x(int port_x_of_x) 
  {
    this.port_x_of_x = port_x_of_x;
  }

  public int get_tx_rate()
  {
    return tx_rate;
  }

  public String get_process_name()
  {
    return this.process_name;
  }

  public void set_process_name(String process_name)
  {
    this.process_name = process_name;
  }

  public void set_tx_rate(int tx_rate)
  {
    this.tx_rate = tx_rate;
  }

  public int getProcess() 
  {
    return process;
  }

  public void setProcess(int process) 
  {
    this.process = process;
  }

  public boolean getauto_run() 
  {
    return auto_run;
  }

  public void setauto_run(boolean auto_run) 
  {
    this.auto_run = auto_run;
  }

  public String getpacket_string() 
  {
    return packet_string;
  }

  public void setpacket_string(String packet_string) 
  {
    this.packet_string = packet_string;
  }

  public boolean getPort_is_open() {
    return this.port_is_open;
  }

  public void setPort_is_open(boolean port_is_open) {
    this.port_is_open = port_is_open;
  }
  public void setsave_file(String save_file)
  {
    // TODO Auto-generated method stub
    this.save_file = save_file;
    
  }
  
  public String getsave_file()
  {
    // TODO Auto-generated method stub
    return this.save_file;
  }


}
