import at.mukprojects.console.Console;
import g4p_controls.*;
import g4p_controls.GButton;
import org.pmw.tinylog.Logger;

serial_gui new_serial;

GButton btn_exit;
GButton btn_open;
GButton btn_send;
GButton btn_file_open;
GTextField txt_string_to_send;
GPanel pnl_launch;
GOption opt_date_time_stamp;

  public static int x_location = 0;
  public static int y_location = 0;

public String Serial_Config_Version = "0_1_6";
public Console console;
public static int associated_process = 0;
public file_class[] data_dump;

void setup()
{
  size(1000,490);
  println("Serial Processing runtime configuration V" + Serial_Config_Version);
  noLoop();
  surface.setLocation((displayWidth/2) - 100, (displayHeight/2) - (height/2));  
    x_location = getJFrame(getSurface()).getX();
    y_location = getJFrame(getSurface()).getY();  
    
  configure_logger();
  change_logger_output(LOGGER.FILE_LOGGER);    // LOGGER.FILE_LOGGER if you want to move debug logging to a file.
                                               // File will be here ./data/log.txt
  version_info();
  
  pnl_launch = new GPanel(this, 10, height -70, width - 20, 60, "");
  btn_exit = new GButton(this, width-90, 25, 65, 30);
  btn_exit.setText("Exit");
  btn_exit.addEventHandler(this, "btn_exit_click");
  pnl_launch.addControl(btn_exit);
  
  btn_open = new GButton(this, 10, 25, 65, 30);
  btn_open.setText("Open");
  btn_open.addEventHandler(this, "btn_open_click");
  pnl_launch.addControl(btn_open);

  btn_send = new GButton(this, 85, 25, 65, 30);
  btn_send.setText("Send");
  btn_send.addEventHandler(this, "btn_send_click");
  pnl_launch.addControl(btn_send);

  txt_string_to_send = new GTextField(this, 160, 30, 120, 20);
  txt_string_to_send.setText("Testing TX Data");
  pnl_launch.addControl(txt_string_to_send);

  btn_file_open = new GButton(this, 290, 25, 65, 30);
  btn_file_open.setText("File Open");
  btn_file_open.addEventHandler(this, "btn_file_open_click");
  pnl_launch.addControl(btn_file_open);

  opt_date_time_stamp = new GOption(this, 365, 25, 100, 30, "DTG Stamp");
  pnl_launch.addControl(opt_date_time_stamp);
  
  data_dump = new file_class[4];
  
  console = new Console(this);
  console.start();
  loop();
}

void draw()
{
  // console.draw(x, y, width, height, preferredTextSize, minTextSize, linespace, padding, strokeColor, backgroundColor, textColor)  
  console.draw(10, height - height + 10, width-20, height - 90, 15, 15, 4, 4, color(220), color(0), color(240));
  console.print();
}

public String generate_dtg()
{
  return day() + ":" + month() + ":" + year() + " " + hour() + ":" + minute() + ":" + second();
}

  public String generate_dtg_file()
  {
    return day() + "_" + month() + "_" + year() + " " + hour() + "_" + minute() + "_" + second();
  }

public void btn_exit_click(GButton source, GEvent event) 
  { //_CODE_:btn_exit_click:443832:
  if(source == btn_exit && event == GEvent.CLICKED)
    {  
    System.exit(0);
    }
  } //_CODE_:btn_exit_click:443832:
  
public void btn_open_click(GButton source, GEvent event)
  { //_CODE_:btn_open_click:443832:
  if(source == btn_open && event == GEvent.CLICKED)
    {   
    new_serial = new serial_gui(this, x_location, y_location);   
    }
  } //_CODE_:btn_open_click:443832: 
  

public void btn_file_open_click(GButton source, GEvent event) 
  { //_CODE_:btn_file_open_click:443832:
  if(source == btn_file_open && event == GEvent.CLICKED)
    {
      Logger.info("btn_file_open_click clicked");
    try
      {
        for(int i = 0; i < 4; i++)
        {
          if (new_serial.specific_process[i].getPort_is_open() == true)
            {
            data_dump[i] = open_for_write_to_file(this, i);
            }
          else
          {
            Logger.info("Comm port not yet open :- " + this);
            println("Comm port not yet open");
          }
        }
      }
    catch (Exception e)
      {
        Logger.info("Comm port not yet open or file already open :- " + this);
        println("Comm port not yet open or file already open");
      }
    }
  } //_CODE_:btn_file_open_click:443832: 
  
// Example to send data out the serial port using a button.
// Note Comm Port needs to be open for following function to work

public void btn_send_click(GButton source, GEvent event) throws Exception
  { //_CODE_:btn_send_click:443832:
  if(source == btn_send && event == GEvent.CLICKED)
    {
      try
      {
      String send_string = txt_string_to_send.getText() + " " + new_serial.specific_process[associated_process].getMyPortname();
      new_serial.specific_process[associated_process].send_serial_command(send_string, 100, false);
      }  
    catch(Exception e)
      {
      Logger.info("Comm port not yet open :- " + this);
      println("Comm port not yet open");
      }
    }
  } //_CODE_:btn_send_click:443832:

public void serialEvent(Serial p)
{
  if(operate_on_new_serial_event(p) == true)
    {
    String inString = return_rx_serial_data(p);
    String writeinString = "";
    Logger.info("Serial Event " + return_serial_port_name(p) + " :- " + inString +  " Process :- " + p);
    int port_that_caused_event = which_port_generated_serial_event(p);
    if(data_dump[port_that_caused_event] != null)
      {
        if(opt_date_time_stamp.isSelected() == true)
          {
          writeinString = generate_dtg() + "," + inString;
          }
        else
        {
          writeinString = inString;
        }
        data_dump[port_that_caused_event].file_append(writeinString + "\n");
        println(return_serial_port_name(p) + " :- " + writeinString);
      }
    else {
      writeinString = inString;
      println("Serial Event " + return_serial_port_name(p) + " :- " + writeinString + " Process :- " + p);
    }

    }
}

@SuppressWarnings("unused")
public void handleButtonEvents(GButton button, GEvent event) 
{ /* code */ 

}  

  public void handlePanelEvents(GPanel panel, GEvent event) { /* code */ }
  public void handleToggleControlEvents(GToggleControl option, GEvent event) { /* code */ }
  public void handleTextEvents(GEditableTextControl textcontrol, GEvent event) { /* code */ }
