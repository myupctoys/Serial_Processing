import at.mukprojects.console.Console;
import g4p_controls.G4P;
import g4p_controls.GButton;
import org.pmw.tinylog.Logger;

serial_gui new_serial;

GButton btn_exit;
GButton btn_open;
GButton btn_send;
GButton btn_file_open;

public String Serial_Config_Version = "0_0_2";
public Console console;
public static int associated_process = 0;
public file_class data_dump;

void setup()
{
  size(500,300); 
  noLoop();
  configure_logger();
  change_logger_output(LOGGER.FILE_LOGGER);    // LOGGER.FILE_LOGGER if you want to move debug logging to a file.
                                               // File will be here ./data/log.txt
  version_info();
  
  btn_exit = new GButton(this, 430, 260, 65, 30);
  btn_exit.setText("Exit");
  btn_exit.addEventHandler(this, "btn_exit_click"); 
  
  btn_open = new GButton(this, 10, 260, 65, 30);
  btn_open.setText("Open");
  btn_open.addEventHandler(this, "btn_open_click"); 
  
  btn_send = new GButton(this, 85, 260, 65, 30);
  btn_send.setText("Send");
  btn_send.addEventHandler(this, "btn_send_click");
  
  btn_file_open = new GButton(this, 160, 260, 65, 30);
  btn_file_open.setText("File Open");
  btn_file_open.addEventHandler(this, "btn_file_open_click"); 
  console = new Console(this);
  console.start();
  loop();
}

void draw()
{
  console.draw(10, height - height +10, width-20, height - 60, 14, 10, 4, 4, color(220), color(0), color(0, 255, 0));
  console.print();
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
    new_serial = new serial_gui(this);   
    }
  } //_CODE_:btn_open_click:443832: 
  

public void btn_file_open_click(GButton source, GEvent event) 
  { //_CODE_:btn_file_open_click:443832:
  if(source == btn_file_open && event == GEvent.CLICKED)
    {
    try
      {
       data_dump = open_for_write_to_file(this, associated_process);
      }
    catch (Exception e)
      {
        Logger.info("Comm port not yet open :- " + this);
        println("Comm port not yet open");
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
      String send_string = "Stefan Morley " + new_serial.specific_process[associated_process].getMyPortname();
      new_serial.specific_process[associated_process].send_serial_command(send_string, 100, false);
      }  
    catch(Exception e)
      {
      Logger.info("Comm port not yet open :- " + this);
      println("Comm port not yet open");
      }
    }
  } //_CODE_:btn_send_click:443832:

void serialEvent(Serial p) 
{
  if(operate_on_new_serial_event(p) == true)
    {
    String inString = return_rx_serial_data(p);
    Logger.info("Serial Event " + return_serial_port_name(p) + " :- " + inString +  " Process :- " + p);
    println("Serial Event " + return_serial_port_name(p) + " :- " + inString +  " Process :- " + p);
    if(data_dump != null)
        data_dump.file_append(inString + "\n");
    }
}

@SuppressWarnings("unused")
public void handleButtonEvents(GButton button, GEvent event) 
{ /* code */ 

}  
